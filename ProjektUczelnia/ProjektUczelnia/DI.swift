//
//  DI.swift
//  ProjektUczelnia
//
//  Created by mateusz on 15/02/2021.
//  Copyright © 2021 mateusz. All rights reserved.
//

import UIKit

class DependencyContainer {
    func makeRootViewController() -> UINavigationController {
        return UINavigationController(rootViewController: makeStartViewController())
    }
}

protocol ViewControllerFactory {
    func makeStartViewController() -> UIViewController
    func makeCategoriesTableViewController(delegate: CategoriesTableViewDelegate) -> UIViewController
    func makeBasketTableViewController() -> UIViewController
}

extension DependencyContainer: ViewControllerFactory {

    func makeStartViewController() -> UIViewController {
        let startViewController = StartViewController(factory: self)
        return startViewController
    }
    
    func makeCategoriesTableViewController(delegate: CategoriesTableViewDelegate) -> UIViewController {
        let categoriesTableViewController = CategoriesTableViewController(delegate: delegate)
        return categoriesTableViewController
    }
    
    func makeBasketTableViewController() -> UIViewController {
        return BasketTableViewController()
    }
}
