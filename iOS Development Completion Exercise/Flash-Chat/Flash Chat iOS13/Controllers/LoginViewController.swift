//
//  LoginViewController.swift
//  Flash Chat iOS13
//

import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            showInvalidCredentialError()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            guard error == nil else {
                self.showAlert("Invalid Email Or Password", error?.localizedDescription)
                return
            }
            print("Signed In")
            self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
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
