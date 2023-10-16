//
//  AlertService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

import UIKit

protocol AlertServiceProtocol {
    associatedtype AlertType
    func showAlert(with alertType: AlertType, on viewController: UIViewController)
}

final class AlertService: AlertServiceProtocol {
    
    // MARK: Types
    
    enum AlertType {
        case noInternetConnection
        case dataLoadingError(String)
        
        var title: String {
            switch self {
            case .noInternetConnection:
                return "No Internet connection"
            case .dataLoadingError:
                return "Data loading error"
            }
        }
        
        var message: String {
            switch self {
            case .noInternetConnection:
                return "Please check your Internet connection and try again"
            case .dataLoadingError(let errorMessage):
                return errorMessage
            }
        }
    }
    
    // MARK: Public Methods
    
    func showAlert(with alertType: AlertType, on viewController: UIViewController) {
        let alertController = UIAlertController(
            title: alertType.title,
            message: alertType.message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
}
