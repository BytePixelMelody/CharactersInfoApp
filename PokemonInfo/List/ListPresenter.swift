//
//  ListPresenter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

protocol ListPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoad(date: String?)
    func didLoad(temperature: Int?)
    func didTapDetails()
}

class ListPresenter {
    
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    
    // MARK: Initialisers
    
    init(router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {

    // MARK: Public Methods
    
    func viewDidLoaded() {
        interactor.loadDate()
        interactor.loadWeather()
    }
    
    func didLoad(date: String?) {
        guard let date else {
            // TODO: - log error
            return
        }
        view?.showDate(date: date)
    }
    
    func didLoad(temperature: Int?) {
        guard let temperature else {
            // TODO: - log error
            return
        }
        view?.showWeather(temperature: temperature.description)
    }
    
    func didTapDetails() {
        let temperature = interactor.currentTemperature
        router.openDetails(for: temperature)
    }
    
}
