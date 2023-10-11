//
//  DetailPresenter.swift
//  PokemonInfo
//  
//  Created by Vyacheslav on 11.10.2023
//

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
}

class DetailPresenter {
    
    // MARK: Public Properties
    
    weak var view: DetailViewProtocol?
    let router: DetailRouterProtocol
    let interactor: DetailInteractorProtocol
    
    // MARK: Initialisers

    init(interactor: DetailInteractorProtocol, router: DetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
    // MARK: Public Methods
    
    func viewDidLoaded() {
        let image = interactor.getImageForTemperature()
        view?.showImage(image: image)
    }
    
}
