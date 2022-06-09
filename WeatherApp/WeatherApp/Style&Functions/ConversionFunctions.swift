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
    
    //wind speed
    func toKmPerHour(metersPerSecond: Float) -> Float {
        let value = 3.6 * metersPerSecond
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    func toMilesPerHour(metersPerSecond: Float) -> Float {
        let value = 2.23693629 * metersPerSecond
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    func toMilesPerSecond(metersPerSecond: Float) -> Float {
        let value = 0.000621371192 * metersPerSecond
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    func toKnots(metersPerSecond: Float) -> Float {
        let value = 1.94384449 * metersPerSecond
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    
    //pressure - hPa is default unit
    func toAtm(hPa: Float) -> Float {
        let value = 0.000986923267 * hPa
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    func toInHg(hPa: Float) -> Float {
        let value = 0.02953 * hPa
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
    func tomBar(hPa: Float) -> Float { //same as hPa
        return hPa
    }
    func toMmHg(hPa: Float) -> Float {
        let value = 0.75006 * hPa
        let roundedValue = round(value * 10) / 10.0
        return roundedValue
    }
}
