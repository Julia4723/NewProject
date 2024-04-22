//
//  PokemonViewCell.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit

final class PokemonViewCell: UITableViewCell {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    func didSet() {
            pokemonImageView.contentMode = .scaleAspectFit
            pokemonImageView.clipsToBounds = true
            pokemonImageView.layer.cornerRadius = pokemonImageView.frame.height / 2
            pokemonImageView.backgroundColor = .white
        }
        
        
        // MARK: - Public methods
        
        func configure(with pokemon: Pokemon) {
            nameLabel.text = pokemon.name
            
            NetworkManager.shared.fetch(dataType: Character.self, url: pokemon.url) { character in
                NetworkManager.shared.fetchImage(from: character.sprites.other.home.frontDefault) { [weak self] result in
                    switch result {
                    case .success(let imageData):
                        self?.pokemonImageView.image = UIImage(data: imageData)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        }
    }


