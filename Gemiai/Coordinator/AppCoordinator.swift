//
//  AppCoordinator.swift
//  Gemiai
//
//  Created by dbug on 3/21/25.
//

import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let home = HomeViewController.instantiate()
        home.coordinator = self
        navigationController.pushViewController(home, animated: true)
        
    }
    
}
