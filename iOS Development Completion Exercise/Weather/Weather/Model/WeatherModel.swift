//
//  WeatherModel.swift
//  Weather
//
//  Created by Mahi Al Jawad on 5/6/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Float
    let realFeel: Float
    let weatherConditionID: Int
    let weatherConditionStatus: String
    
    var weatherIcon: String {
        switch weatherConditionID {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800:       return "sun.max"
        case 801...804: return "cloud.bolt"
        default:        return "sun.max"
        }
    }
    
    var temparatureDescription: String { String(format: "%.1f", temperature) }
    
    var realFeelDescription: String { String(format: "%.1f", realFeel) }
}
