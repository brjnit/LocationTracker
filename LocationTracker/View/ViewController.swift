//
//  ViewController.swift
//  LocationTracker
//
//  Created by Brajesh Kumar on 29/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

	private var viewModel: ViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = ViewModel()
	}
}
