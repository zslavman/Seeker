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
	
	private var shortNameEmployees = [Employee]()
	private var longNameEmployees = [Employee]()
	
	
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
		
		shortNameEmployees = employeesForCurrentCompany.filter{($0.name?.count)! <= 6}
		longNameEmployees = employeesForCurrentCompany.filter{($0.name?.count)! > 6}
		
		//employeesArr = employeesForCurrentCompany
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return shortNameEmployees.count
		}
		return longNameEmployees.count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabelWithEdges()
		label.textInsets.left = 15
		if section == 0 {
			label.text = "shortNameEmployees"
		}
		else {
			label.text = "longNameEmployees"
		}
		label.textColor = Props.green1
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.backgroundColor = Props.blue4
		
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		
		let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
		
		cell.textLabel?.text = employee.name
		cell.backgroundColor = Props.green3
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		
		if let birthday = employee.privateInformation?.birthDay {
			cell.textLabel?.text?.append("  #  \(Calc.convertDate(founded: birthday))")
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

































