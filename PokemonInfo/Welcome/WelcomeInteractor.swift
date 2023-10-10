//
//  WelcomeInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

// works with data services
protocol WelcomeInteractorProtocol {
    func loadDate()
    func loadWeather()
}

class WelcomeInteractor {
    
    weak var presenter: WelcomePresenterProtocol?
    let dataService: DateService
    let weatherService: WeatherService
    
    init(dataService: DateService, weatherService: WeatherService) {
        self.dataService = dataService
        self.weatherService = weatherService
    }
    
}

extension WelcomeInteractor: WelcomeInteractorProtocol {
    
    func loadDate() {
        dataService.getDate { [weak self] date in
            self?.presenter?.didLoad(date: date.description)
        }
    }
    
    func loadWeather() {
        weatherService.getWeather { [weak self] temperature in
            self?.presenter?.didLoad(temperature: temperature)
        }
    }
    
}
