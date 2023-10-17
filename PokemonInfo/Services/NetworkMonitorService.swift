//
//  NetworkMonitorService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

import Foundation
import Network

protocol NetworkMonitorServiceProtocol {
    func checkConnection() throws
}

enum NetworkMonitorErrors: LocalizedError {
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Please, check your Internet connection"
        }
    }
}

final class NetworkMonitorService: NetworkMonitorServiceProtocol {
   
    // MARK: Private Properties
    
    private let monitor: NWPathMonitor
    private var isConnected: Bool?
    
    // MARK: Initialisers
    
    init() {
        self.monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        
        monitor.start(queue: .global(qos: .utility))
    }
    
    // MARK: Public Methods
    
    func checkConnection() throws {
        if let isConnected {
            if isConnected == false {
                throw NetworkMonitorErrors.noInternetConnection
            }
        }
    }
    
}
