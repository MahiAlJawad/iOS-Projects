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
    func didFailedFetchingWeather(_ error: Error)
}

final class WeatherViewModel {
    var delegate: WeatherModelDelegate!
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=840e87c33a9450fb4e7ac01c5cbdeefa&units=metric"
    
    private func parseJSON(with data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            return WeatherModel(
                cityName: weatherData.name,
                temperature: weatherData.main.temp,
                realFeel: weatherData.main.feels_like,
                weatherConditionID: weatherData.weather.first?.id ?? 0
            )
        } catch {
            delegate.didFailedFetchingWeather(error)
            return nil
        }
    }
    
    func performRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] data, urlResponse, error in
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
    
    func fetchWeather(by locationCoordinate: CLLocationCoordinate2D) {
        let lat = locationCoordinate.latitude
        let lon = locationCoordinate.longitude
        
        let urlString = "\(baseURL)&lat=\(lat)&lon=\(lon)"
        
        print("URL String: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Failed making URL with lattitude: \(lat) and longitude: \(lon)")
            return
        }
        
        performRequest(with: url)
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
