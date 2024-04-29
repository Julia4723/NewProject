//
//  PokemonViewCell.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit

final class PokemonViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            nameLabel,
            pokemonImage
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        doConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//            pokemonImageView.layer.cornerRadius = pokemonImageView.frame.height / 2
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let pokemonImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    func doConstrains() {
        NSLayoutConstraint.activate([
            pokemonImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            pokemonImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            pokemonImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            pokemonImage.widthAnchor.constraint(equalToConstant: 80),
            pokemonImage.heightAnchor.constraint(equalToConstant: 80),
            nameLabel.leftAnchor.constraint(equalTo: pokemonImage.rightAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
        
        
        // MARK: - Public methods
        
        func configure(with pokemon: Pokemon) {
            nameLabel.text = pokemon.name.capitalized
            
            NetworkManager.shared.fetch(dataType: Character.self, url: pokemon.url) { character in
                NetworkManager.shared.fetchImage(from: character.sprites.other.home.frontDefault) { [weak self] result in
                    switch result {
                    case .success(let imageData):
                        self?.pokemonImage.image = UIImage(data: imageData)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        }
    }


