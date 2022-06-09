//
//  WeatherIcons.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 02.06.2022..
//

import Foundation

struct WeatherIcons {
    
    func weatherIcon(conditionId: Int) -> String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    func windIcon(degree: Float) -> String{
        switch degree{
        case 0...22.5:
            return "arrow.up.circle"
        case 22.5...67.5:
            return "arrow.up.right.circle"
        case 67.5...112.5:
            return "arrow.right.circle"
        case 112.5...157.5:
            return "arrow.down.right.circle"
        case 157.5...202.5:
            return "arrow.down.circle"
        case 202.5...247.5:
            return "arrow.down.left.circle"
        case 247.5...292.5:
            return "arrow.left.circle"
        case 292.5...337.5:
            return "arrow.up.left.circle"
        default:
            return "arrow.up.circle"
        }
    }
}
