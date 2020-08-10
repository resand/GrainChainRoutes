//
//  RouteDetailListViewModel.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation

class RouteDetailListViewModel {

    public var route: Route!
    public var initializedAPIKey = false

    init(route: Route) {
        self.route = route
    }

    func getTitle() -> String {
        return LocalizableStrings.listDetailRouteViewTitle
    }

    func getTextToShare() -> String {
        return """
        Mira la ruta del recorrido \(route.name ?? "").
        Distancia: \(route.distance ?? "") km
        Duración: \(route.time ?? "")
        """
    }

    func deleteRoute(completion: @escaping () -> Void) {
        let routeToDelete: Route? = Route.findOne.where("name").isEqual(to: route.name!).exec()
        routeToDelete?.destroy()
        completion()
    }
}
