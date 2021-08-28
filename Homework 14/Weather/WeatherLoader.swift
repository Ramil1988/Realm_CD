//
//  WeatherLoader.swift
//  Homework 14
//
//  Created by Ramil Sharapov on 14.06.2021.
//

import Foundation

class WeatherLoader{
    
    static let shared = WeatherLoader()
    
    func loadWeather(nameOfCity: String, completion: @escaping (Forecast?) -> Void ) {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(nameOfCity)&appid=568c4f7da17eda5863c0c86d5401db43&units=metric")!
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else { return }
            guard let forecast = try? JSONDecoder().decode(Forecast.self, from: data) else { print("error decoding"); return }
            completion(forecast)
        }
        task.resume()
    }
}
