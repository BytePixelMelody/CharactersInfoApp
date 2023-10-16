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
    func loadNextPage()
    func didTapPokemon(pokemon: Pokemon)
    
    // interactor calls
    func loadedURL(_ urlString: String, nextURLString: String?)
    @MainActor func loadedPokemons(pokemons: [Pokemon]) async
    
}

final class ListPresenter {
    
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    
    // MARK: Private Properties
    
    private let logger = Logger(subsystem: #file, category: "Error logger")
    private var currentURL: String? = Settings.startUrl
    var loadingURLs = Set<String>()

    // MARK: Initialisers
    
    init(router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {

    // MARK: Public Methods
    // view calls
    
    func viewDidLoaded() {
        loadNextPage()
    }
    
    func loadNextPage() {
        // exit if no more pages or already loading
        guard let currentURL, !loadingURLs.contains(currentURL) else { return }
        loadingURLs.insert(currentURL)

        Task {
            do {
                // TODO: check internet here and throw
                try await interactor.getPokemons(by: currentURL)
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
                // TODO: catch errors
            }
            loadingURLs.remove(currentURL)
        }
    }
    
    func didTapPokemon(pokemon: Pokemon) {
        let urlString = pokemon.url
        router.openDetails(for: urlString)
    }
    
    // interactor calls
    
    func loadedURL(_ urlString: String, nextURLString: String?) {
        loadingURLs.remove(urlString)
        currentURL = nextURLString
    }
    
    @MainActor
    func loadedPokemons(pokemons: [Pokemon]) async {
        view?.updateSnapshot(with: pokemons)
    }
    
}
