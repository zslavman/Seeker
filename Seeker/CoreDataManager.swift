//
//  CoreDataManager.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 20.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import CoreData


class CoreDataManager {
	
	public static let shared = CoreDataManager()
	
	public let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CoreDataModel")
		container.loadPersistentStores {
			(storeDescription, error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
		}
		return container
	}()
	
	
	
}
























