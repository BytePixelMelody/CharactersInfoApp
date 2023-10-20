//
//  DetailEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import Foundation
import SwiftData

@Model
class PokemonDetails {
    @Attribute(.unique) var url: String
    var id: Int
    var name: String
    var imageURLString: String
    var imageData: Data?
    var type: String
    var weightKg: String
    var height: String
    
    init?(from pokemonDetailsAPI: PokemonDetailsAPI, with url: String) {
        guard let idString = url.dropLast(1).components(separatedBy: "/").last,
              let id = Int(idString)
        else {
            return nil
        }
        self.url = url
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
