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

    let searchController = UISearchController(searchResultsController: nil)
    private var filteredPokemon:[Pokemon] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        
        tableView.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        setupNavigationBar()
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
        let pokemon = isFiltering
        ? filteredPokemon[indexPath.row]
        : pokemonsAll[indexPath.row]
        guard let detailVC = segue.destination as? CharacterDetailsViewController else { return }
        detailVC.pokemon = pokemon
    }
    
    private func setupNavigationBar() {
        title = "Pokemons"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        //navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        //navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
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
        if isFiltering {
            return filteredPokemon.count
        }
        return pokemonsAll.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUI", for: indexPath)
        guard let cell = cell as? PokemonViewCell else { return UITableViewCell()}
        
        let pokemon: Pokemon
        if isFiltering {
            pokemon = filteredPokemon[indexPath.row]
        }else {
            pokemon = pokemonsAll[indexPath.row]
        }
        
        cell.configure(with: pokemon)
        return cell
        
    }
}




// MARK: - UISearchResultsUpdating
    extension CharactersTableViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            
            filterContentForSearchText(searchBar.text!)
        }
        
        private func filterContentForSearchText(_ searchText: String) {
            filteredPokemon = pokemonsAll.filter({ (pokemon: Pokemon) -> Bool in
                return pokemon.name.lowercased().contains(searchText.lowercased())

            })
            tableView.reloadData()
        }
    }

        
        
       
