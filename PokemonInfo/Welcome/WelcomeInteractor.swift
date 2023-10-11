//
//  WelcomeInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

// interactor works with data services
protocol WelcomeInteractorProtocol {
    func loadDate()
    func loadWeather()
}

class WelcomeInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: WelcomePresenterProtocol?
    let dataService: DateServiceProtocol
    let weatherService: WeatherServiceProtocol
    
    // MARK: Initialisers
    
    init(dataService: DateService, weatherService: WeatherService) {
        self.dataService = dataService
        self.weatherService = weatherService
    }
    
}

// MARK: - WelcomeInteractorProtocol

extension WelcomeInteractor: WelcomeInteractorProtocol {
    
    // MARK: Public Methods
    
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
