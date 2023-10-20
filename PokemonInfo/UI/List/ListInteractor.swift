//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//
import Foundation

// interactor works with data services
protocol ListInteractorProtocol: AnyObject {
    func getPokemons() async throws
}

final class ListInteractor {
    
    // MARK: Constants
    
    private enum Constants {
        static let loadingURLsRemoveTimeout = 3 // sec
    }
    
    // MARK: Types

    enum Errors: LocalizedError {
        case pokemonHasNoID(String)

        var errorDescription: String? {
            switch self {
            case .pokemonHasNoID(let urlString):
                return "Pokemon by \(urlString) has no id"
            }
        }
    }
    
    actor LoadingURLs {
        
        private var loadingURLs = Set<String?>() {
            didSet {
                if !loadingURLs.isEmpty {
                    Task {
                        try await Task.sleep(for: .seconds(Constants.loadingURLsRemoveTimeout))
                        loadingURLs.removeAll()
                    }
                }
            }
        }
        
        func contains(_ url: String?) async -> Bool {
            loadingURLs.contains(url)
        }

        func insert(_ url: String?) async {
            loadingURLs.insert(url)
        }
        
        func remove(_ url: String?) async {
            loadingURLs.remove(url)
        }
        
    }
    
    // MARK: Public Properties
    
    weak var presenter: ListPresenterProtocol?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let swiftDataService: SwiftDataServiceProtocol
    private var nextURL: String? = Settings.startUrl
//    private var loadingURLs = Set<String?>()
    private let loadingURLs = LoadingURLs()
    private var pokemonsDic: [Int: Pokemon] = [:]
    private var pokemons: [Pokemon] {
        return pokemonsDic
            .sorted { $0.key < $1.key }
            .map { $0.value }
    }
    
    // MARK: Initialisers
    
    init(
        webService: WebServiceProtocol,
        swiftDataService: SwiftDataServiceProtocol,
        networkMonitorService: NetworkMonitorServiceProtocol
    ) {
        self.webService = webService
        self.swiftDataService = swiftDataService
        self.networkMonitorService = networkMonitorService
    }
    
}

// MARK: - ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    
    // MARK: Public Methods

    func getPokemons() async throws {
        await initNextURLFromDB()
        guard let currentURL = nextURL else { return }
        
        var pokemons = await initPokemonsFromDB()
        if pokemons.isEmpty {
            try networkMonitorService.checkConnection()
            guard await isReadyToGetPokemons() else { return }
            (nextURL, pokemons) = try await loadFromWeb(by: currentURL)
        }
        
        insertToDic(pokemons: pokemons)
        
        await presenter?.loadedPokemons(pokemons: self.pokemons)
        
        await insertToDB(pokemons: pokemons)
        await updateInDB(nextURL: nextURL)
        
        await loadingURLs.remove(currentURL)
    }
    
    // MARK: Private Methods
    
    private func initNextURLFromDB() async {
        guard let currentURL = nextURL, currentURL == Settings.startUrl else { return }
        nextURL = await swiftDataService.fetchNextURL()?.url ?? nextURL
    }
    
    
    private func isReadyToGetPokemons() async -> Bool {
        if await loadingURLs.contains(nextURL) {
            return false
        } else {
            await loadingURLs.insert(nextURL)
            return true
        }
    }

    private func initPokemonsFromDB() async -> [Pokemon] {
        if pokemonsDic.isEmpty {
            return await swiftDataService.fetchAllPokemons()
        } else {
            return []
        }
    }
    
    private func loadFromWeb(by url: String) async throws -> (String?, [Pokemon]) {
        let listAPI: ListAPI = try await webService.getDecodedJSON(by: url)
        let nextURL = listAPI.next
        let pokemonsAPI = listAPI.results
        let pokemons = pokemonsAPI.compactMap { Pokemon(id: $0.id, name: $0.name, url: $0.url) }
        return (nextURL, pokemons)
    }
    
    private func insertToDic(pokemons: [Pokemon]) {
        pokemons.forEach { pokemonsDic[$0.id] = $0 }
    }
    
    private func insertToDB(pokemons: [Pokemon]) async {
        for pokemon in pokemons {
            await swiftDataService.insertPokemon(pokemon: pokemon)
        }
    }
    
    private func updateInDB(nextURL: String?) async {
        let nextURL = NextURL(url: nextURL)
        await swiftDataService.updateNextURL(nextURL: nextURL)
    }
    
}
