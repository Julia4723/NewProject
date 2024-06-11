//
//  NewPokemonViewController.swift
//  NewProject
//
//  Created by user on 28.04.2024.
//

import UIKit

final class NewPokemonViewController: UIViewController {
    
    @IBOutlet var firstTextNameLabel: UITextField!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    weak var delegate: NewPokemonViewControllerDelegate!
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let action = UIAction { [weak self] _ in
            guard let firstName = self?.firstTextNameLabel.text else { return }
            self?.doneButton.isEnabled = !firstName.isEmpty
        }
        firstTextNameLabel.addAction(action, for:.editingChanged)
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let firstName = firstTextNameLabel.text else { return }
        
        let newPokemons = Pokemon(name: firstName, url: PokemonAPI.url.rawValue)
        storageManager.save(pokemon: newPokemons)
        
        delegate.add(pokemon: newPokemons)
        dismiss(animated: true)
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}


