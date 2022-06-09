//
//  CityNameModel.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 09.06.2022..
//

import Foundation

struct CityNameModel: Codable{
    var lon: Float
    var lat: Float
    var name: String
    
    init(fromModel model: City) {
        self.lon = model.lon
        self.lat = model.lat
        self.name = model.name!
    }
}
