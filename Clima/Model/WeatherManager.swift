//
//  WeatherManager.swift
//  Clima
//
//  Created by Gabriel on 12/10/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather)
  func didiFailWithError(error: Error)
}

struct WeatherManager {
  let url = "https://api.openweathermap.org/data/2.5/weather?&appid=3f93c2f1c367de17d8876896b70dd678&units=metric"
  
  var delegate: WeatherManagerDelegate?
  
  func fetchWeather(city: String){
    let urlString = "\(url)&q=\(city)"
    self.performRequest(with: urlString)
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
    let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
    self.performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          delegate?.didiFailWithError(error: error!)
          return
        }
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      task.resume()
    }
  }
  
  func parseJSON(_ data: Data) -> Weather? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: data)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let feels_like = decodedData.main.feels_like
      let humidity = decodedData.main.humidity
      let city = decodedData.name
      
      let weather = Weather(conditionId: id, city: city, temperature: temp, feels_like: feels_like, humidity: humidity)
      
      return weather 
      
    } catch {
      delegate?.didiFailWithError(error: error)
      return nil
    }
  }
  
}
