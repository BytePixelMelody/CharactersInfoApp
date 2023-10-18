//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

// interactor works with data services
protocol ListInteractorProtocol: AnyObject {
    var pokemons: [Pokemon] { get }
    func getPokemons(by urlString: String) async throws 
}

final class ListInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: ListPresenterProtocol?
    var pokemons: [Pokemon] {
        return pokemonsDic
            .sorted { $0.key < $1.key }
            .map { $0.value }
    }
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private var pokemonsDic: [Int: Pokemon] = [:]
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
}

// MARK: - ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    
    // MARK: Public Methods

    func getPokemons(by urlString: String) async throws {
        let listAPI: ListAPI = try await webService.getDecodedJSON(by: urlString)
        let pokemonsAPI = listAPI.results
        
        let loadedPokemons = pokemonsAPI.compactMap { Pokemon(from: $0) }
        let loadedPokemonsDic = Dictionary(uniqueKeysWithValues: loadedPokemons.map { ($0.id, $0) })
        self.pokemonsDic.merge(loadedPokemonsDic) { current, new in
            return new
        }

        presenter?.loadedURL(urlString, nextURLString: listAPI.next)
        await presenter?.loadedPokemons(pokemons: pokemons)
    }
    
}
