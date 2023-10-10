//
//  DateService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 10.10.2023.
//

import Foundation

class DateService {
    
    func getDate(completion: @escaping (Date) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(Date())
        }
    }
    
}
