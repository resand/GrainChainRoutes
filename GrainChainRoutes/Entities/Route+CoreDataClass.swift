//
//  Route+CoreDataClass.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//
//

import Foundation
import CoreData


public class Route: NSManagedObject, CDHelperEntity {
    public static var entityName: String { return "Route" }
}
