//
//  RouteListCoordinator.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation

class RouteListCoordinator: Coordinator {

    var context: Context?

    init(context: Context) {
        self.context = context
    }

    func start() {
        let viewController = RouteListViewController()
        viewController.viewModel = RouteListViewModel()
        viewController.coordinator = self
        viewController.context = context
        context?.push(viewController: viewController)
    }
}
