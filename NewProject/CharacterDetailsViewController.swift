//
//  CharacterDetailsViewController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit
import Alamofire
import Kingfisher

final class CharacterDetailsViewController: UIViewController {
    
    var pokemon = Pokemon(name: "", url: "")
    
    //MARK: - IBOutlets
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var label: UILabel!

   
    //MARK: - Public Properties
    //var pokemon: Pokemon!
    
    //MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = pokemon.name

        updateUI()
        fetchImage()
        
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
       }
       
    
    //MARK: - Private Methods
    
//    private func fetchImage() {
//        NetworkManager.shared.fetch(dataType: Character.self, url: pokemon.url) { character in
//            let imageURL = URL(string: character.sprites.other.home.frontDefault)
//            self.characterImageView.kf.setImage(with: imageURL)
//            
//        }
//    }
//    
    
    private func updateUI() {
        label.text = pokemon.name
        
    }
 
    private func fetchImage() {
        NetworkManager.shared.fetch(dataType: Character.self, url: pokemon.url) { character in
            NetworkManager.shared.fetchImage(from: character.sprites.other.home.frontDefault) { result in
                switch result {
                case .success(let imageData):
                    self.characterImageView.image = UIImage(data: imageData)
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    
}
