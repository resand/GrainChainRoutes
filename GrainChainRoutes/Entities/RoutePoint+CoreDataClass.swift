//
//  RoutePoint+CoreDataClass.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


public class RoutePoint: NSManagedObject, CDHelperEntity {
    public static var entityName: String { return "RoutePoint" }
    
    
    var toCLLocationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
