//
//  CompaniesController+UITableView.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

extension CompaniesController {
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companiesArr.count
	}
	
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerViev = UIView()
		headerViev.backgroundColor = Props.blue4
		
		return headerViev
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Нет доступных компаний..."
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if companiesArr.count == 0 {
			navigationItem.leftBarButtonItem?.tintColor = .clear
			return 150
		}
		navigationItem.leftBarButtonItem?.tintColor = .white
		return 0
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let employeesController = EmployeesController()
		employeesController.company = companiesArr[indexPath.row]
		navigationController?.pushViewController(employeesController, animated: true)
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
		cell.company = companiesArr[indexPath.row]
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
		editAction.backgroundColor = #colorLiteral(red: 0.8925628481, green: 0.6441024697, blue: 0.1277349157, alpha: 1)
		
		return [deleteAction, editAction]
	}
	
	
	
}


