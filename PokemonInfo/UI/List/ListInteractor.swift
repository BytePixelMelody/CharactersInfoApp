//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//
import Foundation

// interactor works with data services
protocol ListInteractorProtocol: AnyObject {
    func setPresenter(_ presenter: ListPresenterProtocol) async
    func getPokemons() async throws
}

final actor ListInteractor {
    
    // MARK: Constants
    
    private enum Constants {
        static let loadingURLsRemoveTimeout = 5 // sec
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
        
    // MARK: Private Properties
    
    private weak var presenter: ListPresenterProtocol?
    private let webService: WebServiceProtocol
    private let networkMonitorService: NetworkMonitorServiceProtocol
    private let swiftDataService: SwiftDataServiceProtocol
    
    private var nextURL: String? = Settings.startUrl
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
    private var pokemonsDic: [Int: Pokemon] = [:] // TODO: Make actor
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
    
    func setPresenter(_ presenter: ListPresenterProtocol) async {
        self.presenter = presenter
    }

    func getPokemons() async throws {
        await initNextURLFromDB()
        guard let currentURL = nextURL, await isReadyToGetPokemons() else {
            return // Request rejected
        }
        
        var pokemons = await initPokemonsFromDB()
        if pokemons.isEmpty {
            try networkMonitorService.checkConnection()
            (nextURL, pokemons) = try await loadFromWeb(by: currentURL)
        }
        
        insertToDic(pokemons: pokemons)
        
        await presenter?.loadedPokemons(pokemons: self.pokemons)
        
        await insertToDB(pokemons: pokemons)
        await updateInDB(nextURL: nextURL)
    }
    
    // MARK: Private Methods
    
    private func initNextURLFromDB() async {
        guard let currentURL = nextURL, currentURL == Settings.startUrl else { return }
        nextURL = await swiftDataService.fetchNextURL()?.url ?? nextURL
    }
    
    
    private func isReadyToGetPokemons() async -> Bool {
        return loadingURLs.insert(nextURL).inserted
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
