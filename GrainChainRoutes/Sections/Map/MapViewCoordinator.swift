//
//  MapViewCoordinator.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation
import UIKit

class MapViewCoordinator: Coordinator {

    var window: UIWindow
    var context: Context?

    init(with window: UIWindow, context: Context) {
        self.window = window
        self.context = context
    }

    func start() {
        let viewController = MapViewController()
        viewController.viewModel = MapViewModel()
        viewController.coordinator = self
        viewController.context = context

        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
