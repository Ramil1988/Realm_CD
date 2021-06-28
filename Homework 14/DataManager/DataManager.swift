//
//  DataManager.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 16.06.2021.
//

import Foundation

class DataManager {
    
    var realmManager = RealmManager()
    
    func saveWeather (name: String, weatherImage: String, weatherDescription: String, weatherTemperature: Double) {
       realmManager.saveWeather(name: name, weatherImage: weatherImage, weatherDescription: weatherDescription, weatherTemperature: weatherTemperature)
    }
    
    func getWeather() -> WeatherRealm? {
        return realmManager.getWeather()
    }
}














