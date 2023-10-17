//
//  AlertService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 16.10.2023.
//

import UIKit

protocol AlertServiceProtocol {
    func showAlert(with alertType: AlertType, on viewController: UIViewController, message: String?)
}

extension AlertServiceProtocol {
    // implementing default value: message = nil
    func showAlert(with alertType: AlertType, on viewController: UIViewController) {
        showAlert(with: alertType, on: viewController, message: nil)
    }
}

enum AlertType {
    case noInternetConnection
    case dataLoadingError
    
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
        case .dataLoadingError:
            return "Data loading error occurred, please try again later"
        }
    }
}

final class AlertService: AlertServiceProtocol {
    
    // MARK: Public Methods
    
    func showAlert(
        with alertType: AlertType,
        on viewController: UIViewController,
        message: String? = nil
    ) {
        let alertMessage = message ?? alertType.message
        let alertController = UIAlertController(
            title: alertType.title,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true)
    }
    
}
