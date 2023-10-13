//
//  ListRouter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit
import OSLog

protocol ListRouterProtocol: AnyObject {
    func openDetails(for urlString: String)
}

final class ListRouter {
    
    // MARK: Types

    enum Errors: LocalizedError {
        case navControllerNotFound

        var errorDescription: String? {
            switch self {
            case .navControllerNotFound:
                return "UINavigationController not found"
            }
        }
    }
    
    // MARK: Public Properties
    
    weak var viewController: UIViewController?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
}

// MARK: - ListRouterProtocol

extension ListRouter: ListRouterProtocol {
    
    func openDetails(for urlString: String) {
        guard let navigationController = viewController?.navigationController else {
            logger.error("\(Errors.navControllerNotFound.localizedDescription, privacy: .public)")
            return
        }
        
        let detailVC = DetailModuleBuilder.build(webService: webService, urlString: urlString)
        navigationController.pushViewController(detailVC, animated: true)
    }

}
