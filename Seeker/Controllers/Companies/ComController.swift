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

	
	internal lazy var fetchedResultsController: NSFetchedResultsController<CompanyModel> = {
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "name", ascending: true)
		]
		
		let frc = NSFetchedResultsController(
			fetchRequest		: request,
			managedObjectContext: context,
			//sectionNameKeyPath: "name",
			sectionNameKeyPath	: nil,
			cacheName			: nil
		)
		frc.delegate = self
		
		do {
			try frc.performFetch()
		} catch let err {
			print("Failed to performFetch", err.localizedDescription)
		}
		
		return frc
	}()
	internal let cellID = "cellID"
	//internal var companiesArr = [CompanyModel]()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//companiesArr = CoreDataManager.shared.fetchCompanies()
		
		setupButtonsInNavBar(selector: #selector(onPlusClick))
		
		// Fixing black artifact
		navigationController?.view.backgroundColor = Props.green3
		
		navigationItem.title = "Компании"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Удалить все",
			style: .plain,
			target: self,
			action: #selector(onResetClick)
		)
		setupTableStyle()
	}
	
	
	internal func addRefreshControl(){
		if refreshControl != nil {
			return
		}
		let customRefreshControl = UIRefreshControl()
		customRefreshControl.tintColor = .white
		customRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		self.refreshControl = customRefreshControl
	}
	
	
	@objc internal func onRefresh(){
		NetworkService.shared.downloadCompaniesFromServer()
		refreshControl?.endRefreshing()
	}
	
	
	private func setupTableStyle(){
		tableView.backgroundColor = Props.darkGreen
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
	}
	
	
	@objc private func onResetClick(){
		let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
		//request.predicate = NSPredicate(format: "name CONTAINS %@", "Goordi") // case sensetive filter
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let companiesToDelete = try? context.fetch(request)
		
		companiesToDelete?.forEach { (com) in
			context.delete(com)
		}
		try? context.save()
	}
	
	
	
//	@objc private func onResetClick(){
//		guard companiesArr.count > 0 else { return }
//
//		let context = CoreDataManager.shared.persistentContainer.viewContext
//		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: CompanyModel.fetchRequest())
//
//		do {
//			try context.execute(batchDeleteRequest)
//
//			var indexPathToRemove = [IndexPath]()
//
//			for (index, _) in companiesArr.enumerated() {
//				let indexPath = IndexPath(row: index, section: 0)
//				indexPathToRemove.append(indexPath)
//			}
//			companiesArr.removeAll()
//			tableView.deleteRows(at: indexPathToRemove, with: .right)
//		}
//		catch let err {
//			print("Failed to delete data: \(err.localizedDescription)")
//		}
//	}
	
	
	
	@objc private func onPlusClick(){
		let addCompanyController = AddCompanyController()
		let navController = UINavigationController(rootViewController: addCompanyController)
		
		addCompanyController.companiesControllerDelegate = self
		present(navController, animated: true, completion: nil)
	}

	
	internal func onEditAction(action: UITableViewRowAction, indexPath:IndexPath){
		let editCompanyController = AddCompanyController()
		editCompanyController.companiesControllerDelegate = self
		editCompanyController.company = fetchedResultsController.object(at: indexPath)
		let navController = UINavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil)
	}
	
}


















