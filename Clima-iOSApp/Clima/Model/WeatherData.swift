//
//  WeatherData.swift
//  Clima
//
//  Created by Islam Rzayev on 03.11.24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation


import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Codable { 
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
}
