//
//  WeatherObject.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 16.06.2021.
//

import Foundation
import RealmSwift

class WeatherObject: Object {
    @objc dynamic var weatherCityName = ""
    @objc dynamic var weatherImage = ""
    @objc dynamic var weatherDescription = ""
    @objc dynamic var weatherTemperature = Double()
}
