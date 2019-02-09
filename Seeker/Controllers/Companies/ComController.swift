//
//  ViewController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import RealmSwift

class CompaniesController: UITableViewController {

	internal let cellID = "cellID"
	internal var companiesArr: Results<RealmCompany>!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		//companiesArr =
		
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
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: CompanyModel.fetchRequest())
		batchDeleteRequest.resultType = .resultTypeObjectIDs
		
		do {
			let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
			// Batch updates work directly on the persistent store file instead of going through the managed
			// object context, so the context doesn't know about them. When you delete the objects by fetching
			// and then deleting, you're working through the context, so it knows about the changes you're
			// making (in fact it's performing those changes for you)
			
			// update context version 1
			context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // without this you get an error "Cocoa error 133020"
			let objectIDArray = batchDeleteResult.result as! [NSManagedObjectID]
			let changes = [NSDeletedObjectsKey: objectIDArray]
			NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
			
			// update context version 2 (without table animation)
			//				 context.reset()
			//				 try fetchedResultsController.performFetch()
			//				 tableView.reloadData()
		}
		catch let err {
			print("Failed to delete data: \(err.localizedDescription)")
		}
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


















