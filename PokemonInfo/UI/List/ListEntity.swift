//
//  ListEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let id: Int
    let name: String
    let url: String
    
    init?(from pokemonAPI: PokemonAPI) {
        guard let idString = pokemonAPI.url.dropLast(1).components(separatedBy: "/").last,
              let id = Int(idString)
        else {
            return nil
        }
        self.id = id
        self.name = pokemonAPI.name
        self.url = pokemonAPI.url
    }
}

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
