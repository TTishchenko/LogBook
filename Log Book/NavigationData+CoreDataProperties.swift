//
//  NavigationData+CoreDataProperties.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 08.06.2021.
//
//

import Foundation
import CoreData


extension NavigationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NavigationData> {
        return NSFetchRequest<NavigationData>(entityName: "NavigationData")
    }

    @NSManaged public var address: String?
    @NSManaged public var course: Float
    @NSManaged public var dt: Date?
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var speed: Float
    @NSManaged public var wind: Float
    @NSManaged public var wind_speed: Float

}

extension NavigationData : Identifiable {

}
