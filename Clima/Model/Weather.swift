//
//  WeatherModel.swift
//  Clima
//
//  Created by Gabriel on 11/10/21.
//

import Foundation

import Foundation

struct Weather {
    let conditionId: Int
    let city: String
    let temperature: Double
    let feels_like: Double
    let humidity: Int
    
    var temperatureString: String {
        return " \(String(format: "%.0f", temperature))º"
    }
  
    var feelsLikeString: String {
      return " Feels Like \(String(format: "%.0f", feels_like))º"
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
