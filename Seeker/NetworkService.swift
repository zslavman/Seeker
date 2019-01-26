//
//  NetworkService.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 26.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import Foundation
import CoreData


struct NetworkService {
	
	public static let shared = NetworkService()
	private let json = "https://drive.google.com/uc?export=download&id=1Rbk49RDjWffwbs-nMA9WaMjsaOAKWg_r"

	
	public func downloadCompaniesFromServer(){
		
		guard let jsonURL = URL(string: json) else { return }
		
		URLSession.shared.dataTask(with: jsonURL) {
			(data, response, error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else { return }
			//let str = String(data: data, encoding: .utf8)
			
			do {
				let someData = try JSONDecoder().decode([CompanyNet].self, from: data)
				
				let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
				privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
				
				// save each company
				someData.forEach({
					(com) in
					
					let company = CompanyModel(context: privateContext)
					company.name = com.name
					
					// convert date (String -> Date)
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "MM/dd/yyyy"
					let foundedDate = dateFormatter.date(from: com.founded!)
					
					company.founded = foundedDate
					
					// save each employees of company
					com.employees?.forEach({
						(empl) in
						
						let employee = Employee(context: privateContext)
						employee.name = empl.name
						employee.type = empl.type
						
						// filling employee.privateInformation property
						let privateInformation = PrivateInformation(context: privateContext)
						let birthdayDate = dateFormatter.date(from: empl.birthday!)
						
						privateInformation.birthDay = birthdayDate
						employee.privateInformation = privateInformation
						
						employee.company = company
					})
					
					do {
						try privateContext.save()
						try privateContext.parent?.save()
					}
					catch let err {
						print("Failed to save companies", err.localizedDescription)
					}
					
				})
				
				
				
			}
			catch let err {
				print("Failed to serealize JSON", err.localizedDescription)
			}
		}.resume()
	}
	
	
}




struct CompanyNet: Decodable {
	
	let name		:String?
	let photoUrl	:String?
	let founded		:String?
	let employees	:[EmployeeNet]?
	
}

struct EmployeeNet: Decodable {
	
	let name		:String?
	let birthday	:String?
	let type		:String?
}
















