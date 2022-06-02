//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Jurica Mikulic on 01.06.2022..
//

import Foundation
import CoreLocation

protocol NetworkServiceProtocol {
}

class NetworkService {
    
    let weatherURL = ""
    
    func getWeatherData(cityLat: Float, cityLon: Float, completionHandler: @escaping (Result<WeatherModel, RequestError>) -> Void) {
        
        let stringLat = String(cityLat)
        let stringLon = String(cityLon)
        
        let urlString = "\(weatherURL)&lat=\(stringLat)&lon=\(stringLon)"
        let url = URL(string: urlString)
    
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    func getLocation(cityName: String, completionHandler: @escaping (Result<CityModel, RequestError>) -> Void) {
        
        let urlString = ""
        
        let url = URL(string: urlString)
    
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    
    //function for current location
    func getWeatherDataByLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (Result<WeatherModel, RequestError>) -> Void) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        let url = URL(string: urlString)
    
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        executeUrlRequest(request, completionHandler: completionHandler)
    }
    
    private func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.decodingError))
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(value))
            }
        }
        
        dataTask.resume()
    }
    
}
