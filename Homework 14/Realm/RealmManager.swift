//
//  RealmManager.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 16.06.2021.
//

import Foundation
import RealmSwift

//класс который отвечает за общение с Реалмом

class RealmManager {
    let realm = try! Realm()  // точка доступа к реалму
    var items: Results<TaskObject>!
    
    func saveWeather(name: String, weatherImage: String, weatherDescription: String, weatherTemperature: Double) {
        let weatherObject = WeatherObject()
        weatherObject.weatherCityName = name
        weatherObject.weatherImage = weatherImage
        weatherObject.weatherDescription = weatherDescription
        weatherObject.weatherTemperature = weatherTemperature
        
        try? realm.write { () -> Void in
            realm.add(weatherObject)
        }
    }
    
    func getWeather() -> WeatherRealm {
        let objects = realm.objects(WeatherObject.self).last// обратились к базе данных и взяли сохраненные задачи
        let weather = WeatherRealm(name: objects?.weatherCityName, feelsLike: objects?.weatherTemperature, icon: objects?.weatherImage, weatherDescription: objects?.weatherDescription)
        return weather
    }
}
