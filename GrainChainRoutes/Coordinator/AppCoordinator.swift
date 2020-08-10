//
//  AppCoordinator.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation

class AppCoordinator: Coordinator {

    var context: Context?

    init(context: Context) {
        self.context = context
    }

    func start() {
        let viewController = MapViewController()
        viewController.viewModel = MapViewModel()
        viewController.coordinator = self
        viewController.context = context
        context?.push(viewController: viewController)
    }
}
