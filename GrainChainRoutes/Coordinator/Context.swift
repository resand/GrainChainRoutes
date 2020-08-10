//
//  Context.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation
import UIKit

class Context {

    weak var coordinator: Coordinator?
    var navigationController: UINavigationController

    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func initialize(coordinator: Coordinator) {
        self.coordinator = coordinator
        coordinator.start()
    }

    func push(viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
