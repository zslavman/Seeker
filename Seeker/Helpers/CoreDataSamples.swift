//
//  CoreDataSamples.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 25.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData

extension CompaniesController {
	
	
	@objc internal func doWork(){
		
		CoreDataManager.shared.persistentContainer.performBackgroundTask {
			(backgroundContext: NSManagedObjectContext) in
			
			Calc.timeMeasuringCodeRunning(title: "doWork()") {
				(0...15).forEach { (value) in
					print(value)
					let company = CompanyModel(context: backgroundContext)
					company.name = "\(value)"
				}
				
				do {
					try backgroundContext.save()
					DispatchQueue.main.async {
						self.companiesArr = CoreDataManager.shared.fetchCompanies()
						self.tableView.reloadData()
					}
				}
				catch let err {
					print("Failed to save:", err.localizedDescription)
				}
			}
		}
	}
	
	
	@objc internal func doUpdate(){
		CoreDataManager.shared.persistentContainer.performBackgroundTask {
			(backgroundContext: NSManagedObjectContext) in
			
			let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
			do {
				let companies = try backgroundContext.fetch(request)
				
				companies.forEach({ (company) in
					print(company.name ?? "")
					company.name = "FD: \(company.name ?? "123")"
				})
				
				do {
					try backgroundContext.save()
					
					// try to update UI after save
					DispatchQueue.main.async {
						// reset will forget all of the objects fetched before
						CoreDataManager.shared.persistentContainer.viewContext.reset() // no visible changes without this
						
						self.companiesArr = CoreDataManager.shared.fetchCompanies()
						
						self.tableView.reloadData()
					}
					
				} catch {
					print("Failed to save on backgrpond")
				}
			} catch {
				print("Failed to fetch companies")
			}
			
		}
	}
	
	
	@objc internal func doNestedUpdates(){
		
		DispatchQueue.global(qos: .background).async {
			
			// construct a custom Managed Object Context (MOC)
			let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
			privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
			
			// execute updates on privateContext
			let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
			request.fetchLimit = 1
			
			do {
				let companies = try privateContext.fetch(request)
				companies.forEach({ (comp) in
					print(comp.name ?? "")
					comp.name = "D-> \(comp.name ?? "")"
				})
				do {
					try privateContext.save()
					
					// after save succeeded
					DispatchQueue.main.async {
						do {
							let context = CoreDataManager.shared.persistentContainer.viewContext
							if context.hasChanges {
								try context.save()
								self.tableView.reloadData()
							}
						} catch let err {
							print("Failed to save main context", err.localizedDescription)
						}
					}
				} catch {
					print("Failed to save private context")
				}
				
			} catch {
				print("Failed to fetch on private context")
			}
		}
	}
	
	
	
	
	
}
