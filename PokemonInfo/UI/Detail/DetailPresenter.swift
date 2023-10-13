//
//  DetailPresenter.swift
//  PokemonInfo
//  
//  Created by Vyacheslav on 11.10.2023
//

import UIKit
import OSLog

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded() async
    @MainActor func loadedPokemonDetails(pokemonDetails: PokemonDetails) async
}

final class DetailPresenter {
    
    // MARK: Types
    
    enum Errors: LocalizedError {
        case noDataLoaded
        case noImageLoaded

        var errorDescription: String? {
            switch self {
            case .noDataLoaded:
                return "Data loading failed"
            case .noImageLoaded:
                return "Image loading failed"
            }
        }
    }
    
    // MARK: Constants
    
    private enum Constants {
        static let namePrefix = "Name: "
        static let typePrefix = "Types: "
        static let weightPrefix = "Weight: "
        static let heightPrefix = "Height: "
    }
    
    // MARK: Public Properties
    
    weak var view: DetailViewProtocol?
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    
    // MARK: Initialisers

    init(interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: Private Properties
    
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
}

// MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
    // MARK: Public Methods
    
    func viewDidLoaded() async {
        do {
            // TODO: check internet here and trow
            try await interactor.getPokemonDetails()
        } catch {
            logger.error("\(error, privacy: .public)")
            // TODO: catch errors here
        }
    }
    
    @MainActor
    func loadedPokemonDetails(pokemonDetails: PokemonDetails) async {
        let image = UIImage(data: pokemonDetails.imageData)
        
        view?.showDetail(
            name: Constants.namePrefix + pokemonDetails.name,
            image: image,
            type: Constants.typePrefix + pokemonDetails.type,
            weight: Constants.weightPrefix + pokemonDetails.weight,
            height: Constants.heightPrefix + pokemonDetails.height
        )
    }
    
}
