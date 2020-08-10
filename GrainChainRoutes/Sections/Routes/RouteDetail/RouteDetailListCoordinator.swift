//
//  RouteDetailListCoordinator.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation

class RouteDetailListCoordinator: Coordinator {
    
    var context: Context?
    var route: Route?
    
    init(context: Context, with route: Route) {
        self.context = context
        self.route = route
    }
    
    func start() {
        let viewController = RouteDetailListViewController()
        viewController.viewModel = RouteDetailListViewModel(route: route!)
        viewController.coordinator = self
        context?.push(viewController: viewController)
    }
}
