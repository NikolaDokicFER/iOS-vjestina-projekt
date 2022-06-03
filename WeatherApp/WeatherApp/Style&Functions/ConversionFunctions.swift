//
//  ConversionFunctions.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 02.06.2022..
//

import Foundation

struct ConversionFunctions {
    
    func toCelsius(kelvin: Float) -> Float {
        let value = kelvin - 273.15
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    
    func toFahrenheit(kelvin: Float) -> Float {
        let value = 1.8 * (kelvin - 273) + 32
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
}
