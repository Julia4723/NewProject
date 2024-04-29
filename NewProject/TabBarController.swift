//
//  TabBarController.swift
//  NewProject
//
//  Created by user on 20.04.2024.
//

import UIKit


final class TabBarViewController: UITabBarController {
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
    }
    

    // Для передачи данных между таббаами
    private func setupViewControllers() {
        
        let charactersTableVC = CharactersTableViewController()
        let settingsVC = SettingsViewController()
        
        charactersTableVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: nil)
        
        viewControllers = [charactersTableVC, settingsVC]
        self.navigationItem.title = "Home"
         
         
    }
}
