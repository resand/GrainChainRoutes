//
//  Route+CoreDataProperties.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var distance: String?
    @NSManaged public var name: String?
    @NSManaged public var time: String?
    @NSManaged public var points: NSSet?

}

// MARK: Generated accessors for points
extension Route {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: RoutePoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: RoutePoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}
