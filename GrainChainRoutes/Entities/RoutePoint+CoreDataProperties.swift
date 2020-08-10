//
//  RoutePoint+CoreDataProperties.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//
//

import Foundation
import CoreData


extension RoutePoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutePoint> {
        return NSFetchRequest<RoutePoint>(entityName: "RoutePoint")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var id: Int64
    @NSManaged public var route: Route?

}
