//
//  DetailModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//  
//

import UIKit

final class DetailModuleBuilder {
    
    // MARK: Static Methods
    
    static func build(webService: WebServiceProtocol, urlString: String) -> DetailViewController {
        let interactor = DetailInteractor(webService: webService, urlString: urlString)
        
        let router = DetailRouter()
        
        let presenter = DetailPresenter(interactor: interactor, router: router)
        
        let viewController = DetailViewController()
        
        presenter.view  = viewController
        router.viewController = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
}
