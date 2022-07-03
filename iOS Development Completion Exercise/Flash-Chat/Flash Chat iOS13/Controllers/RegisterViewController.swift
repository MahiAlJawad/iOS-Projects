//
//  RegisterViewController.swift
//  Flash Chat iOS13
//

import FirebaseAuth
import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            showInvalidCredentialError()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            guard error == nil else {
                self.showAlert("Invalid Email Or Password", error?.localizedDescription)
                return
            }
            print("Registered and Signed In")
            self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
        }
        
    }
    
    func showInvalidCredentialError() {
        let alert = UIAlertController(
            title: "Invalid Email or Password",
            message: "Please enter a valid Email and Password",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
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
