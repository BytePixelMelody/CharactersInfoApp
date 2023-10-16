//
//  NetworkMonitorService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

import Network

protocol NetworkMonitorServiceProtocol {
    var isConnected: Bool? { get }
}

final class NetworkMonitorService: NetworkMonitorServiceProtocol {
    
    // MARK: Public Properties
    
    private(set) var isConnected: Bool?
    
    // MARK: Private Properties
    
    private let monitor: NWPathMonitor
    
    // MARK: Initialisers
    
    init() {
        self.monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        
        monitor.start(queue: .global(qos: .utility))
    }
    
}
