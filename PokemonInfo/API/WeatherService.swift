//
//  WeatherService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

class WeatherService {
    
    func getWeather(completion: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let temperature = Int.random(in: -20...35)
            completion(temperature)
        }
    }
    
}
