//
//  ListEntity.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 12.10.2023.
//

import SwiftData

@Model
final class NextURL {
    @Attribute(.unique) var url: String?
    
    init(url: String?) {
        self.url = url
    }
}

@Model
final class Pokemon: Hashable {
    @Attribute(.unique) var id: Int
    var name: String
    var url: String
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name.capitalized
        self.url = url
    }
    
    init?(id: Int?, name: String, url: String) {
        guard let id else { return nil }
        self.id = id
        self.name = name.capitalized
        self.url = url
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
    var id: Int? {
        if let idString = url.dropLast(1).components(separatedBy: "/").last, let id = Int(idString) {
            return id
        } else {
            return nil
        }
    }
}
