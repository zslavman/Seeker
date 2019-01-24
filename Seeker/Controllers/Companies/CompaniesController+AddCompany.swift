//
//  CompaniesController+AddCompany.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

// выносим методы, которые бубдут исполнятся из другого класса посредством делегирования
extension CompaniesController: AddCompanyProtocol{
	
	func addCompany(company: CompanyModel) {
		companiesArr.append(company)
		let newIndexPath = IndexPath(row: companiesArr.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .top)
	}
	
	func didEditCompany(company: CompanyModel) {
		
		// find out company wich did change in array
		let row = companiesArr.index(of: company)!
		
		let reloadIndeexPath = IndexPath(row: row, section: 0)
		tableView.reloadRows(at: [reloadIndeexPath], with: .fade)
		
	}
}
