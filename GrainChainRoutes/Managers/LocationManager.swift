//
//  LocationManager.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationManager: CLLocationManager {
    public static let shared = CLLocationManager()

    private override init() {
        super.init()
        allowsBackgroundLocationUpdates = true
        pausesLocationUpdatesAutomatically = false
    }
}
