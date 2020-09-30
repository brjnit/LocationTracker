//
//  LocalDataProvider.swift
//  LocationTracker
//
//  Created by Brajesh Kumar on 30/09/20.
//  Copyright © 2020 Brajesh Kumar. All rights reserved.
//

import UIKit
import CoreData

class LocalDataProvider {
	private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	public static let shared: LocalDataProvider = LocalDataProvider()

	private init() {

	}
	//MARK: setup core data context
	private func saveToContext() {
		do {
			try context.save()
		} catch  {
			print("Error in saving \(error)")
		}
	}

	func saveData(location: LocationModel) {
         let contextItem = GpsLocations(context: context)
		contextItem.latitude = location.latitude
		contextItem.longitude = location.longitude
		contextItem.timestamp = location.timestamp
		saveToContext()
	}

	func loadData() -> [LocationModel] {

		let request: NSFetchRequest<GpsLocations> = GpsLocations.fetchRequest()
		do {
			let data = try context.fetch(request)
			let storedData = data.map { item in
				return LocationModel(latitude: item.latitude,
									 longitude: item.longitude,
									 timestamp: item.timestamp ?? Date())
			}
			return storedData
		} catch  {
			print("Error in fetching")
		}
		return []
	}

	func clearData() {
		let request: NSFetchRequest<GpsLocations> = GpsLocations.fetchRequest()
		do {
			let data = try context.fetch(request)
			_ = data.map{context.delete($0)}
			try context.save()
		} catch  {
			print("Error in saving \(error)")
		}
	}
}
