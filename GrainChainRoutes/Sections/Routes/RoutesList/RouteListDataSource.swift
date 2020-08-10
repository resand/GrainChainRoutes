//
//  RouteListDataSource.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit

class RouteListDataSource: NSObject {
    typealias RouteSelectHandler = (Route) -> ()

    var routes: [Route] = []
    var didSelectItemHandler: RouteSelectHandler?

    init(with routes: [Route], didSelectItemHandler: @escaping RouteSelectHandler) {
        self.routes = routes
        self.didSelectItemHandler = didSelectItemHandler
    }
}

extension RouteListDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.Cell.routeCell, for: indexPath) as? RouteCell else {
            fatalError("Could not cast RouteCell")
        }

        let route = routes[indexPath.row]
        cell.setup(with: route)
        return cell
    }
}

extension RouteListDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = routes[indexPath.row]
        didSelectItemHandler?(route)
    }
}
