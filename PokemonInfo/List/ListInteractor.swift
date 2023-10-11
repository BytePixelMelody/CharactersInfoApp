//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

// interactor works with data services
protocol ListInteractorProtocol {
    var currentTemperature: Int { get }

    func loadDate()
    func loadWeather()
}

class ListInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: ListPresenterProtocol?
    
    // MARK: Private Properties
    
    private let dataService: DateServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private var temperature = 0
    
    // MARK: Initialisers
    
    init(dataService: DateService, weatherService: WeatherService) {
        self.dataService = dataService
        self.weatherService = weatherService
    }
    
}

// MARK: - ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    
    // MARK: Public Properties
    
    var currentTemperature: Int {
        temperature
    }
    
    // MARK: Public Methods
    
    func loadDate() {
        dataService.getDate { [weak self] date in
            self?.presenter?.didLoad(date: date.description)
        }
    }
    
    func loadWeather() {
        weatherService.getWeather { [weak self] temperature in
            self?.presenter?.didLoad(temperature: temperature)
            self?.temperature = temperature
        }
    }
    
}
