//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

// interactor works with data services
protocol ListInteractorProtocol {
    var loadedList: [Pokemon] { get }
    func getListPage() async throws
}

final class ListInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: ListPresenterProtocol?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private(set) var loadedList: [Pokemon] = []
    private var currentPageURL = Settings.startUrl
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
}

// MARK: - ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    
    // MARK: Public Methods
    
    func getListPage() async throws {
        let receivedList: ListAPI = try await webService.getApiValue(from: currentPageURL)
        let pokemonsAPI = receivedList.results
        let pokemons = pokemonsAPI.compactMap { Pokemon(from: $0) }
        loadedList.append(contentsOf: pokemons)
        await presenter?.loadedInitList(list: loadedList)
    }
    
}
