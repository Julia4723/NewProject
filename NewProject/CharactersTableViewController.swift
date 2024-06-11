//
//  CharactersTableViewController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit
import Kingfisher
import Alamofire

protocol NewPokemonViewControllerDelegate: AnyObject {
    func add(pokemon: Pokemon)
    
}


final class CharactersTableViewController: UITableViewController {
    
    //MARK: Private properties
    var pokemonsAll: [Pokemon] = []
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    
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
        pokemonsAll = storageManager.fetchNewPokemons()
    }
    
    
    //MARK: - Navigation
    // Здесь будем подготавливать данные для передачи на экран с детальной инфой
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let pokemon = pokemonsAll[indexPath.row]
            let detailVC = segue.destination as! CharacterDetailsViewController
            detailVC.pokemon = pokemon
            

            
        } else if segue.identifier == "addPokemon" {
            guard let newPokemonVC = segue.destination as? NewPokemonViewController else { return }
            newPokemonVC.delegate = self
            
            
//            let newIndexPath = IndexPath(row: filteredPokemon.count, section: 0)
//            filteredPokemon.append(pokemon)
//            tableView.insertRows(at: [newIndexPath], with: .fade)
            
        }
        
        
        
        //        guard let newPokemonVC = segue.destination as? NewPokemonViewController else { return }
        //        newPokemonVC.delegate = self
        //
        //
        //        guard let indexPath = tableView.indexPathForSelectedRow else {
        //            return
        //        }
        //        let pokemon = isFiltering
        //        ? filteredPokemon[indexPath.row]
        //        : pokemonsAll[indexPath.row]
        //
        //        guard let detailVC = segue.destination as? CharacterDetailsViewController else { return }
        //        detailVC.pokemon = pokemon
        
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
        } else {
            pokemon = pokemonsAll[indexPath.row]
        }
        
        cell.configure(with: pokemon)
        return cell
        
    }
    
    //метод должен снимать выделение строки
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // 1
    //        tableView.deselectRow(at: indexPath, animated: true) // 2
    //
    //        let pokemon: Pokemon
    //        if isFiltering {
    //            pokemon = filteredPokemon[indexPath.row]
    //        } else {
    //            pokemon = pokemonsAll[indexPath.row]
    //        }
    //        performSegue(withIdentifier: "showDetail", sender: pokemon)
    //        }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //посмотреть в проекте с трек листами
        let movedRow = filteredPokemon.remove(at: sourceIndexPath.row)
        filteredPokemon.insert(movedRow, at: destinationIndexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pokemonsAll.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deletePokemon(at: indexPath.row)
        }
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


extension CharactersTableViewController: NewPokemonViewControllerDelegate {
    
    func add(pokemon: Pokemon) {
        pokemonsAll.append(pokemon)
        let indexPath = IndexPath(row: pokemonsAll.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        //tableView.reloadData()
    }
    
}





/* Метод с пост запросом через networkManager
 func add(pokemon: Pokemon) {
 networkManager.postNewPokemon(to: Link.postRequest.url, with: pokemon) { [unowned self] resault in
 switch resault {
 case .success(let pokemon):
 pokemonsAll.append(pokemon)
 let indexPath = IndexPath(row: pokemonsAll.count - 1, section: 0)
 tableView.insertRows(at: [indexPath], with: .automatic)
 case .failure(let error):
 print(error.localizedDescription)
 }
 }
 }
 */
