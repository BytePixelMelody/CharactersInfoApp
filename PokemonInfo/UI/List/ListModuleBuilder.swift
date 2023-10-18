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

        let router = ListRouter(serviceLocator: serviceLocator)
        let interactor = ListInteractor(webService: webService)
        
        let presenter = ListPresenter(
            router: router,
            interactor: interactor,
            networkMonitorService: networkMonitorService,
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
