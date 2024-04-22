//
//  Model.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import Foundation

struct PokemonApp: Decodable {
    let results: [Pokemon]
}


struct Pokemon: Decodable {
    let name: String
    let url: String
    
    var description: String {
        """
Name: \(name)
"""
    }
}


struct Character: Decodable {
    let sprites: Sprites
}


struct Sprites: Decodable {
    let other: Home
}


struct Home: Decodable {
    let home: Front
}

struct Front: Codable {
    let frontDefault: String
    
    enum CodingKeys: String,CodingKey {
        case frontDefault = "front_default"
    }
    
}





