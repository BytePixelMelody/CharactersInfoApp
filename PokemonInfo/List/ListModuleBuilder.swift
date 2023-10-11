//
//  ListModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

class ListModuleBuilder {
    
    // MARK: Static Methods
    
    static func build() -> ListViewController {
        let dataService = DateService()
        let weatherService = WeatherService()
        let interactor = ListInteractor(dataService: dataService, weatherService: weatherService)
        
        let router = ListRouter()
        
        let presenter = ListPresenter(router: router, interactor: interactor)
        
        let storyboard = UIStoryboard(name: "List", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ListViewController") as ListViewController
        
        presenter.view = viewController
        router.viewController = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
}
