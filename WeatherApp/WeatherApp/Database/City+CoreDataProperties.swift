//
//  City+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Nikola Đokić on 08.06.2022..
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var lat: Float
    @NSManaged public var lon: Float
    @NSManaged public var name: String?

}

extension City : Identifiable {

}
