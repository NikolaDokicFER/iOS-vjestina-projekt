//
//  CityNameModel.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 09.06.2022..
//

import Foundation

struct CityNameModel: Codable{
    let lon: Float
    let lat: Float
    let name: String
    
    init(fromModel model: City) {
        self.lon = model.lon
        self.lat = model.lat
        self.name = model.name!
    }
    
    init(name: String, lon: Float, lat: Float){
        self.lon = lon
        self.lat = lat
        self.name = name
    }
}
