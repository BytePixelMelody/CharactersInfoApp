//
//  DetailInteractor.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 11.10.2023
//

import UIKit

protocol DetailInteractorProtocol: AnyObject {
    func getImageForTemperature() -> UIImage?
}

final class DetailInteractor {
    
    // MARK: Public Properties
    
    weak var presenter: DetailPresenterProtocol?
    
    // MARK: Private Properties
    
    private let temperature: Int
    
    // MARK: Initialisers
    
    init(temperature: Int) {
        self.temperature = temperature
    }
    
}

// MARK: - DetailInteractorProtocol

extension DetailInteractor: DetailInteractorProtocol {
    
    // MARK: Public Methods
    
    func getImageForTemperature() -> UIImage? {
        switch temperature {
        case -30..<0:
            return UIImage(systemName: "snowflake")
        case 0..<10:
            return UIImage(systemName: "cloud")
        case 11...30:
            return UIImage(systemName: "sun.max")
        default:
            return nil
        }
    }
    
}
