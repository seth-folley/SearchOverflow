//
//  AppCoordinator.swift
//  SearchOverflow
//
//  Created by Seth Folley on 4/22/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [CoordinatorType : Coordinator] = [:]
    private(set) var navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        navController = navigationController
//        navController.isNavigationBarHidden = true
    }

    func begin() {
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
        vc.coordintator = self
        vc.searchController = SearchController(with: NetworkRouter())
        navController.pushViewController(vc, animated: true)
    }
    
    func viewQuestionDetails(_ question: Question) {
        guard let vc = QuestionDetailsViewController.initializeFromStoryboard(with: question) else { return }
        vc.coordinator = self

        navController.pushViewController(vc, animated: true)
    }
    
    func questionDetailsHasFinished() {
        if navController.topViewController is QuestionDetailsViewController {
            navController.popViewController(animated: true)
        }
    }
}