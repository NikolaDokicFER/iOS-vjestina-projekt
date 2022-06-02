//
//  RequestError.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 01.06.2022..
//

import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
}
