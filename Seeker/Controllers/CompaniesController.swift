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

	
	private let cellID = "cellID"
	private var companiesArr = [CompanyModel]()
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchCompanies()
		
		navigationItem.title = "Компании"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "plus_bttn"),
			style: .plain,
			target: self,
			action: #selector(onPlusClick)
		)
		
		setupTableStyle()
	}


	
	
	
	private func fetchCompanies(){
		
		let context = CoreDataManager.shared.persistentContainer.viewContext

		let fetchRequest = NSFetchRequest<CompanyModel>(entityName: "CompanyModel")
		do {
			companiesArr = try context.fetch(fetchRequest)
			tableView.reloadData()
		}
		catch let error {
			print("Failed to load data: \(error.localizedDescription)")
		}
		
	}
	
	
	
	
	private func setupTableStyle(){
		tableView.backgroundColor = Props.darkGreen
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
	}
	
	
	
	@objc private func onPlusClick(){

		let addCompanyController = AddCompanyController()
		let navController = UINavigationController(rootViewController: addCompanyController)
		
		addCompanyController.companiesControllerDelegate = self
		present(navController, animated: true, completion: nil)
	}
	
	
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companiesArr.count
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerViev = UIView()
		headerViev.backgroundColor = Props.blue4
		
		return headerViev
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		
		cell.backgroundColor = Props.green3
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		cell.textLabel?.text = companiesArr[indexPath.row].name
		
		return cell
	}
	
	
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
			(_, indexPath) in
			let companyToDelete = self.companiesArr[indexPath.row]
			
			//del from table source
			self.companiesArr.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .left)
			
			// del from Core Data
			let context = CoreDataManager.shared.persistentContainer.viewContext
			context.delete(companyToDelete)
			do {
				try context.save()
			}
			catch let saveErr {
				print(saveErr.localizedDescription)
			}
		}
		
		
		let editAction = UITableViewRowAction(style: .normal, title: "Редакт", handler: onEditAction)
		
		return [deleteAction, editAction]
	}
	
	
	
	
	
	private func onEditAction(action: UITableViewRowAction, indexPath:IndexPath){
		
		let editCompanyController = AddCompanyController()
		editCompanyController.company = companiesArr[indexPath.row]
		let navController = UINavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil)
	}
	
	

}


// выносим методы, которые бубдут исполнятся из другого класса посредством делегирования
extension CompaniesController: AddCompanyProtocol{
	
	func addCompany(company: CompanyModel) {
		companiesArr.append(company)
		let newIndexPath = IndexPath(row: companiesArr.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .top)
	}
}


























