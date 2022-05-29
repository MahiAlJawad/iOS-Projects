import UIKit

class ShareBillViewController: UIViewController {
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var numberOfSplits: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tipTapped(_ sender: Any) {
        let tipButton = sender as! UIButton
        let tipText = tipButton.currentTitle
        
        switch tipText {
        case "0%": print("Selected 0%")
        case "10%": print("Selected 10%")
        case "20%": print("Selected 20%")
        default: break
        }
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        
    }
}

