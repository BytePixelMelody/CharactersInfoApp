//
//  ListPresenter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import UIKit
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
    
    // MARK: Private Properties
    
    private let router: ListRouterProtocol
    private let interactor: ListInteractorProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let alertService: AlertServiceProtocol
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
    private var currentURL: String? = Settings.startUrl
    private var loadingURLs = Set<String>()
    private var internetAlertShowed = false

    // MARK: Initialisers
    
    init(router: ListRouterProtocol, 
         interactor: ListInteractorProtocol,
         networkMonitorService: NetworkMonitorServiceProtocol,
         alertService: AlertServiceProtocol
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
        // exit if no more pages or ULR is already loading
        guard let currentURL, !loadingURLs.contains(currentURL) else { return }
        loadingURLs.insert(currentURL)

        Task {
            do {
                try networkMonitorService.checkConnection()
                internetAlertShowed = false // connection is good
                try await interactor.getPokemons(by: currentURL)
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
                await catchLoadingError(error: error)
            }
            loadingURLs.remove(currentURL)
        }
    }
    
    private func catchLoadingError(error: Error) async {
        switch error {
        case NetworkMonitorErrors.noInternetConnection:
            await showAlert(.noInternetConnection)
        case let error as NSError where
            error.domain == NSURLErrorDomain &&
            error.code == NSURLErrorNotConnectedToInternet:
            await showAlert(.noInternetConnection)
        default:
            await showAlert(.dataLoadingError, message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func showAlert(_ alertType: AlertType, message: String? = nil) async {
        guard let viewController = view as? UIViewController else { return }

        switch alertType {
        case .noInternetConnection:
            if internetAlertShowed == true {
                return
            } else {
                internetAlertShowed = true
            }
        default:
            break
        }
        
        alertService.showAlert(with: alertType, on: viewController, message: message)
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
