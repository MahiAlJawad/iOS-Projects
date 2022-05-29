import UIKit

class ShareBillViewController: UIViewController {
    @IBOutlet weak var tipButton1: UIButton!
    @IBOutlet weak var tipButton2: UIButton!
    @IBOutlet weak var tipButton3: UIButton!
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var numberOfSplits: UILabel!
    
    var shareBillViewModel: ShareBillViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))) // dismisses the keybaord when selected outside the textField i.e. on the view
    }
    
    func resetTip() {
        tipButton1.isSelected = false
        tipButton2.isSelected = false
        tipButton3.isSelected = false
    }
    
    @IBAction func tipTapped(_ sender: Any) {
        billTextField.endEditing(true) //dismisses the keyboard when pressed this controller
        let tipButton = sender as! UIButton
        let tipText = tipButton.currentTitle
        
        resetTip()
        tipButton.isSelected = true
        
        switch tipText {
        case "0%": print("Selected 0%")
        case "10%": print("Selected 10%")
        case "20%": print("Selected 20%")
        default: break
        }
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        billTextField.endEditing(true) //dismisses the keyboard when pressed this controller
        print("Stepper tapped")
        let stepper = sender as! UIStepper
        print("Value cahnged: \(stepper.value)")
        numberOfSplits.text = "\(Int(stepper.value))"
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        let totalBill = Float(billTextField.text ?? "0") ?? 0.0
        let numberOfSplits = Int(numberOfSplits.text ?? "0") ?? 0
        
        var tipPercentage: Int {
            if tipButton1.isSelected {
                return 0
            } else if tipButton2.isSelected {
                return 10
            } else {
                return 20
            }
        }
        
        shareBillViewModel = ShareBillViewModel(
            totalBill: totalBill,
            numberOfPeople: numberOfSplits,
            tipPercentage: tipPercentage
        )
        
        guard let result = shareBillViewModel.result else {
            showAlert()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: self)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please enter all Information Carefully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResult" else { return }
        guard let destinationVC = segue.destination as? ResultViewController else { return }
        destinationVC.result = shareBillViewModel.result
    }
}

