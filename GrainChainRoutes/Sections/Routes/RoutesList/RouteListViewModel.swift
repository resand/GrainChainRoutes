//
//  RouteListViewModel.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation

class RouteListViewModel {
    
    var routes: [Route] = []
    
    func getTitle() -> String {
        return LocalizableStrings.listRouteViewTitle
    }
    
    func getDataSource(didSelectItemHandler: @escaping RouteListDataSource.RouteSelectHandler) -> RouteListDataSource {
        return RouteListDataSource(with: routes, didSelectItemHandler: didSelectItemHandler)
    }
    
    func getRoutes(completion: @escaping () -> Void) {
        let routesList = Route.findAll.exec()
        routes = routesList
        
        completion()
    }
    
    func numberOfItems() -> Int {
        return routes.count
    }
    
    func movie(at indexPath: IndexPath) -> Route {
        return routes[indexPath.row]
    }
}
