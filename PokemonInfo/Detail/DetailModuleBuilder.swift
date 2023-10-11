//
//  DetailModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//  
//

import UIKit

class DetailModuleBuilder {
    
    // MARK: Static Methods
    
    static func build(temperature: Int) -> DetailViewController {
        let interactor = DetailInteractor(temperature: temperature)
        
        let router = DetailRouter()
        
        let presenter = DetailPresenter(interactor: interactor, router: router)
        
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "Detail") as DetailViewController
        
        presenter.view  = viewController
        router.viewController = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
}
