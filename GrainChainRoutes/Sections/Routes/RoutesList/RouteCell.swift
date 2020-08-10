//
//  RouteCell.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(with route: Route) {
        textLabel?.text = "\(route.name ?? "") - \(route.distance ?? "") km"
    }
}
