//
//  CompaniesAutoUpdateController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 25.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData


class CompaniesAutoUpdateController: UITableViewController {
	
	private lazy var fetchedResultsController: NSFetchedResultsController<CompanyModel> = {
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "name", ascending: true)
		]
		
		let frc = NSFetchedResultsController(
			fetchRequest		: request,
			managedObjectContext: context,
			sectionNameKeyPath	: "name",
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
	private var cell_ID = "cell_ID"

	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Компании"
		
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(
				title: "Добавить",
				style: .plain,
				target: self,
				action: #selector(onAdd)
			),
			UIBarButtonItem(
				title: "Удалить",
				style: .plain,
				target: self,
				action: #selector(onDell)
			),
		]
		
		tableView.backgroundColor = Props.darkGreen
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cell_ID)
		
		let refreshControl = UIRefreshControl()
		refreshControl.tintColor = .white
		refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		self.refreshControl = refreshControl
	}
	
	
	
	@objc private func onRefresh(){
		NetworkService.shared.downloadCompaniesFromServer()
		refreshControl?.endRefreshing()
	}
	
	
	
	@objc private func onAdd(){
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = CompanyModel(context: context)
		company.name = "Goordi"
		try? context.save()
	}
	
	
	@objc private func onDell(){
		let request: NSFetchRequest<CompanyModel> = CompanyModel.fetchRequest()
		//request.predicate = NSPredicate(format: "name CONTAINS %@", "Goordi") // case sensetive
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let companiesToDelete = try? context.fetch(request)
		
		companiesToDelete?.forEach { (com) in
			context.delete(com)
		}
		
		try? context.save()
	}
	
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController.sections![section].numberOfObjects
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabelWithEdges()
		label.text = fetchedResultsController.sectionIndexTitles[section]
		label.textInsets.left = 15
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.backgroundColor = Props.blue4
		label.textColor = Props.green1
		
		return label
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cell_ID, for: indexPath) as! CompanyCell
		cell.company = fetchedResultsController.object(at: indexPath)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let employeesController = EmployeesController()
		employeesController.company = fetchedResultsController.object(at: indexPath)
		navigationController?.pushViewController(employeesController, animated: true)
	}

}




extension CompaniesAutoUpdateController: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
		case .delete:
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		case .move:
			break
		case .update:
			break
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	
	// titles for sections
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return sectionName
	}
	
}
























