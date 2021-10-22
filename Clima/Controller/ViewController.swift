//
//  ViewController.swift
//  Clima
//
//  Created by Gabriel on 09/10/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var cityInput: UITextField!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var feelsLikeLabel: UILabel!
  @IBOutlet weak var tempImage: UIImageView!
  
  var weatherManger = WeatherManager()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
    
    cityInput.delegate = self
    weatherManger.delegate = self
    
    cityInput.layer.cornerRadius = 15.0
    cityInput.layer.borderWidth = 2.0
    cityInput.layer.borderColor = UIColor(named: "Icons")?.cgColor
    cityInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: cityInput.frame.height))
    cityInput.leftViewMode = .always
    
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManger.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
  
  @IBAction func search(_ sender: UIButton) {
    cityInput.endEditing(true)
  }
  
  @IBAction func updateLocation(_ sender: UIButton) {
    locationManager.requestLocation()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    cityInput.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Type something"
      return false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if let city = cityInput.text {
      weatherManger.fetchWeather(city: city)
    }
    
    cityInput.text = ""
  }
  
}

extension ViewController: WeatherManagerDelegate {
  
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weather) {
    DispatchQueue.main.async {
      self.cityLabel.text = weather.city
      self.temperatureLabel.text = weather.temperatureString
      self.tempImage.image = UIImage(systemName: weather.conditionName)
      self.feelsLikeLabel.text = weather.feelsLikeString
    }
  }
  
  func didiFailWithError(error: Error) {
    print(error)
  }
}


