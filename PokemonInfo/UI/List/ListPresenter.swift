//
//  ListPresenter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation
import OSLog

protocol ListPresenterProtocol: AnyObject {
    
    // view calls
    func viewDidLoaded()
    func didTapPokemon(pokemon: Pokemon)
    
    // interactor calls
    @MainActor func loadedInitList(list: [Pokemon]) async
    
}

final class ListPresenter {
    
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    
    // MARK: Initialisers
    
    init(router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Private Properties
    
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {

    // MARK: Public Methods
    // view calls
    
    func viewDidLoaded() {
        Task {
            do {
                // TODO: check internet here and trow
                try await interactor.getListPage()
            } catch {
                logger.error("\(error, privacy: .public)")
                // TODO: catch errors
            }
        }
    }
    
    func didTapPokemon(pokemon: Pokemon) {
        let urlString = pokemon.url
        router.openDetails(for: urlString)
    }
    
    // interactor calls
    
    @MainActor
    func loadedInitList(list: [Pokemon]) async {
        view?.initializeSnapshot(with: list)
    }
    
}
