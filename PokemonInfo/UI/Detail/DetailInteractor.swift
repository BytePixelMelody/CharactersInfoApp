//
//  DetailInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import Foundation

protocol DetailInteractorProtocol: AnyObject {
    var loadedPokemonDetails: PokemonDetails? { get }
    func getPokemonDetails() async throws
}

final class DetailInteractor {
    
    // MARK: Types

    enum Errors: LocalizedError {
        case pokemonDetailsInitFailed(String)
        case creatingImageDataFailed(String)

        var errorDescription: String? {
            switch self {
            case .pokemonDetailsInitFailed(let urlString):
                return "PokemonDetails init failed with id from \(urlString)"
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
    private let swiftDataService: SwiftDataServiceProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let pokemonURLString: String
    
    // MARK: Initialisers
    
    init(
        webService: WebServiceProtocol,
        swiftDataService: SwiftDataServiceProtocol,
        networkMonitorService: NetworkMonitorServiceProtocol,
        urlString: String
    ) {
        self.webService = webService
        self.swiftDataService = swiftDataService
        self.networkMonitorService = networkMonitorService
        self.pokemonURLString = urlString
    }
    
}

// MARK: - DetailInteractorProtocol

extension DetailInteractor: DetailInteractorProtocol {
    
    // MARK: Public Methods
    
    func getPokemonDetails() async throws {
        let pokemonDetailsAPI: PokemonDetailsAPI = try await webService.getDecodedJSON(by: pokemonURLString)
        guard let pokemonDetails = PokemonDetails(from: pokemonDetailsAPI, by: pokemonURLString) else {
            throw Errors.pokemonDetailsInitFailed(pokemonURLString)
        }
        
        await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
        
        loadedPokemonDetails = pokemonDetails
        
        try await getPokemonDetailsImage(of: pokemonDetails)
    }
    
    // MARK: Private Methods
    
    private func getPokemonDetailsImage(of pokemonDetails: PokemonDetails) async throws {
        let imageData = try await webService.getRawData(by: pokemonDetails.imageURLString)
        
        await presenter?.loadedPokemonImageData(imageData: imageData)
        
        loadedPokemonDetails?.imageData = imageData
    }
    
}
