//
//  ListRouter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit

protocol ListRouterProtocol: AnyObject {
    func openDetails(for temperature: Int)
}

class ListRouter {
    
    // MARK: Public Properties
    
    weak var viewController: ListViewProtocol?
    
}

// MARK: - ListRouterProtocol

extension ListRouter: ListRouterProtocol {
    
    func openDetails(for temperature: Int) {
        guard let viewController = viewController as? UIViewController else { return }
        let detailVC = DetailModuleBuilder.build(temperature: temperature)
        viewController.present(detailVC, animated: true)
    }

}
