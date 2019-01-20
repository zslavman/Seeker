//
//  ViewController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class CompaniesController: UITableViewController {

	
	private let cellID = "cellID"
	private var companiesArr = [
		CompanyModel(name: "Эники", founded: Date()),
		CompanyModel(name: "Левисы", founded: Date()),
		CompanyModel(name: "Гучи", founded: Date()),
		CompanyModel(name: "ПломБы", founded: Date())
	]
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Компании"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "plus_bttn"),
			style: .plain,
			target: self,
			action: #selector(onPlusClick)
		)
		
		setupTableStyle()
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

}


// выносим методы, которые бубдут исполнятся из другого класса посредством делегирования
extension CompaniesController: AddCompanyProtocol{
	
	func addCompany(company: CompanyModel) {
		companiesArr.append(company)
		let newIndexPath = IndexPath(row: companiesArr.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .top)
	}
}


























