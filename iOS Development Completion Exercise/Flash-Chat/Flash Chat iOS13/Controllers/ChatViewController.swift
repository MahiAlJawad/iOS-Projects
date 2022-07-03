//
//  ChatViewController.swift
//  Flash Chat iOS13
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: Constants.cellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.cellIdentifier
        )
        
        loadMessages()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))) // dismisses the keybaord when selected outside the textField i.e. on the view
                // Do any additional setup after loading the view.
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let message = messageTextfield.text, let userEmail = Auth.auth().currentUser?.email else {
            print("Failed getting message or user email")
            return
        }
        
        messageTextfield.text = ""
        
        saveMessageToCloud(userEmail: userEmail, message: message)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Signed out")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            showAlert("Failed signing out", "Something went wrong. Failed signing out!")
        }
        
    }
    
    func showAlert(_ title: String, _ message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: TableView Data Source functions
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        
        if Auth.auth().currentUser?.email == messages[indexPath.row].sender { // Own message
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
        } else { // Recepients message
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.blue)
        }
        
        cell.message.text = messages[indexPath.row].body
        
        return cell
    }
}

// MARK: Read-Write in Firebase
extension ChatViewController {
    func loadMessages() {
        let db = Firestore.firestore()
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField) // Order by date
            .addSnapshotListener { querySnapshot, error in
                guard error == nil, let querySnapshot = querySnapshot else {
                    print("Error fetching data from Firestore")
                    return
                }
                
                if self.messages.count == 0 { // i.e. First load
                    let records = querySnapshot.documents.map { $0.data() }
                    
                    records.map { record in
                        if let sender = record[Constants.FStore.senderField] as? String,
                           let message = record[Constants.FStore.bodyField] as? String {
                            let message = Message(sender: sender, body: message)
                            self.messages.append(message)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let lastRow = self.tableView.numberOfRows(inSection: 0) - 1
                        let lastIndexPath = IndexPath(item: lastRow, section: 0)
                        self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false) // scroll to the last message
                    }
                } else { // Single message sent
                    let record = querySnapshot.documents.map { $0.data() }.last

                    if let record = record,
                       let sender = record[Constants.FStore.senderField] as? String,
                       let message = record[Constants.FStore.bodyField] as? String {
                        let message = Message(sender: sender, body: message)
                        print("Message found: \(message)")
                        self.messages.append(message)
                        
                        // load only the last message
                        let index = self.messages.count - 1
                        let indexPath = IndexPath(item: index, section: 0)
                        
                        DispatchQueue.main.async {
                            self.tableView.insertRows(at: [indexPath], with: .automatic) // insert the last message
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) // scroll to the last message
                        }
                    }
                }
            }
    }
    
    func saveMessageToCloud(userEmail: String, message: String) {
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            Constants.FStore.senderField: userEmail,
            Constants.FStore.bodyField: message,
            Constants.FStore.dateField: Date().timeIntervalSince1970
        ]
        
        // Here collectionName can be considered as the table name
        // In data, we save as dictionary, the key of the dictionary represents the
        // fieldName or atribute in a database
        
        db.collection(Constants.FStore.collectionName).addDocument(data: data) { error in
            guard error == nil else {
                print("Failed saving data")
                return
            }
            
            print("Data saved successfully")
        }
    }
}
