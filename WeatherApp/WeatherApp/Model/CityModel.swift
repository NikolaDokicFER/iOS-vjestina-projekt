//
//  CityModel.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 02.06.2022..
//

import Foundation

struct CityModel: Codable {
    let coord: Cordinates
    let sys: Sys
    let cod: Int
}

struct Cordinates: Codable {
    let lon: Float
    let lat: Float
}

struct Sys: Codable {
    let country: String}

