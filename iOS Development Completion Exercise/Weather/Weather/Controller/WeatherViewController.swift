//
//  ViewController.swift
//  Weather
//
//  Created by Mahi Al Jawad on 04/06/2022.
//

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var realFeelLabel: UILabel!
    
    @IBOutlet weak var searchBar: UITextField!
    
    let weatherViewModel = WeatherViewModel()
    var locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        weatherViewModel.delegate = self
        
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        resetToCurrentLocation()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))) // dismisses the keybaord when selected outside the textField i.e. on the view
        // Do any additional setup after loading the view.
    }

    func getWeather(of city: String) {
        guard !city.isEmpty else {
            showInvalidCityAlert()
            return
        }
        
        var searchText: String {
            if city.last == " " { // in case of keyboard suggestion the last character is empty space
                return String(city.dropLast())
            } else {
                return city
            }
        }
        
        print("Requesting to get weather of: \(searchText)")
        
        weatherViewModel.fetchWeather(by: searchText)
    }

    @IBAction func searchTapped(_ sender: Any) {
        print("Searched: \(String(describing: searchBar.text))")
        
        getWeather(of: searchBar.text ?? "")
        searchBar.endEditing(true)
    }
    
    @IBAction func resetLocation(_ sender: Any) {
        resetToCurrentLocation()
    }
}

// MARK: TextField delegate
extension WeatherViewController: UITextFieldDelegate {
    // called when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Searched: \(String(describing: textField.text))")
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

// MARK: Weather Fetch Delegate
extension WeatherViewController: WeatherModelDelegate {
    func didFetchCurrentLocationWeather(_ weatherData: WeatherModel?) {
        guard let weatherData = weatherData else {
            print("Failed fetching weather data")
            return
        }
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.temparatureDescription
            self.conditionImageView.image = UIImage(systemName: weatherData.weatherIcon)
            self.conditionDescriptionLabel.text = weatherData.weatherConditionStatus
            self.realFeelLabel.text = weatherData.realFeelDescription
        }
    }
    
    func didFetchedLocation(_ locationName: String) {
        print("Updating city name: \(locationName)")
        DispatchQueue.main.async {
            self.cityLabel.text = locationName
        }
    }
    
    func didFailedFetchingLocation(_ error: Error) {
        print("Error fetching location data")
    }
    
    func didFetchedWeather(_ weatherData: WeatherModel?) {
        guard let weatherData = weatherData else {
            print("Failed fetching weather data")
            return
        }
        DispatchQueue.main.async {
            self.cityLabel.text = weatherData.cityName
            self.temperatureLabel.text = weatherData.temparatureDescription
            self.conditionImageView.image = UIImage(systemName: weatherData.weatherIcon)
            self.conditionDescriptionLabel.text = weatherData.weatherConditionStatus
            self.realFeelLabel.text = weatherData.realFeelDescription
        }
    }
    
    func didFailedFetchingWeather(_ error: Error) {
        print("Error fetching weather data: \(error)")
    }
}

// MARK: LocationManager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            showNetworkAlert()
            return
        }
        manager.stopUpdatingLocation()
        print("Found lat: \(location.coordinate.latitude) long: \(location.coordinate.longitude)")
        weatherViewModel.fetchWeather(by: location.coordinate)
        weatherViewModel.fetchLocation(by: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in getting current location")
        showNetworkAlert()
    }
    
    func resetToCurrentLocation() {
        locationManger.requestLocation()
    }
}

// MARK: Alerts
private extension WeatherViewController {
    func showInvalidCityAlert() {
        let alert = UIAlertController(
            title: "Invalid City", message: "Please enter a valid city name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func showNetworkAlert() {
        let alert = UIAlertController(title: "Please Check Your Connection", message: "Something went wrong, Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
