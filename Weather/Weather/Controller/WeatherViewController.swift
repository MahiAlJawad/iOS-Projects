//
//  ViewController.swift
//  Weather
//
//  Created by Mahi Al Jawad on 04/06/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchBar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))) // dismisses the keybaord when selected outside the textField i.e. on the view
        // Do any additional setup after loading the view.
    }


    @IBAction func searchTapped(_ sender: Any) {
        print("Searched: \(searchBar.text)")
        // get the result
        searchBar.endEditing(true)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    // called when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Searched: \(textField.text)")
        // get the result
        searchBar.endEditing(true)
        return true
    }
    
    // keyboard hides when returned true
    // Check validations of the text if needed
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // called after keyboard hidden, editing is done
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
