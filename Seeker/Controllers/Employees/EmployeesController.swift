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
	
	
	public var company: RealmCompany?
	private var employeesArr = [[RealmEmployee]]()
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
		//addEmployeeController.company = company
		let navcontroller = UINavigationController(rootViewController: addEmployeeController)
		present(navcontroller, animated: true, completion: nil)
	}
	
	
	
	private func fetchEmployees(){
		//guard let employeesForCurrentCompany = company?.employees?.allObjects as? [Employee] else { return }
		employeesArr.removeAll()
		
		// executive, managers, staff
//		for (index, _) in AddEmployeeController.segmentVars.enumerated() {
//			employeesArr.append(employeesForCurrentCompany.filter{$0.type == AddEmployeeController.segmentVars[index]})
//		}
	}
	
	
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employeesArr[section].count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return employeesArr.count
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabelWithEdges()
		label.textInsets.left = 15
		
		label.text = AddEmployeeController.tabNames[section]
		
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
		
		let employee = employeesArr[indexPath.section][indexPath.row]
		
		cell.textLabel?.text = employee.name
		cell.textLabel?.textColor = .white
		cell.backgroundColor = Props.green3
		
//		if let birthday = employee.privateInformation?.birthDay {
//			let str2 = "  #  \(Calc.convertDate(founded: birthday))"
//			cell.textLabel?.attributedText = Calc.twoColorString(strings: (employee.name!, str2), colors: (UIColor.white, Props.green4))
//		}
		return cell
	}
	
}



extension EmployeesController: AddEmployeeDelegate {
	
	func updateEmployes(employee: Employee) {
		guard let section = AddEmployeeController.segmentVars.index(of: employee.type!) else { return }
		let row = employeesArr[section].count
		
//		employeesArr[section].append(employee)
		
		let insertionIndexPath = IndexPath(row: row, section: section)
		tableView.insertRows(at: [insertionIndexPath], with: .top)
	}
}

































