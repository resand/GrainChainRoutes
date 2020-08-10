//
//  RouteDetailListViewController.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit
import GoogleMaps

class RouteDetailListViewController: BaseViewController {

    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var context: Context?
    var viewModel: RouteDetailListViewModel!

    private lazy var mapView: GMSMapView = setupMapView()
    private lazy var infoView: UIView = setupInfoView()
    private lazy var nameRouteLabel: UILabel = setupNameRouteLabel()
    private lazy var distanceRouteLabel: UILabel = setupDistanceRouteLabel()
    private lazy var timeRouteLabel: UIView = setupTimeRouteLabel()
    private lazy var shareButton: UIButton = setupShareButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func configureView() {
        title = viewModel.getTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareRoute))
        setDataMap()
    }

    override func createView() {
        // Add border to content view
        let border = UIView()
        border.backgroundColor = UIColor(hex: Constants.Colors.mainColor)
        border.frame = CGRect(x: 0, y: 0, width: 15, height: infoView.frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        infoView.addSubview(border)
    }

    override func addViews() {
        [mapView, infoView].forEach {
            view.addSubview($0!)
        }

        [nameRouteLabel, distanceRouteLabel, timeRouteLabel, shareButton].forEach {
            infoView.addSubview($0!)
        }
    }

    override func setupLayout() {
        // mapView
        mapView.topAnchor(equalTo: view.topAnchor)
        mapView.bottomAnchor(equalTo: view.bottomAnchor)
        mapView.leadingAnchor(equalTo: view.leadingAnchor)
        mapView.trailingAnchor(equalTo: view.trailingAnchor)

        // infoView
        infoView.heightAnchor(equalTo: 180)
        infoView.widthAnchor(equalTo: view.layer.frame.width - 70)
        infoView.bottomAnchor(equalTo: view.safeBottomAnchor, constant: -10)
        infoView.centerXAnchor(equalTo: view.centerXAnchor)

        // nameRouteLabel
        nameRouteLabel.topAnchor(equalTo: infoView.topAnchor, constant: 10)
        nameRouteLabel.leadingAnchor(equalTo: infoView.leadingAnchor, constant: 30)
        nameRouteLabel.trailingAnchor(equalTo: infoView.trailingAnchor, constant: -20)

        // distanceRouteLabel
        distanceRouteLabel.topAnchor(equalTo: nameRouteLabel.bottomAnchor, constant: 10)
        distanceRouteLabel.leadingAnchor(equalTo: infoView.leadingAnchor, constant: 30)
        distanceRouteLabel.trailingAnchor(equalTo: infoView.trailingAnchor, constant: -20)

        // timeRouteLabel
        timeRouteLabel.topAnchor(equalTo: distanceRouteLabel.bottomAnchor, constant: 5)
        timeRouteLabel.leadingAnchor(equalTo: infoView.leadingAnchor, constant: 30)
        timeRouteLabel.trailingAnchor(equalTo: infoView.trailingAnchor, constant: -20)
        
        // shareButton
        shareButton.heightAnchor(equalTo: 25)
        shareButton.widthAnchor(equalTo: 80)
        shareButton.trailingAnchor(equalTo: infoView.trailingAnchor, constant: -12.5)
        shareButton.bottomAnchor(equalTo: infoView.bottomAnchor, constant: -12.5)
    }
}

// MARK: - Views

extension RouteDetailListViewController {

    private func setupMapView() -> GMSMapView {
        if !viewModel.initializedAPIKey {
            if !GMSServices.provideAPIKey(Constants.Keys.googleMapsAPIKey) {
                NSLog("Google maps API key invalid.")
            }
            viewModel.initializedAPIKey = true
        }

        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 16)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.settings.zoomGestures = true
        return mapView
    }


    private func setupInfoView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 12
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }

    private func setupNameRouteLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.route.name
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = UIColor(hex: Constants.Colors.mainColor)
        return label
    }

    private func setupDistanceRouteLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Distancia: \(viewModel.route.distance ?? "") km"
        label.font = .systemFont(ofSize: 18.0)
        label.textColor = UIColor(hex: Constants.Colors.mainColor)
        return label
    }

    private func setupTimeRouteLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Duración: \(viewModel.route.time ?? "")"
        label.font = .systemFont(ofSize: 18.0)
        label.textColor = UIColor(hex: Constants.Colors.mainColor)
        return label
    }
    
    private func setupShareButton() -> UIButton {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitle("ELIMINAR", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(deleteRoute), for: .touchUpInside)
        return button
    }
}

// MARK: - Methods

extension RouteDetailListViewController {

    private func setDataMap() {
        guard let points = viewModel?.route.points else {
            return
        }

        var locations = [Locations]()
        for location in points {
            let routePoint = location as! RoutePoint
            locations.append(Locations(id: routePoint.id, latitude: routePoint.latitude, longitude: routePoint.longitude))
        }

        let sortedLocations = locations.sorted {
            $0.id < $1.id
        }

        // Draw Polyline
        drawPolyline(sortedLocations)

        // Initial & final location
        guard let firstCoordinate = sortedLocations.first else { return }
        guard let lastCoordinate = sortedLocations.last else { return }
        addMarker(location: firstCoordinate, imageName: "marker_start")
        addMarker(location: lastCoordinate, imageName: "marker_end")

        // Center map
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude), coordinate: CLLocationCoordinate2D(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)))
        mapView.moveCamera(cameraUpdate)
        mapView.animate(toZoom: mapView.camera.zoom - 1.7)
    }

    private func addMarker(location: Locations, imageName: String) {
        let position = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named: imageName)
        marker.map = mapView
    }


    private func drawPolyline(_ locations: [Locations]) {
        let path = GMSMutablePath()
        for route in locations {
            path.addLatitude(route.latitude, longitude: route.longitude)
        }

        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = UIColor(hex: Constants.Colors.secundaryColor)
        polyline.geodesic = true
        polyline.map = mapView
    }

    @objc private func shareRoute() {
        let text = [viewModel?.getTextToShare()]
        let activityViewController = UIActivityViewController(activityItems: text as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc private func deleteRoute() {
        viewModel?.deleteRoute {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
