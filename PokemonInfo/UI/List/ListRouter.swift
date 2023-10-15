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
    
    private let webService: WebServiceProtocol
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
}

// MARK: - ListRouterProtocol

extension ListRouter: ListRouterProtocol {
    
    func openDetails(for urlString: String) {
        guard let navigationController = viewController?.navigationController else { return }
        
        let detailVC = DetailModuleBuilder.build(webService: webService, urlString: urlString)
        navigationController.pushViewController(detailVC, animated: true)
    }

}
