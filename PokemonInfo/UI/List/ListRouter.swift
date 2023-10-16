//
//  ListRouter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

protocol ListRouterProtocol: AnyObject {
    func openDetails(for urlString: String)
}

final class ListRouter {
    
    // MARK: Public Properties
    
    weak var viewController: UIViewController?
    
    // MARK: Private Properties
    
    private let serviceLocator: ServiceLocatorProtocol
    
    // MARK: Initialisers
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }
    
}

// MARK: - ListRouterProtocol

extension ListRouter: ListRouterProtocol {
    
    func openDetails(for urlString: String) {
        guard let navigationController = viewController?.navigationController else { return }
        
        let detailVC = DetailModuleBuilder.build(serviceLocator: serviceLocator, urlString: urlString)
        navigationController.pushViewController(detailVC, animated: true)
    }

}
