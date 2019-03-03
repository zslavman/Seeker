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

	
	public func downloadCompaniesFromServer(callback: (() -> Void)?){
		guard let jsonURL = URL(string: json) else { return }
		URLSession.shared.dataTask(with: jsonURL) {
			(data, response, error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else { return }
			// let str = String(data: data, encoding: String.Encoding.utf8)
			do {
				let someData = try JSONDecoder().decode([CompanyNet].self, from: data)
				self.parseContext(someData: someData)
				callback?()
			}
			catch let err {
				print("Failed to serealize JSON", err.localizedDescription)
			}
		}.resume()
	}
	
	
	private func parseContext(someData:[CompanyNet]){
		var ralmObjects = [RealmCompany]()
		let realm = try! realmInstance()
		// save each company
		someData.forEach({
			(com) in
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd/MM/yyyy"
			let foundedDate = dateFormatter.date(from: com.founded!)
		
			let realmCompany = RealmCompany(founded: foundedDate, imageData: nil, imageUrl: com.photoUrl, name: com.name)
			
			// save each employees of company
			com.employees?.forEach({
				(empl) in
				// create new Employee
				let newRealmEmpl = RealmEmployee(name: empl.name, type: empl.type)
				
				// create new nested entity newRealmEmpl.privateInformation
				let birthdayDate = dateFormatter.date(from: empl.birthday!)
				let realmInf = RealmPrivateInformation(birthDay: birthdayDate)
				newRealmEmpl.privateInformation = realmInf

				realmCompany.employees.append(newRealmEmpl)
			})
			ralmObjects.append(realmCompany)
		})
//		DispatchQueue.main.async {
			print("ralmObjects.count = \(ralmObjects.count)")
			try! realm.write {
				realm.add(ralmObjects)
			}
//		}
	}
	
	
}


struct CompanyNet: Decodable {
	let name		:String
	let photoUrl	:String?
	let founded		:String?
	let employees	:[EmployeeNet]?
}


struct EmployeeNet: Decodable {
	let name		:String?
	let birthday	:String?
	let type		:String?
}
















