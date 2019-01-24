//
//  EmployeesController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
	
	
	public var company: CompanyModel?
	private var employeesArr = [Employee]()
	private let cellID = "cellID"
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchEmployees()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		tableView.backgroundColor = Props.green1
		
		setupButtonsInNavBar(selector: #selector(onPlusClick))
	}

	
	@objc private func onPlusClick(){
		let addEmployeeController = AddEmployeeController()
		addEmployeeController.delegate = self
		addEmployeeController.company = company
		let navcontroller = UINavigationController(rootViewController: addEmployeeController)
		present(navcontroller, animated: true, completion: nil)
	}
	
	
	
	private func fetchEmployees(){
		guard let employeesForCurrentCompany = company?.employees?.allObjects as? [Employee] else { return }
		employeesArr = employeesForCurrentCompany
		
//		let context = CoreDataManager.shared.persistentContainer.viewContext
//		let request = NSFetchRequest<Employee>(entityName: ENT.Employee)
//		do {
//			employeesArr = try context.fetch(request)
//		}
//		catch let err {
//			print("Failed to fetch employees: \(err.localizedDescription)")
//		}
		
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employeesArr.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let employee = employeesArr[indexPath.row]
		
		cell.textLabel?.text = employee.name
		cell.backgroundColor = Props.green3
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		
		if let taxId = employee.privateInformation?.taxId {
			cell.textLabel?.text?.append("  \(taxId)")
		}
		
		return cell
	}
	
}



extension EmployeesController: AddEmployeeDelegate {
	
	func updateEmployes(employee: Employee) {
		employeesArr.append(employee)
		let newIndexPath = IndexPath(row: employeesArr.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .top)
	}
}

































