//
//  CoreDataManager.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 20.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import CoreData


/// Core Data ENTITIES
struct ENT {
	public static let CompanyModel 			= "CompanyModel"
	public static let Employee 				= "Employee"
	public static let PrivateInformation 	= "PrivateInformation"
}


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
	
	
	public func createEmployee(employeeName	: String,
							   type			: String,
							   birthday		: Date,
							   company		: CompanyModel) -> (Employee?, Error?) {
		
		let context = persistentContainer.viewContext
		// PrivateInformation
		// let information = NSEntityDescription.insertNewObject(forEntityName: ENT.PrivateInformation, into: context) as! PrivateInformation
		let information = PrivateInformation(context: context)
		information.birthDay = birthday
		
		// Employee
		// let employee = NSEntityDescription.insertNewObject(forEntityName: ENT.Employee, into: context) as! Employee
		let employee = Employee(context: context)
		employee.name = employeeName
		employee.privateInformation = information
		employee.company = company
		employee.type = type
 		do {
			try context.save()
			return (employee, nil)
		}
		catch let err {
			print("Failed to create employee, \(err.localizedDescription)")
			return (nil, err)
		}
	}
	
	
	public func saveContext(){
		do {
			try persistentContainer.viewContext.save()
		}
		catch let err {
			print("Failed to save data: \(err.localizedDescription)")
		}
	}
	
	
	/// not awesome method for fetching
	public func fetchCompanies() -> [CompanyModel]{
		let context = persistentContainer.viewContext
		var returnedArr = [CompanyModel]()
		
		let fetchRequest = NSFetchRequest<CompanyModel>(entityName: ENT.CompanyModel)
		do {
			returnedArr = try context.fetch(fetchRequest)
			return returnedArr
		}
		catch let error {
			print("Failed to load data: \(error.localizedDescription)")
			return []
		}
	}
	
	
}



























