//
//  EmployeesController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class EmployeesController: UITableViewController {
	
	
	public var company: CompanyModel?
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.backgroundColor = Props.green1
		
		setupButtonsInNavBar(selector: #selector(onPlusClick))
	}

	
	@objc private func onPlusClick(){
		let navcontroller = UINavigationController(rootViewController: AddEmployeeController())
		present(navcontroller, animated: true, completion: nil)
	}
	
	
	
	
}




























