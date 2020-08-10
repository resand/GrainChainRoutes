//
//  MapViewModel.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation
import CoreLocation

class MapViewModel {
    enum TrackerRecordEvent {
        case startLocation
        case timerUpdate
        case locationUpdate
    }

    enum TrackerStatus {
        case start
        case end
        case saved
    }

    private var route: Route?
    private var locations = [Locations]()
    private var startTime: Date = Date()
    private var endTime: Date = Date()

    func getTitle() -> String {
        return LocalizableStrings.mapViewTitle
    }

    public var startLocation: CLLocationCoordinate2D?
    public var storedCoordinates: [CLLocationCoordinate2D] {
        let coordinates = locations.map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
        return coordinates
    }

    public var initializedAPIKey = false
    public var onTracking: Bool = false
    private var id = 0

    public var locationInfoString: String {
        guard let location = LocationManager.shared.location else { return "" }
        return "Latitude: \(location.coordinate.latitude)" + "\n" +
            "Longitude: \(location.coordinate.longitude)" + "\n" +
            "Speed: \((location.speed * 3.6).rounded(.up)) km/h" + "\n" +
            "Alt: \(location.altitude) m"
    }

    public var locationUpdateHandler: (TrackerRecordEvent) -> Void = { _ in }
    public var trackerStatusUpdateHandler: (TrackerStatus) -> Void = { _ in }

    public init() {
        TrackerManager.shared.delegate = self
    }

    public func startRecording() {
        TrackerManager.shared.updateFrequency = 1.0
        TrackerManager.shared.start()
        startTime = Date()
        onTracking = true
    }

    public func stopRecording() {
        endTime = Date()
        onTracking = false
        TrackerManager.shared.stop()
        trackerStatusUpdateHandler(.end)
    }

    public func saveRoute(_ routeName: String) {
        guard !locations.isEmpty else { return }

        route?.name = routeName

        for i in 0 ..< locations.count {
            let routePoint: RoutePoint = RoutePoint.new()
            routePoint.id = locations[i].id
            routePoint.latitude = locations[i].latitude
            routePoint.longitude = locations[i].longitude
            route?.addToPoints(routePoint)
        }

        route?.save()
        clean()
    }

    private func clean() {
        locations.removeAll()
        TrackerManager.shared.updateFrequency = 0.0
    }

    private func calculateMapData() {
        // Duration
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        let totalDurationString = formatter.string(from: startTime, to: endTime)

        // Distance
        let firstLocation = storedCoordinates.first
        let lastLocation = storedCoordinates.last

        let startLocation = CLLocation(latitude: firstLocation?.latitude ?? 0.0, longitude: firstLocation?.longitude ?? 0.0)
        let endLocation = CLLocation(latitude: lastLocation?.latitude ?? 0.0, longitude: lastLocation?.longitude ?? 0.0)

        let distance: CLLocationDistance = startLocation.distance(from: endLocation)
        let kilometers = distance / 1000

        route = Route.new()
        route?.time = totalDurationString
        route?.distance = String(format: "%.3f", kilometers)
    }
}

extension MapViewModel: TrackerManagerDelegate {
    func trackerDidStartLocation(_ location: CLLocation) {
        startLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locationUpdateHandler(.startLocation)
    }

    func trackerDidStart() {
        //
    }

    func trackerDidPaused() {
        //
    }

    func trackerDidFinished() {
        calculateMapData()
    }

    func trackerDidTick(_ location: CLLocation) {
        id += 1
        let point = Locations(id: Int64(id), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        locations.append(point)
        locationUpdateHandler(.timerUpdate)

        guard locations.count < 2 else { return }

        trackerStatusUpdateHandler(.start)
    }

    func trackerDidUpdateLocation(_ location: CLLocation) {
        locationUpdateHandler(.locationUpdate)
    }
}
