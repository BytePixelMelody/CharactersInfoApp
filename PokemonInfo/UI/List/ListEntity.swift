//
//  ListEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

struct ListAPI: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonAPI]
}

struct PokemonAPI: Codable {
    let name: String
    let url: String
}
