//
//  WelcomeModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

class WelcomeModuleBuilder {
    
    // MARK: Static Methods
    
    static func build() -> WelcomeViewController {
        let dataService = DateService()
        let weatherService = WeatherService()
        let interactor = WelcomeInteractor(dataService: dataService, weatherService: weatherService)
        
        let router = WelcomeRouter()
        
        let presenter = WelcomePresenter(router: router, interactor: interactor)
        
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "WelcomeViewController") as WelcomeViewController
        
        presenter.view = viewController
        
        interactor.presenter = presenter
        router.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
}
