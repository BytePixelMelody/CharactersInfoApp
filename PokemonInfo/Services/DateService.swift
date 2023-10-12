//
//  DateService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

protocol DateServiceProtocol {
    func getDate(completion: @escaping (Date) -> Void)
}

final class DateService: DateServiceProtocol {
    
    // MARK: Public Methods
    
    func getDate(completion: @escaping (Date) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(Date())
        }
    }
    
}
