//
//  ListModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

final class ListModuleBuilder {
    
    // MARK: Static Methods
    
    static func build(webService: WebServiceProtocol) -> ListViewController {
        let interactor = ListInteractor(webService: webService)
        
        let router = ListRouter(webService: webService)
        
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
