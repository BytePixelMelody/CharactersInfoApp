//
//  ListInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

// interactor works with data services
protocol ListInteractorProtocol {
    var loadedList: [PokemonAPI] { get }
    func getListPage() async throws
}

final class ListInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: ListPresenterProtocol?
    
    // MARK: Private Properties
    
    private let webService: WebServiceProtocol
    private var list: [PokemonAPI] = []
    private var currentPageURL = Settings.startUrl
    
    // MARK: Initialisers
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
}

// MARK: - ListInteractorProtocol

extension ListInteractor: ListInteractorProtocol {
    
    // MARK: Public Properties
    
    var loadedList: [PokemonAPI] {
        list
    }
    
    // MARK: Public Methods
    
    func getListPage() async throws {
        async let receivedList: ListAPI = webService.getApiValue(from: currentPageURL)
        list.append(contentsOf: try await receivedList.results)
        await presenter?.loadedListPage(list: list)
    }
    
}
