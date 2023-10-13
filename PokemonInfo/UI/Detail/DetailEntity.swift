//
//  DetailEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

struct PokemonDetails: Codable {
    let url: String
    let name: String
    let imageData: Data
    let type: String
    let weight: String
    let height: String
    
    init(pokemonURLString: String, pokemonDetailsAPI: PokemonDetailsAPI, imageData: Data) {
        self.url = pokemonURLString
        self.name = pokemonDetailsAPI.name
        self.imageData = imageData
        self.type = pokemonDetailsAPI.types.map { $0.type.name }.joined(separator: ", ")
        self.weight = pokemonDetailsAPI.weight.description
        self.height = pokemonDetailsAPI.height.description
    }
}

struct PokemonDetailsAPI: Codable {
    let name: String
    let sprites: SpriteAPI
    let types: [SlotAPI]
    let weight: Int
    let height: Int
}

struct SpriteAPI: Codable {
    let frontDefault: String
}

struct SlotAPI: Codable {
    let type: TypeAPI
}

struct TypeAPI: Codable {
    let name: String
}
