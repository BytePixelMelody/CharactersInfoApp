//
//  NetworkMonitorService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

import Foundation
import Network

protocol NetworkMonitorServiceProtocol: AnyObject {
    var internetAlertShowed: Bool { get set }
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
    
    // MARK: Public Properties
    
    var internetAlertShowed: Bool = false
   
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
        
        internetAlertShowed = false // connection is ok
    }
    
}
