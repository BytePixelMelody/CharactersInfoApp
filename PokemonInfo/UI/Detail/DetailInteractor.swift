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
        let pokemonDetailsAPI: PokemonDetailsAPI = try await webService.getApiValue(from: pokemonURLString)
        
        var imageData: Data? = nil
        if let imageURL = URL(string: pokemonDetailsAPI.sprites.frontDefault),
            let data = try? Data(contentsOf: imageURL) { //await webService.getApiValue(from: imageURL)
            imageData = data
        } else {
            // TODO: throw error canNotLoadImage
        }
        
        let pokemonDetails = PokemonDetails(
            pokemonURLString: pokemonURLString,
            pokemonDetailsAPI: pokemonDetailsAPI,
            imageData: imageData
        )
        
        await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
    }
    
}
