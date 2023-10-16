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
    
    // MARK: Types

    enum Errors: LocalizedError {
        case noInternetConnection

        var errorDescription: String? {
            switch self {
            case .noInternetConnection:
                return "Please, check your Internet connection"
            }
        }
    }
    
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    
    // MARK: Private Properties
    
    private let router: ListRouterProtocol
    private let interactor: ListInteractorProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let alertService: any AlertServiceProtocol
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
    private var currentURL: String? = Settings.startUrl
    private var loadingURLs = Set<String>()

    // MARK: Initialisers
    
    init(router: ListRouterProtocol, 
         interactor: ListInteractorProtocol,
         networkMonitorService: NetworkMonitorServiceProtocol,
         alertService: any AlertServiceProtocol
    ) {
        self.router = router
        self.interactor = interactor
        self.networkMonitorService = networkMonitorService
        self.alertService = alertService
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
                try connection()
                try await interactor.getPokemons(by: currentURL)
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
                // TODO: catch errors
            }
            loadingURLs.remove(currentURL)
        }
    }
    
    private func connection() throws {
        if let isConnected = networkMonitorService.isConnected {
            if isConnected == false {
                throw Errors.noInternetConnection
            }
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
