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
    
    let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))) // dismisses the keybaord when selected outside the textField i.e. on the view
        // Do any additional setup after loading the view.
    }

    func getWeather(of city: String) {
        guard !city.isEmpty else {
            let alert = UIAlertController(
                title: "Invalid City", message: "Please enter a valid city name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        weatherViewModel.fetchWeather(by: city)
    }

    @IBAction func searchTapped(_ sender: Any) {
        print("Searched: \(searchBar.text)")
        getWeather(of: searchBar.text ?? "")
        searchBar.endEditing(true)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    // called when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Searched: \(textField.text)")
        getWeather(of: searchBar.text ?? "")
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
