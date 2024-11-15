//
//  WeatherManager.swift
//  Clima
//
//  Created by Islam Rzayev on 03.11.24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{

    func didUpdateWeather(_ weatheerManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=10c7a9c1bacf960913362df9d3dbaeda&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest( with urlString: String){
        //       1) Create a URl
        
        if let url = URL(string: urlString){
            
            //       2) Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //       3) Give The session a task
            
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeDate = data{
                    let dataString = String(data: safeDate, encoding: .utf8)
                    if let weather = parseJSON(safeDate) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //       4) Start the task
            
            task.resume()
            
            
        }
        
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionid: id, cityName: name, temperature: temp)
            return weather
            
            
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}
