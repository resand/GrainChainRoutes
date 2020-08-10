//
//  BaseViewController.swift
//  GrainChainRoutes
//
//  Created by René Sandoval on 08/08/20.
//  Copyright © 2020 René Sandoval. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController: UIViewController {

    func configurationView() {
        view.backgroundColor = .white
    }

    func createView() {
        // Intentionally unimplemented...
    }

    func addViews() {
        // Intentionally unimplemented...
    }

    func setupLayout() {
        // Intentionally unimplemented...
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        createView()
        addViews()
        setupLayout()
    }
}
