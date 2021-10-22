//
//  WeatherData.swift
//  Clima
//
//  Created by Gabriel on 12/10/21.
//

import Foundation

struct WeatherData : Decodable {
  let name: String
  let main: Main
  let weather: [WeatherDescription]
}

struct Main : Decodable {
  let temp: Double
  let feels_like: Double
  let humidity: Int
}

struct WeatherDescription : Decodable {
  let id: Int
  let description: String 
}
