//
//  DataBaseSource.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 09.06.2022..
//

import Foundation
import CoreData

class DataBaseSource{
    private var citiesRepository: CitiesRepository!
    
    init(){
        citiesRepository = CitiesRepository()
    }
    
    func saveCity(name: String, lat: Float, lon: Float){
        citiesRepository.saveCity(name: name, lat: lat, lon: lon)
    }
    
    func fetchCities() -> [CityNameModel]{
        lazy var cities: [CityNameModel] = {
            let dbCities = citiesRepository.fetchCities()
        return dbCities.map { CityNameModel(fromModel: $0) }
        }()
        
        return cities
    }
    
    func deleteCity(name: String){
        citiesRepository.deleteCity(name: name)
    }
}
