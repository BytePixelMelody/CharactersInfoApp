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
    
    weak var presenter: WelcomePresenter?
    
}

extension WelcomeRouter: WelcomeRouterProtocol {
    
}
