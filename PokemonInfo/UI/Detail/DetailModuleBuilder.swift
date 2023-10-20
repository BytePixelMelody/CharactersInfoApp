//
//  DetailModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//  
//

final class DetailModuleBuilder {
    
    // MARK: Static Methods
    
    static func build(serviceLocator: ServiceLocatorProtocol, urlString: String) -> DetailViewController {
        let webService = serviceLocator.getWebService()
        let networkMonitorService = serviceLocator.getNetworkMonitorService()
        let alertService = serviceLocator.getAlertService()
        let swiftDataService = SwiftDataService()

        let router = DetailRouter()
        let interactor = DetailInteractor(
            webService: webService,
            swiftDataService: swiftDataService,
            networkMonitorService: networkMonitorService,
            urlString: urlString
        )
        
        let presenter = DetailPresenter(
            router: router,
            interactor: interactor,
            alertService: alertService
        )
        
        let viewController = DetailViewController()
        
        presenter.view = viewController
        router.viewController = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
}
