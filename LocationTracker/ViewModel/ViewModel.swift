//
//  ViewModel.swift
//  LocationTracker
//
//  Created by Brajesh Kumar on 30/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationModel {
	var latitude: Double
	var longitude: Double
	var timestamp: Date
}

class ViewModel: NSObject, CLLocationManagerDelegate {
	private let manager = CLLocationManager()
	private static let TimeInterval = 13.0
	private let reachability = Reachability()

	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestWhenInUseAuthorization()
		if CLLocationManager.locationServicesEnabled() {
			manager.delegate = self
			manager.allowsBackgroundLocationUpdates = true
			manager.startUpdatingLocation()
			scheduledTimerWithTimeInterval()
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			manager.stopUpdatingLocation()
			render(location)
		}
	}

	private func render(_ location: CLLocation) {
	   let latestLocation =	LocationModel(latitude: location.coordinate.latitude,
					  longitude: location.coordinate.longitude,
					  timestamp: location.timestamp)
		print("latitude: ", location.coordinate.latitude)
		print("longitude: ", location.coordinate.longitude)
		print("timestamp: ", location.timestamp)
		switch reachability.connectionStatus() {
			case .online:
				let data = LocalDataProvider.shared.loadData()
				if data.count>0 {
					print(data.count)
					print(data)
					LocalDataProvider.shared.clearData()
				}
			default:
				LocalDataProvider.shared.saveData(location: latestLocation)
		}
	}

	@objc func updateLocation() {
		manager.startUpdatingLocation()
	}

	func scheduledTimerWithTimeInterval(){
		Timer.scheduledTimer(timeInterval: ViewModel.TimeInterval, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
	}
}

