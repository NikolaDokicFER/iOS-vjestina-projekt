//
//  CitiesRepository.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 08.06.2022..
//

import Foundation
import CoreData

class CitiesRepository{
    private var cities: [City] = []
    private var coreDataStack: CoreDataStack!
    
    init(){
        coreDataStack = CoreDataStack()
    }
    
    func saveCity(name: String, lat: Float, lon: Float){
        let managedContext = coreDataStack.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        
        if(checkIfExists(name: name)){
            return
        }
        
        let city = City(entity: entity, insertInto: managedContext)
        
        city.name = name
        city.lat = lat
        city.lon = lon
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save \(error)")
        }
    }
    
    func fetchCities() -> [City]{
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            let cities = try managedContext.fetch(request)
            return cities
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func deleteCity(name: String){
        let managedContext = coreDataStack.persistentContainer.viewContext
        guard let city = fetchCity(name: name) else {return}
        managedContext.delete(city)
        do {
            try managedContext.save()
        }
        catch {
            print("error executing fetch request: \(error)")
            return
        }
    }
    
    private func fetchCity(name: String) -> City?{
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", "\(name)")
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            return try managedContext.fetch(request).first
        }
        catch {
            print("error executing fetch request: \(error)")
            return nil
        }
    }
    
    private func checkIfExists(name: String) -> Bool{
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", "\(name)")
        request.predicate = predicate
        
        var results: [City] = []

        do {
            results = try managedContext.fetch(request)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0
    }
}
