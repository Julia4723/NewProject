//
//  CharactersTableViewController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit

final class CharactersTableViewController: UITableViewController {
    
    //MARK: Private properties
    
    var pokemonsAll: [Pokemon] = []

    private let networkManager = NetworkManager.shared
    
    
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        fetchPokemons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Navigation
    // Здесь будем подготавливать данные для передачи на экран с детальной инфой
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        guard let detailVC = segue.destination as? CharacterDetailsViewController else { return }
    }
    
    
    private func fetchPokemons() {
        
        networkManager.fetch(dataType: PokemonApp.self, url: PokemonAPI.url.rawValue) { pokemonApp in
            self.pokemonsAll = pokemonApp.results
            self.tableView.reloadData()
            
        }
    }
}



// MARK: - UITableViewDataSource
extension CharactersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        pokemonsAll.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUI", for: indexPath)
        guard let cell = cell as? PokemonViewCell else { return UITableViewCell()}
        let pokemon = pokemonsAll[indexPath.row]
        cell.configure(with: pokemon)
        return cell
        
    }
}



/*
// MARK: - UISearchResultsUpdating
    extension CharactersTableViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            filterContentForSearchText(searchController.searchBar.text ?? "")
        }
        
        private func filterContentForSearchText(_ searchText: String) {
            filteredPokemon = searchText.isEmpty ? pokemonsAll :
                pokemonsAll.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        }
    }
*/

        
        
        
       
