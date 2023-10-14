//
//  ListPresenter.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation
import OSLog

protocol ListPresenterProtocol: AnyObject {
    func viewDidLoaded() async
    @MainActor 
    func loadedListPage(list: [PokemonAPI]) async
    func didTapDetails()
}

final class ListPresenter {
    
    // MARK: Public Properties
    
    weak var view: ListViewProtocol?
    let router: ListRouterProtocol
    let interactor: ListInteractorProtocol
    
    // MARK: Initialisers
    
    init(router: ListRouterProtocol, interactor: ListInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Private Properties
    
    private let logger = Logger(subsystem: #file, category: "Error logger")
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListPresenterProtocol {

    // MARK: Public Methods
    
    func viewDidLoaded() async {
        do {
            // TODO: check internet here and trow
            try await interactor.getListPage()
        } catch {
            logger.error("\(error, privacy: .public)")
            // TODO: catch errors
        }
    }
    
    @MainActor
    func loadedListPage(list: [PokemonAPI]) async {
        view?.showCount(count: list.count.description)
    }
    
    func didTapDetails() {
        //        let _ = interactor.loadedList[3]
        
        let urlStringFromView = "https://pokeapi.co/api/v2/pokemon/18/"
        router.openDetails(for: urlStringFromView)
    }
    
}
