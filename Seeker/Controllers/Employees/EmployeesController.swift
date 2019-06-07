//
//  EmployeesController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import RealmSwift

class EmployeesController: UIViewController {
	
	public var company: RealmCompany? {
		didSet {
			if company!.imageData == nil {
				subscribe(to: company!) { self.didSubscribedCompanyChange() }
			}
		}
	}
	private var employeesArr = [[RealmEmployee]]()
	private let cellID = "cellID"
	public lazy var tableView: UITableView = {
		let table = UITableView()
		table.translatesAutoresizingMaskIntoConstraints = false
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
		table.backgroundColor = Props.green1
		table.delegate = self
		table.dataSource = self
		table.backgroundColor = Props.darkGreen
		table.separatorColor = .white
		table.tableFooterView = UIView()
		return table
	}()
	let picture: UIImageView = {
		let pic = UIImageView()
		pic.translatesAutoresizingMaskIntoConstraints = false
		pic.contentMode = .scaleAspectFit
		pic.backgroundColor = .white
		return pic
	}()
	
	private var realm: Realm {
		return try! realmInstance()
	}
	private var subscription: NotificationToken?
	
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = company?.name
		if let imgData = company?.imageData {
			picture.image = UIImage(data: imgData)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Props.darkGreen
		insertTable()
		fetchEmployees()
		setupButtonsInNavBar(selector: #selector(onPlusClick))
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		unsubscribe()
	}
	
	private func insertTable(){
		view.addSubview(tableView)
		tableView.tableHeaderView = picture

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			picture.centerXAnchor.constraint(equalTo: picture.superview!.centerXAnchor),
			picture.leadingAnchor.constraint(equalTo: picture.superview!.leadingAnchor),
			picture.trailingAnchor.constraint(equalTo: picture.superview!.trailingAnchor),
//			picture.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
			picture.heightAnchor.constraint(equalToConstant: 150),
		])
	}

	
	// fix strange glich with tableHeaderView
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// Dynamic sizing for the header view
		guard let headerView = tableView.tableHeaderView else { return }
		
		let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
		var headerFrame = headerView.frame
		
		// If we don't have this check, viewDidLayoutSubviews()
		// will get repeatedly, causing the app to hang
		if height != headerFrame.size.height {
			headerFrame.size.height = height
			headerView.frame = headerFrame
			tableView.tableHeaderView = headerView
		}
	}
	
	
	@objc private func onPlusClick(){
		let addEmployeeController = AddEmployeeController()
		addEmployeeController.delegate = self
		addEmployeeController.company = company
		let navcontroller = UINavigationController(rootViewController: addEmployeeController)
		present(navcontroller, animated: true, completion: nil)
	}
	
	
	private func fetchEmployees(){
		guard let employeesForCurrentCompany = company?.employees else { return }
		employeesArr.removeAll()
		// executive, managers, staff
		for (index, _) in AddEmployeeController.segmentVars.enumerated() {
			employeesArr.append(employeesForCurrentCompany.filter{$0.type == AddEmployeeController.segmentVars[index]})
		}
	}
	

	// if company picture still blank
	private func subscribe(to company: RealmCompany, callback: (() -> Void)? = nil) {
		guard subscription == nil else { return }
		subscription = company.observe {
			changes in
			print("Changes with RealmObject has occurred")
			callback?()
		}
	}
	private func unsubscribe() {
		subscription?.invalidate()
		subscription = nil
	}

	
	// when picture downloading has finished
	private func didSubscribedCompanyChange(){
		// renew logo
		if let imgData = company?.imageData {
			picture.image = UIImage(data: imgData)
		}
	}
	
}




extension EmployeesController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employeesArr[section].count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return employeesArr.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = UILabelWithEdges()
		label.textInsets.left = 15
		label.text = AddEmployeeController.tabNames[section]
		label.textColor = Props.green1
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.backgroundColor = Props.blue4
		return label
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let employee = employeesArr[indexPath.section][indexPath.row]
		cell.textLabel?.text = employee.name
		cell.textLabel?.textColor = .white
		cell.backgroundColor = Props.green3
		if let birthday = employee.privateInformation?.birthDay {
			let str2 = "  #  \(SUtils.convertDate(founded: birthday))"
			cell.textLabel?.attributedText = SUtils.twoColorString(strings: (employee.name!, str2), colors: (UIColor.white, Props.green4))
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}



extension EmployeesController: AddEmployeeDelegate {
	func updateEmployes(employee: RealmEmployee) {
		guard let section = AddEmployeeController.segmentVars.index(of: employee.type!) else { return }
		let row = employeesArr[section].count
		employeesArr[section].append(employee)
		let insertionIndexPath = IndexPath(row: row, section: section)
		tableView.insertRows(at: [insertionIndexPath], with: .top)
	}
}

































