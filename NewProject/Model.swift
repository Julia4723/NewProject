//
//  Model.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import Foundation



struct PokemonApp: Codable {
    let results: [Pokemon]
}


struct Pokemon: Codable {
    let name: String
    let url: String

    
    var description: String {
        """
Name: \(name)
"""
    }
}


struct Character: Codable {
    let sprites: Sprites
}


struct Sprites: Codable {
    let other: Home
}


struct Home: Codable {
    let home: Front
}

struct Front: Codable {
    let frontDefault: String
    
    enum CodingKeys: String,CodingKey {
        case frontDefault = "front_default"
    }
    
}






