//
//  ViewController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {

	
	internal let cellID = "cellID"
	internal var companiesArr = [CompanyModel]()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		companiesArr = CoreDataManager.shared.fetchCompanies()
		
		navigationItem.title = "Компании"
		
		setupButtonsInNavBar(selector: #selector(onPlusClick))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Удалить всё",
			style: .plain,
			target: self,
			action: #selector(onResetClick)
		)
		setupTableStyle()
	}

	
	@objc private func onResetClick(){
		guard companiesArr.count > 0 else { return }
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: CompanyModel.fetchRequest())
		
		do {
			try context.execute(batchDeleteRequest)
			
			var indexPathToRemove = [IndexPath]()
			
			for (index, _) in companiesArr.enumerated() {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathToRemove.append(indexPath)
			}
			companiesArr.removeAll()
			tableView.deleteRows(at: indexPathToRemove, with: .right)
		}
		catch let err {
			print("Failed to delete data: \(err.localizedDescription)")
		}
	}
	
	
	private func setupTableStyle(){
		tableView.backgroundColor = Props.darkGreen
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
	}
	
	
	@objc private func onPlusClick(){

		let addCompanyController = AddCompanyController()
		let navController = UINavigationController(rootViewController: addCompanyController)
		
		addCompanyController.companiesControllerDelegate = self
		present(navController, animated: true, completion: nil)
	}

	
	internal func onEditAction(action: UITableViewRowAction, indexPath:IndexPath){
		
		let editCompanyController = AddCompanyController()
		editCompanyController.companiesControllerDelegate = self
		editCompanyController.company = companiesArr[indexPath.row]
		let navController = UINavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil)
	}
	
}

























