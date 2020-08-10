//
//  RouteListViewController.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 09/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import UIKit

class RouteListViewController: BaseViewController {
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var context: Context?
    var viewModel: RouteListViewModel!
    private var dataSource: RouteListDataSource?
    
    fileprivate lazy var routesTableView: UITableView = setupRoutesTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRoutes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureView() {
        title = viewModel?.getTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        routesTableView.register(RouteCell.self, forCellReuseIdentifier: Constants.Identifiers.Cell.routeCell)
    }

    override func createView() {
    }

    override func addViews() {
        view.addSubview(routesTableView)
    }

    override func setupLayout() {
        // routesTableView
        routesTableView.topAnchor(equalTo: view.topAnchor)
        routesTableView.bottomAnchor(equalTo: view.bottomAnchor)
        routesTableView.leadingAnchor(equalTo: view.leadingAnchor)
        routesTableView.trailingAnchor(equalTo: view.trailingAnchor)
    }
}

// MARK: - Views

extension RouteListViewController {

    private func setupRoutesTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}

// MARK: - Methods

extension RouteListViewController {
    
    func reloadData() {
        dataSource = viewModel?.getDataSource(didSelectItemHandler: didSelectRouteList())
        
        routesTableView.dataSource = dataSource
        routesTableView.delegate = dataSource
        routesTableView.reloadData()
    }
    
    private func getRoutes() {
        LoadingIndicatorView.show()
        viewModel?.getRoutes { [weak self] in
            DispatchQueue.main.async {
                self?.reloadData()
                LoadingIndicatorView.hide()
            }
        }
    }
}

// MARK: - Observers View Model

extension RouteListViewController {
    private func didSelectRouteList() -> RouteListDataSource.RouteSelectHandler {
           return { [weak self] (route) in
               if let selfStrong = self {
                selfStrong.context?.initialize(coordinator: RouteDetailListCoordinator(context: selfStrong.context!, with: route))
               }
           }
       }
}
