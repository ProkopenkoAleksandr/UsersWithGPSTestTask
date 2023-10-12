//
//  AppCoordinator.swift
//  e-legionTestTask
//
//  Created by Aleksandr Prokopenko on 10.03.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        navigationController = navController
    }
    
    func start() {
        goToUsersVC()
    }
    
    func goToUsersVC() {
        let usersVM = UsersViewModel(delegate: self)
        let usersVC = UsersViewController(viewModel: usersVM)
        
        navigationController.pushViewController(usersVC, animated: true)
    }
    
}

extension AppCoordinator: UserViewModelDelegate {
    func example() {
        // TODO: Here you can push another VC
    }
    
}
