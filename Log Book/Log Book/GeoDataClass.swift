//
//  GeoDataClass.swift
//  Log Book
//
//  Created by Татьяна Тищенко  on 08.06.2021.
//

import Foundation

class GeoData {
    var latitude: Double
    var longitude: Double
    var course: Double
    var speed: Double
    var address: String
    var dt : Date
    
    init (latitude: Double, longitude: Double, course: Double, speed: Double, address: String, dt: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.course = course
        self.speed = speed
        self.address = address
        self.dt = dt
    }
}
