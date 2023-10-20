//
//  ListModuleBuilder.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

final class ListModuleBuilder {
    
    // MARK: Static Methods
    
    static func build(serviceLocator: ServiceLocatorProtocol) -> ListViewController {
        let webService = serviceLocator.getWebService()
        let networkMonitorService = serviceLocator.getNetworkMonitorService()
        let alertService = serviceLocator.getAlertService()
        let swiftDataService = SwiftDataService()

        let router = ListRouter(serviceLocator: serviceLocator)
        let interactor = ListInteractor(
            webService: webService,
            swiftDataService: swiftDataService,
            networkMonitorService: networkMonitorService
        )
        
        let presenter = ListPresenter(
            router: router,
            interactor: interactor,
            alertService: alertService
        )
        
        let viewController = ListViewController()
        
        presenter.view = viewController
        router.viewController = viewController
        
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        return viewController
    }
    
}
