//
//  SwiftDataService.swift
//  PokemonInfo
//
//  Created by Vyacheslav on 18.10.2023.
//

import SwiftData
import OSLog

protocol SwiftDataServiceProtocol {
    func updateNextURL(nextURL: NextURL) async
    func insertPokemon(pokemon: Pokemon) async
    
    func fetchAllPokemons() async -> [Pokemon]
    func fetchNextURL() async -> NextURL?
}

final class SwiftDataService: SwiftDataServiceProtocol {
    
    // MARK: Private Properties
    
    private var container: ModelContainer?
    private var context: ModelContext?
    private let logger = Logger(subsystem: #file, category: "Error logger")

    // MARK: Initialisers
    
    init() {
        do {
            let schema = Schema([NextURL.self, Pokemon.self, PokemonDetails.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)
            container = try ModelContainer(for: schema, configurations: modelConfiguration)
            guard let container else { return }
            context = ModelContext(container)
            context?.autosaveEnabled = true
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    // MARK: Public Properties
    
    @MainActor
    func updateNextURL(nextURL: NextURL) async {
        do {
            let url = nextURL.url
            let descriptor = FetchDescriptor<NextURL>(predicate: #Predicate<NextURL> { $0.url == url })
            let foundNextURL = try context?.fetch(descriptor).first

            if let foundNextURL {
                foundNextURL.url = nextURL.url
            } else {
                context?.insert(nextURL)
            }
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    @MainActor
    func insertPokemon(pokemon: Pokemon) async {
        do {
            let id = pokemon.id
            let descriptor = FetchDescriptor<Pokemon>(predicate: #Predicate<Pokemon> { $0.id == id })
            let foundPokemon = try context?.fetch(descriptor).first
            
            if let foundPokemon {
                foundPokemon.name = pokemon.name
                foundPokemon.url = pokemon.url
            } else {
                context?.insert(pokemon)
            }
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    @MainActor
    func fetchAllPokemons() async -> [Pokemon] {
        guard let context else { return [] }
        do {
            let descriptor = FetchDescriptor<Pokemon>()
            return try context.fetch(descriptor)
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
            return []
        }
    }
    
    @MainActor
    func fetchNextURL() async -> NextURL? {
        do {
            let descriptor = FetchDescriptor<NextURL>()
            return try context?.fetch(descriptor).last
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
        
    @MainActor
    func insertPokemonDetails(pokemonDetails: PokemonDetails) async {
        do {
            let url = pokemonDetails.url
            let predicate = #Predicate<PokemonDetails> { $0.url == url }
            let descriptor = FetchDescriptor<PokemonDetails>(predicate: predicate)
            let foundPokemonDetails = try context?.fetch(descriptor).first
            
            if let foundPokemonDetails {
                foundPokemonDetails.id = pokemonDetails.id
                foundPokemonDetails.name = pokemonDetails.name
                foundPokemonDetails.imageURLString = pokemonDetails.imageURLString
                foundPokemonDetails.imageData = pokemonDetails.imageData
                foundPokemonDetails.type = pokemonDetails.type
                foundPokemonDetails.weightKg = pokemonDetails.weightKg
                foundPokemonDetails.height = pokemonDetails.height
            } else {
                context?.insert(pokemonDetails)
            }
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
        }
    }
    
    @MainActor
    func fetchPokemonDetails(url: String) async -> PokemonDetails? {
        do {
            let predicate = #Predicate<PokemonDetails> { $0.url == url }
            let descriptor = FetchDescriptor<PokemonDetails>(predicate: predicate)
            return try context?.fetch(descriptor).last
        } catch {
            logger.error("\(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
}
