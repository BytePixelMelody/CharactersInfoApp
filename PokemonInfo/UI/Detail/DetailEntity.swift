//
//  DetailEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation

struct PokemonDetails: Codable {
    let id: Int
    let name: String
    let imageURLString: String
    var imageData: Data?
    let type: String
    let weightKg: String
    let height: String
    
    init?(from pokemonDetailsAPI: PokemonDetailsAPI, by pokemonURLString: String) {
        guard let idString = pokemonURLString.dropLast(1).components(separatedBy: "/").last,
              let id = Int(idString)
        else {
            return nil
        }
        self.id = id
        self.name = pokemonDetailsAPI.name.capitalized
        self.imageURLString = pokemonDetailsAPI.sprites.frontDefault
        self.type = pokemonDetailsAPI.types.map { $0.type.name }.joined(separator: ", ")
        self.weightKg = (Double(pokemonDetailsAPI.weight) / 1000).description
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
