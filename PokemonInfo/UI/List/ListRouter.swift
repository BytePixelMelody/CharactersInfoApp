//
//  ListRouter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit
import OSLog

protocol ListRouterProtocol: AnyObject {
    func openDetails(for temperature: Int)
}

final class ListRouter {
    
    // MARK: Types

    enum ListRouterError: LocalizedError {
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
    
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
}

// MARK: - ListRouterProtocol

extension ListRouter: ListRouterProtocol {
    
    func openDetails(for temperature: Int) {
        guard let navigationController = viewController?.navigationController else {
            logger.error("\(ListRouterError.navControllerNotFound.localizedDescription, privacy: .public)")
            return
        }
        
        let detailVC = DetailModuleBuilder.build(temperature: temperature)
        navigationController.pushViewController(detailVC, animated: true)
    }

}
