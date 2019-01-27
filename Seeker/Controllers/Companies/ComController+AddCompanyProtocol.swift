//
//  CompaniesController+AddCompany.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData


extension CompaniesController: AddCompanyProtocol{
	
	func addCompany(name: String, fDate: Date, imgData: Data?) {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		//let newCompany = NSEntityDescription.insertNewObject(forEntityName: ENT.CompanyModel, into: context) as! CompanyModel
		let newCompany = CompanyModel(context: context)
		
		newCompany.name = name
		newCompany.founded = fDate
		newCompany.imageData = imgData
		
		CoreDataManager.shared.saveContext()
	}
	
	/// save core data after editing company (basically, this method no longer need)
	func didEditCompany(company: CompanyModel) {
		CoreDataManager.shared.saveContext()
	}
	
	
	
//	func addCompany(company: CompanyModel) {
//		companiesArr.append(company)
//		let newIndexPath = IndexPath(row: companiesArr.count - 1, section: 0)
//		tableView.insertRows(at: [newIndexPath], with: .top)
//	}
//
//	func didEditCompany(company: CompanyModel) {
//		// find out company wich did change in array
//		let row = companiesArr.index(of: company)!
//		let reloadIndeexPath = IndexPath(row: row, section: 0)
//		tableView.reloadRows(at: [reloadIndeexPath], with: .fade)
//	}
	
}




















