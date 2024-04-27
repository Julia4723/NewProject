//
//  CharacterDetailsViewController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit

final class CharacterDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var characterImageView: UIImageView! {
        didSet {
            characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
        }
    }
    
    //MARK: - Public Properties
    var pokemon: Pokemon!
    
    //MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var spinnerView = UIActivityIndicatorView()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
            
        title = pokemon.name
        
        showSpinner(in: characterImageView)
        fetchImage()
        
    }
    
    //MARK: - Private Methods
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
                    self.characterImageView.image = UIImage(data: imageData)
                    self.spinnerView.stopAnimating()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}
