//
//  TrackerManager.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation
import CoreLocation

public protocol TrackerManagerDelegate: class {
    func trackerDidStartLocation(_ location: CLLocation)
    func trackerDidStart()
    func trackerDidPaused()
    func trackerDidFinished()
    func trackerDidTick(_ location: CLLocation)
    func trackerDidUpdateLocation(_ location: CLLocation)
}

public class TrackerManager: NSObject {
    public static var shared = TrackerManager()

    public weak var timer: Timer?
    public weak var delegate: TrackerManagerDelegate?

    public var updateFrequency: Double?

    override init() {
        super.init()

        LocationManager.shared.delegate = self
        LocationManager.shared.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    deinit {
        timer?.invalidate()
        timer = nil
        LocationManager.shared.delegate = nil
    }

    public func start() {
        guard let updateFrequency = self.updateFrequency, updateFrequency > 0 && !updateFrequency.isNaN else {
            assertionFailure("invalid updateFrequency")
            return
        }
        LocationManager.shared.startUpdatingLocation()
        LocationManager.shared.startMonitoringSignificantLocationChanges()

        delegate?.trackerDidStart()

        timer = Timer.scheduledTimer(withTimeInterval: updateFrequency, repeats: true) { [weak self] _ in
            self?.timerUpdate()
        }
    }

    private func startLocation() {
        LocationManager.shared.startUpdatingLocation()
        LocationManager.shared.startMonitoringSignificantLocationChanges()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopStartLocation()
        }
    }

    public func pause() {
        delegate?.trackerDidPaused()
    }

    public func stop() {
        timer?.invalidate()
        LocationManager.shared.stopUpdatingLocation()
        LocationManager.shared.stopMonitoringSignificantLocationChanges()

        delegate?.trackerDidFinished()
    }
    
    private func stopStartLocation() {
        timer?.invalidate()
        LocationManager.shared.stopUpdatingLocation()
        LocationManager.shared.stopMonitoringSignificantLocationChanges()
        
        guard let location = LocationManager.shared.location else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        print(self, #function, "lat: \(latitude); lon: \(longitude)")
        self.delegate?.trackerDidStartLocation(location)
    }

    private func timerUpdate() {
        guard let location = LocationManager.shared.location else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        print(self, #function, "lat: \(latitude); lon: \(longitude)")
        self.delegate?.trackerDidTick(location)
    }
}

extension TrackerManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.trackerDidUpdateLocation(location)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .notDetermined, .restricted:
            self.pause()
        case .authorizedAlways, .authorizedWhenInUse:
            self.startLocation()
        @unknown default:
            self.stop()
        }
    }
}
