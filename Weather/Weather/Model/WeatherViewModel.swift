//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mahi Al Jawad on 5/6/22.
//

import Foundation

final class WeatherViewModel {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=840e87c33a9450fb4e7ac01c5cbdeefa&units=metric&q="
    
    func fetchWeather(by cityName: String) {
        guard !cityName.isEmpty else {
            print("City Name cannot be empty")
            return
        }
        
        guard let url = URL(string: baseURL+cityName) else {
            print("Failed making URL with \(cityName)")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, urlResponse, error in
            guard error == nil, let data = data else {
                print("Error fetching data: \(error)")
                return
            }
            
            print("URL response: \(urlResponse)")
            
            let dataString = String(data: data, encoding: .utf8)
            print("Fetched data: \(dataString)")
        }
        
        task.resume()
    }
}
