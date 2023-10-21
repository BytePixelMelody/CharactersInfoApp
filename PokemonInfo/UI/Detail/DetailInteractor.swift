//
//  DetailInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import Foundation
import OSLog

protocol DetailInteractorProtocol: AnyObject {
    func getPokemonDetails() async throws
}

final class DetailInteractor {
    
    // MARK: Types
    
    enum Errors: LocalizedError {
        case pokemonDetailsInitFailed(String)

        var errorDescription: String? {
            switch self {
            case .pokemonDetailsInitFailed(let message):
                return "PokemonDetails init failed \(message)"
            }
        }
    }
    
    // MARK: Public Properties
    
    weak var presenter: DetailPresenterProtocol?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private let swiftDataService: SwiftDataServiceProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let logger = Logger(subsystem: #file, category: "Error logger")
    private let pokemonDetailsURL: String
    
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
        self.pokemonDetailsURL = urlString
    }
    
}

// MARK: - DetailInteractorProtocol

extension DetailInteractor: DetailInteractorProtocol {
    
    // MARK: Public Methods
    
    func getPokemonDetails() async throws {
        var pokemonDetails = await swiftDataService.fetchPokemonDetails(url: pokemonDetailsURL)
        if pokemonDetails == nil {
            try networkMonitorService.checkConnection()
            pokemonDetails = try await getPokemonDetailsFromWeb(by: pokemonDetailsURL)
        }
        
        guard let pokemonDetails else { return }

        if pokemonDetails.imageData == nil {
            await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
            let imageData = try await getImageDataFromWeb(of: pokemonDetails)
            await presenter?.loadedPokemonImageData(imageData: imageData)
            pokemonDetails.imageData = imageData
        } else {
            await presenter?.loadedPokemonDetails(pokemonDetails: pokemonDetails)
        }
        
        await swiftDataService.insertPokemonDetails(pokemonDetails: pokemonDetails)
    }
    
    // MARK: Private Methods
    
    private func getPokemonDetailsFromWeb(by url: String) async throws -> PokemonDetails? {
        let pokemonDetailsAPI: PokemonDetailsAPI = try await webService.getDecodedJSON(by: url)
        
        guard let pokemonDetails = PokemonDetails(from: pokemonDetailsAPI, with: url) else {
            let error = Errors.pokemonDetailsInitFailed(url)
            logger.error("\(error.localizedDescription, privacy: .public)")
            return nil
        }
        
        return pokemonDetails
    }
    
    private func getImageDataFromWeb(of pokemonDetails: PokemonDetails) async throws -> Data {
        return try await webService.getRawData(by: pokemonDetails.imageURLString)
    }
    
}
