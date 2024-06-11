//
//  StorageManager.swift
//  NewProject
//
//  Created by user on 28.04.2024.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let pokemonKey = "pokemons"
    
    
    
    
    private init() {}
    
    
    func fetchNewPokemons() -> [Pokemon] {
        
        guard let data = userDefaults.data(forKey: pokemonKey) else { return [] }
        guard let pokemons = try? JSONDecoder().decode([Pokemon].self, from: data) else { return []}
        return pokemons
        
    }
    
    
    func save(pokemon: Pokemon) {
        var pokemons = fetchNewPokemons()
        pokemons.append(pokemon)
        guard let data = try? JSONEncoder().encode(pokemons) else { return}
        userDefaults.set(data, forKey: pokemonKey)
    }
    
    
    func deletePokemon(at index: Int) {
        var pokemons = fetchNewPokemons()
        pokemons.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(pokemons) else { return }
        userDefaults.set(data, forKey: pokemonKey)
        
    }
    
}
