//
//  WelcomeRouter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

protocol WelcomeRouterProtocol: AnyObject {
    
}

class WelcomeRouter {
    
    // MARK: Public Properties
    
    weak var presenter: WelcomePresenter?
    
}

// MARK: - WelcomeRouterProtocol

extension WelcomeRouter: WelcomeRouterProtocol {
    
}
