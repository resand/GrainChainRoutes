//
//  MapViewController.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController {

    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var context: Context?
    var viewModel: MapViewModel!

    fileprivate lazy var mapView: GMSMapView = setupMapView()
    fileprivate lazy var startTrackingButton: UIButton = setupTrackingButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observerLocationUpdates()
        observerTrackerStatusUpdateHandler()
    }

    private func configureView() {
        title = viewModel.getTitle()
    }

    override func createView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rutas", style: .plain, target: self, action: #selector(goRouteList))
    }

    override func addViews() {
        [mapView, startTrackingButton].forEach {
            view.addSubview($0!)
        }
    }

    override func setupLayout() {
        // mapView
        mapView.topAnchor(equalTo: view.topAnchor)
        mapView.bottomAnchor(equalTo: view.bottomAnchor)
        mapView.leadingAnchor(equalTo: view.leadingAnchor)
        mapView.trailingAnchor(equalTo: view.trailingAnchor)

        // startTrackingButton
        startTrackingButton.heightAnchor(equalTo: 40)
        startTrackingButton.widthAnchor(equalTo: 150)
        startTrackingButton.bottomAnchor(equalTo: view.safeBottomAnchor, constant: -10)
        startTrackingButton.centerXAnchor(equalTo: view.centerXAnchor)
    }
}


// MARK: - Views

extension MapViewController {
    private func setupMapView() -> GMSMapView {
        if !viewModel.initializedAPIKey {
            if !GMSServices.provideAPIKey(Constants.Keys.googleMapsAPIKey) {
                NSLog("Google maps API key invalid.")
            }
            viewModel.initializedAPIKey = true
        }

        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 16)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.zoomGestures = true
        return mapView
    }

    private func setupTrackingButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("INICIAR RUTA", for: .normal)
        button.backgroundColor = UIColor(hex: Constants.Colors.mainColor)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(trackingButtonPressed), for: .touchUpInside)
        return button
    }
}

// MARK: - Target Actions

extension MapViewController {

    @objc private func trackingButtonPressed() {
        if !viewModel.onTracking {
            LoadingIndicatorView.show("INICIANDO RUTA...")
            viewModel.startRecording()
        } else {
            LoadingIndicatorView.show("FINALIZANDO RUTA...")
            viewModel.stopRecording()
        }
    }

    @objc private func goRouteList() {
        context?.initialize(coordinator: RouteListCoordinator(context: context!))
    }
}

// MARK: - Methods

extension MapViewController {

    private func addMarker() {
        guard viewModel.storedCoordinates.count > 0 else { return }
        let initialLocation = viewModel.onTracking ? viewModel.storedCoordinates.first : viewModel.storedCoordinates.last
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: initialLocation!.latitude, longitude: initialLocation!.longitude)
        marker.icon = UIImage(named: viewModel.onTracking ? "marker_start" : "marker_end")
        marker.map = mapView

        if !viewModel.onTracking { saveRoute() }
    }

    private func drawPolyline() {
        let path = GMSMutablePath()
        for route in viewModel.storedCoordinates {
            path.addLatitude(route.latitude, longitude: route.longitude)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = UIColor(hex: Constants.Colors.secundaryColor)
        polyline.geodesic = true
        polyline.map = mapView
    }

    private func saveRoute() {
        let saveAlert = UIAlertController(title: "¡Atención!", message: "Ingresa un nombre para guardar tu ruta.", preferredStyle: UIAlertController.Style.alert)

        let actionSave = UIAlertAction(title: "Guardar", style: .default) { (alertAction) in
            let textField = saveAlert.textFields![0] as UITextField
            if textField.text != "" {
                self.viewModel.saveRoute(textField.text!)
                self.mapView.clear()
            }
        }

        saveAlert.addTextField { (textField) in
            textField.placeholder = "Nombre"
        }
        saveAlert.addAction(UIAlertAction(title: "Cancelar", style: .default) { (alertAction) in
            self.mapView.clear()
        })
        saveAlert.addAction(actionSave)

        self.present(saveAlert, animated: true, completion: nil)
    }
}

// MARK: - Observers View Model

extension MapViewController {

    private func observerLocationUpdates() {
        viewModel?.locationUpdateHandler = { [weak self] updateType in
            guard let `self` = self else { return }

            switch updateType {
            case .startLocation:
                let userLocation = self.viewModel.startLocation

                let camera = GMSCameraPosition(target: userLocation!, zoom: 16, bearing: 0, viewingAngle: 0)
                self.mapView.animate(to: camera)
            case .timerUpdate:
                let locations = self.viewModel?.storedCoordinates ?? []
                let userLocation = locations.last

                let camera = GMSCameraPosition(target: userLocation!, zoom: self.mapView.camera.zoom, bearing: 0, viewingAngle: 0)
                self.mapView.animate(to: camera)
            case .locationUpdate:
                self.drawPolyline()
            }
        }
    }

    private func observerTrackerStatusUpdateHandler() {
        viewModel?.trackerStatusUpdateHandler = { [weak self] status in
            guard let `self` = self else { return }

            switch status {
            case .start:
                LoadingIndicatorView.hide()
                self.startTrackingButton.setTitle("FINALIZAR RUTA", for: .normal)
                self.addMarker()
            case .end:
                LoadingIndicatorView.hide()
                self.startTrackingButton.setTitle("INICIAR RUTA", for: .normal)
                self.mapView.clear()
                self.addMarker()
            case .saved:
                break
            }
        }
    }
}
