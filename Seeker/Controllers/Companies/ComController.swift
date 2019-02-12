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
	internal var companyToUpdate: RealmCompany!// every time when you will edit company, you should save it here
	private var refreshingNow: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()
		extendedLayoutIncludesOpaqueBars = true // fix refreshControl glich
		fetchRealmData()
		setupButtonsInNavBar(selector: #selector(onPlusClick))
		navigationController?.view.backgroundColor = Props.green3 // fix black artifact
		navigationItem.title = "Компании"
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Удалить все",
			style: .plain,
			target: self,
			action: #selector(onRemoveAll)
		)
		setupTableStyle()
	}
	
	
	private func fetchRealmData(){
		let realm = try! realmInstance()
		let tempArr = realm.objects(RealmCompany.self)
		print("tempArr.count = \(tempArr.count)")
		companiesArr = tempArr
	}
	
	
	internal func addRefreshControl(){
		if refreshControl == nil {
			refreshControl = UIRefreshControl()
			refreshControl!.tintColor = .white
		}
		if !refreshingNow {
			refreshControl!.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
		}
	}
	
	internal func removeRefreshControl(){
		refreshControl?.endRefreshing()
		refreshControl?.removeTarget(self, action: #selector(onRefresh), for: .valueChanged)
		//refreshControl?.removeFromSuperview()
		//refreshControl = nil
	}
	
	// pull to refresh
	@objc internal func onRefresh(){
		refreshingNow = true
		NetworkService.shared.downloadCompaniesFromServer(callback: {
			DispatchQueue.main.async {
				self.fetchRealmData()
				self.refreshingNow = false
				self.removeRefreshControl()
				self.animateTableWithSections()
			}
		})
	}
	
	
	private func setupTableStyle(){
		tableView.backgroundColor = Props.darkGreen
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
	}
	
	
	@objc private func onRemoveAll(){
		let realm = try! realmInstance()
		try! realm.write {
			let count = tableView.numberOfRows(inSection: 0)
			let rows = (0..<count).map { IndexPath(row: $0, section: 0)}
//			companiesArr.realm?.deleteAll()
			realm.deleteAll()
			tableView.deleteRows(at: rows, with: .right)
		}
	}
	
	
	@objc private func onPlusClick(){
		onRefresh() // working fine allways!!! problem with refreshControl???
		return
		let addCompanyController = AddCompanyController()
		let navController = UINavigationController(rootViewController: addCompanyController)
		
		addCompanyController.companiesControllerDelegate = self
		present(navController, animated: true, completion: nil)
	}

	
	internal func onEditAction(action: UITableViewRowAction, indexPath:IndexPath){
		let editCompanyController = AddCompanyController()
		editCompanyController.companiesControllerDelegate = self
		editCompanyController.company = companiesArr[indexPath.row]
		companyToUpdate = companiesArr[indexPath.row]
		let navController = UINavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil)
	}
	
	private func animateTableWithSections(){
		tableView.reloadData()
		let range = NSMakeRange(0, tableView.numberOfSections)
		let sections = NSIndexSet(indexesIn: range)
		tableView.reloadSections(sections as IndexSet, with: .bottom)
	}
	
}



extension CompaniesController: AddCompanyProtocol{
	func addCompany(company: CompanyEntity) {
		let realmCompanyObject = RealmCompany(entity: company)
		let indexPath = IndexPath(row: companiesArr.count, section: 0)
		let realm = try! realmInstance()
		try! realm.write {
			companiesArr.realm?.add(realmCompanyObject)
			tableView.insertRows(at: [indexPath], with: .top)
		}
	}
	
	func didEditCompany() {
		if let index = companiesArr.index(of: companyToUpdate) {
			let indexPath = IndexPath(row: index, section: 0)
			DispatchQueue.main.async {
				self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			}
		}
		
	}
}

















