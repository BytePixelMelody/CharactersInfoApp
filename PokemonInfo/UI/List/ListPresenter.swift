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
    @MainActor func loadedPokemons(pokemons: [Pokemon]) async
    
}

final class ListPresenter {
     
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    
    // MARK: Private Properties
    
    private let router: ListRouterProtocol
    private let interactor: ListInteractorProtocol
    private let alertService: AlertServiceProtocol
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
    // MARK: Initialisers
    
    init(router: ListRouterProtocol, 
         interactor: ListInteractorProtocol,
         alertService: AlertServiceProtocol
    ) {
        self.router = router
        self.interactor = interactor
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
        Task {
            do {
                try await interactor.getPokemons()
            } catch {
                logger.error("\(error.localizedDescription, privacy: .public)")
                await catchLoadingError(error: error)
            }
        }
    }
    
    func didTapPokemon(pokemon: Pokemon) {
        let urlString = pokemon.url
        router.openDetails(for: urlString)
    }
    
    // interactor calls
    
    @MainActor
    func loadedPokemons(pokemons: [Pokemon]) async {
        view?.updateSnapshot(with: pokemons)
    }
    
    // MARK: Private Methods

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
        
        logger.error("\(error.localizedDescription, privacy: .public)")
    }
    
    @MainActor
    private func showAlert(_ alertType: AlertType, message: String? = nil) async {
        guard let viewController = view as? UIViewController else { return }
        
        switch alertType {
        case .noInternetConnection where Settings.internetAlertShowed == true:
            return
        case .noInternetConnection where Settings.internetAlertShowed == false:
            Settings.internetAlertShowed = true
        default:
            break
        }
        
        alertService.showAlert(with: alertType, on: viewController, message: message)
    }
    
}
