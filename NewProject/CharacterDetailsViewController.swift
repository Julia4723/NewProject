//
//  CharacterDetailsViewController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit

final class CharacterDetailsViewController: UIViewController {
    //MARK: - Public Properties
    var pokemon: Pokemon!
    
    //MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var spinnerView = UIActivityIndicatorView()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
            
        title = pokemon.name.capitalized
        
        view.addSubview(pokemonImage)
        doConstrains()
        
        showSpinner(in: pokemonImage)
        fetchImage()
    }
    
    let pokemonImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Private Methods
    func doConstrains() {
        NSLayoutConstraint.activate([
            pokemonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: 300),
            pokemonImage.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .white
        spinnerView.startAnimating()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
    
    private func fetchImage() {
        NetworkManager.shared.fetch(dataType: Character.self, url: pokemon.url) { character in
            NetworkManager.shared.fetchImage(from: character.sprites.other.home.frontDefault) { result in
                switch result {
                case .success(let imageData):
                    self.pokemonImage.image = UIImage(data: imageData)
                    self.spinnerView.stopAnimating()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}
