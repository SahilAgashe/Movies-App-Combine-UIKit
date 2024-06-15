//
//  MainTabController.swift
//  Movies App
//
//  Created by SAHIL AMRUT AGASHE on 14/06/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moviesController = MoviesViewController(viewModel: MovieListViewModel(httpClient: HTTPClient()))
        moviesController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let scannerController = UINavigationController(rootViewController: ScannerController())
        scannerController.tabBarItem = UITabBarItem(title: "Scanner", image: UIImage(systemName: "scanner"), selectedImage: UIImage(systemName: "scanner.fill"))

        viewControllers = [moviesController, scannerController]
        
        tabBar.backgroundColor = .systemBackground
    }
}
