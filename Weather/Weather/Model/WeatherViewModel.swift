//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mahi Al Jawad on 5/6/22.
//

import CoreLocation
import Foundation

protocol WeatherModelDelegate {
    func didFetchedWeather(_ weatherData: WeatherModel?)
    func didFetchCurrentLocationWeather(_ weatherData: WeatherModel?)
    func didFailedFetchingWeather(_ error: Error)
    func didFetchedLocation(_ locationName: String)
    func didFailedFetchingLocation(_ error: Error)
}

final class WeatherViewModel {
    var delegate: WeatherModelDelegate!
    
    let apiID = "" // Add own appID from openweathermap.org
    
    var baseURL: String {
        "https://api.openweathermap.org/data/2.5/weather?appid=\(apiID)&units=metric"
    }
    
    var baseLocationURL: String {
        "https://api.openweathermap.org/geo/1.0/reverse?appid=\(apiID)"
    }
}

// MARK: Weather Data fetching APIs
extension WeatherViewModel {
    private func parseJSON(with data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            return WeatherModel(
                cityName: weatherData.name,
                temperature: weatherData.main.temp,
                realFeel: weatherData.main.feels_like,
                weatherConditionID: weatherData.weather.first?.id ?? 0,
                weatherConditionStatus: weatherData.weather.first?.main ?? ""
            )
        } catch {
            delegate.didFailedFetchingWeather(error)
            return nil
        }
    }
    
    func performRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil, let data = data, let self = self else {
                guard let error = error else {
                    print("Found data nil: \(String(describing: data))")
                    return
                }
                self?.delegate.didFailedFetchingWeather(error)
                return
            }
            
            let weatherData = self.parseJSON(with: data)
            self.delegate.didFetchedWeather(weatherData)
        }
        
        task.resume()
    }
    
    func fetchCurrentLocationWeather(with url: URL) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil, let data = data, let self = self else {
                guard let error = error else {
                    print("Found data nil: \(String(describing: data))")
                    return
                }
                self?.delegate.didFailedFetchingWeather(error)
                return
            }
            
            let weatherData = self.parseJSON(with: data)
            self.delegate.didFetchCurrentLocationWeather(weatherData)
        }
        
        task.resume()
    }
    
    func fetchWeather(by locationCoordinate: CLLocationCoordinate2D) {
        let lat = locationCoordinate.latitude
        let lon = locationCoordinate.longitude
        
        let urlString = "\(baseURL)&lat=\(lat)&lon=\(lon)"
        
        print("URL String: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Failed making URL with lattitude: \(lat) and longitude: \(lon)")
            return
        }
        
        fetchCurrentLocationWeather(with: url)
    }
    
    
    func fetchWeather(by cityName: String) {
        guard !cityName.isEmpty else {
            print("City Name cannot be empty")
            return
        }
        
        let urlString = "\(baseURL)&q=\(cityName)"
        
        guard let url = URL(string: urlString) else {
            print("Failed making URL with \(cityName)")
            return
        }
        
        performRequest(with: url)
    }
}

// MARK: Location fetching API
extension WeatherViewModel {
    func fetchLocation(by locationCoordinate: CLLocationCoordinate2D) {
        let lat = locationCoordinate.latitude
        let lon = locationCoordinate.longitude
        
        // make request url
        let urlString = "\(baseLocationURL)&lat=\(lat)&lon=\(lon)"
        
        print("URL String: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Failed making url")
            return
        }
        
        // fetch location data
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil, let data = data, let self = self else {
                guard let error = error else {
                    print("Found data nil: \(String(describing: data))")
                    return
                }
                self?.delegate.didFailedFetchingLocation(error)
                return
            }
            
            // parse json data
            let decoder = JSONDecoder()
            
            do {
                let locations = try decoder.decode([Location].self, from: data)
                // sending parsed data to the delegate method
                self.delegate.didFetchedLocation(locations.first?.name ?? "")
            } catch {
                // sending if failed parsing json data
                self.delegate.didFailedFetchingLocation(error)
            }
        }
        
        // starting the task
        task.resume()
    }
}
