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
	
	
	
	public func fetchCompanies() -> [CompanyModel]{
		
		let context = persistentContainer.viewContext
		var returnedArr = [CompanyModel]()
		
		let fetchRequest = NSFetchRequest<CompanyModel>(entityName: "CompanyModel")
		do {
			returnedArr = try context.fetch(fetchRequest)
			return returnedArr
		}
		catch let error {
			print("Failed to load data: \(error.localizedDescription)")
			return []
		}
	}
	
	
	/// we need return Error for catch it in caller Class
	public func createEmployee(employeeName: String) -> Error? {
		let context = persistentContainer.viewContext
		
		let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
		employee.setValue(employeeName, forKey: "name")
		
		do {
			try context.save()
			return nil
		}
		catch let err {
			print("Failed to create employee, \(err.localizedDescription)")
			return err
		}
		
	}
	
}

























