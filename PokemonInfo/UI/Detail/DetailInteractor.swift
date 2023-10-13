//
//  DetailInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailInteractorProtocol: AnyObject {
    func getPokemonDetails() async throws
}

final class DetailInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: DetailPresenterProtocol?
    
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
        async let pokemonDetailsAPI: PokemonDetailsAPI = webService.getApiValue(from: pokemonURLString)
        
        let imageURL = try await pokemonDetailsAPI.sprites.frontDefault
        async let imageData: Data = webService.getApiValue(from: imageURL)
        
        let pokemonDetails = PokemonDetails(
            pokemonURLString: pokemonURLString,
            pokemonDetailsAPI: try await pokemonDetailsAPI,
            imageData: try await imageData
        )
        
        await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
    }
    
}
