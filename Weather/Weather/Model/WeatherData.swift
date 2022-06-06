//
//  WeatherData.swift
//  Weather
//
//  Created by Mahi Al Jawad on 5/6/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Main: Codable {
    let temp: Float
    let feels_like: Float
}

struct Location: Codable {
    let name: String
}
