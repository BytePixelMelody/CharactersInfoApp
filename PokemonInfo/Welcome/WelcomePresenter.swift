//
//  WelcomePresenter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

protocol WelcomePresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoad(date: String?)
    func didLoad(temperature: Int?)
}

class WelcomePresenter {
    
    // MARK: Public Properties
    
    weak var view: WelcomeViewProtocol?
    let router: WelcomeRouterProtocol
    let interactor: WelcomeInteractorProtocol
    
    // MARK: Initialisers
    
    init(router: WelcomeRouterProtocol, interactor: WelcomeInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

// MARK: - WelcomePresenterProtocol

extension WelcomePresenter: WelcomePresenterProtocol {
    
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
    
}
