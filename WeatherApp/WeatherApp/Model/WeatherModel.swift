//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 01.06.2022..
//

import Foundation

struct WeatherModel: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let temp: Float
    let pressure: Float
    let humidity: Float
    let uvi: Float
    let windSpeed: Float
    let windDeg: Float
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case uvi
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct Hourly: Codable {
    let temp: Float
    let weather: [Weather]
}

struct Daily: Codable {
    let temp: Temp
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Temp: Codable {
    let min: Float
    let max: Float
}
