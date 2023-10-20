//
//  ServiceLocator.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

protocol ServiceLocatorProtocol {
    func getWebService() -> WebServiceProtocol
    func getNetworkMonitorService() -> NetworkMonitorServiceProtocol
    func getAlertService() -> AlertServiceProtocol
    func getSwiftDataService() -> SwiftDataServiceProtocol
}

// MARK: All services in one place, no shared object, only protocol-based DI

final class ServiceLocator: ServiceLocatorProtocol {

    // MARK: Private Properties

    private lazy var services: [String: AnyObject] = [:]
    
    // MARK: Initialisers
    
    init() {
        // early calls
        getAlertService()
        getSwiftDataService()
    }

    // MARK: Public Methods

    func getWebService() -> WebServiceProtocol {
        let key = #function
        // service exist
        if let service = services[key] as? WebServiceProtocol {
            return service
        }
        // service not exist
        let service = WebService()
        services[key] = service
        return service
    }

    func getNetworkMonitorService() -> NetworkMonitorServiceProtocol {
        let key = #function
        // service exist
        if let service = services[key] as? NetworkMonitorServiceProtocol {
            return service
        }
        // service not exist
        let service = NetworkMonitorService()
        services[key] = service
        return service
    }
    
    @discardableResult
    func getAlertService() -> AlertServiceProtocol {
        let key = #function
        // service exist
        if let service = services[key] as? AlertServiceProtocol {
            return service
        }
        // service not exist
        let service = AlertService()
        services[key] = service
        return service
    }
    
    @discardableResult
    func getSwiftDataService() -> SwiftDataServiceProtocol {
        let key = #function
        // service exist
        if let service = services[key] as? SwiftDataServiceProtocol {
            return service
        }
        // service not exist
        let service = SwiftDataService()
        services[key] = service
        return service
    }

}
