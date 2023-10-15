//
//  DetailInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailInteractorProtocol: AnyObject {
    var loadedPokemonDetails: PokemonDetails? { get }
    func getPokemonDetails() async throws
}

final class DetailInteractor {
    
    // MARK: Types

    enum Errors: LocalizedError {
        case pokemonDetailsInitFailed(String)
        case creatingURLFailed(String)
        case creatingImageDataFailed(String)

        var errorDescription: String? {
            switch self {
            case .pokemonDetailsInitFailed(let urlString):
                return "PokemonDetails init failed with id from \(urlString)"
            case .creatingURLFailed(let urlString):
                return "Failed to create URL from \(urlString)"
            case .creatingImageDataFailed(let urlString):
                return "Failed to create Data from \(urlString)"
            }
        }
    }
    
    // MARK: Public Properties
    
    weak var presenter: DetailPresenterProtocol?
    private(set) var loadedPokemonDetails: PokemonDetails?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private let pokemonURLString: String
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol, urlString: String) {
        self.webService = webService
        self.pokemonURLString = urlString
    }
    
}

// MARK: - DetailInteractorProtocol

extension DetailInteractor: DetailInteractorProtocol {
    
    // MARK: Public Methods
    
    func getPokemonDetails() async throws {
        let pokemonDetailsAPI: PokemonDetailsAPI = try await webService.getApiValue(from: pokemonURLString)
        guard let pokemonDetails = PokemonDetails(from: pokemonDetailsAPI, by: pokemonURLString) else {
            throw Errors.pokemonDetailsInitFailed(pokemonURLString)
        }
        
        await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
        
        loadedPokemonDetails = pokemonDetails
        
        try await getPokemonDetailsImage(of: pokemonDetails)
    }
    
    // MARK: Private Methods
    
    private func getPokemonDetailsImage(of pokemonDetails: PokemonDetails) async throws {
        guard let imageURL = URL(string: pokemonDetails.imageURLString) else {
            throw Errors.creatingURLFailed(pokemonDetails.imageURLString)
        }
        guard let imageData = try? Data(contentsOf: imageURL) else {
            throw Errors.creatingImageDataFailed(pokemonDetails.imageURLString)
        }
        
        await presenter?.loadedPokemonImageData(imageData: imageData)
        
        loadedPokemonDetails?.imageData = imageData
    }
    
}
