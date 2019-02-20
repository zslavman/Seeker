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
	private var realm: Realm {
		return try! realmInstance()
	}

	
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
		companiesArr?.realm?.refresh() // fix empty database after get objects from NetworkService client
		companiesArr = realm.objects(RealmCompany.self)
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
		if refreshControl == nil {
			return
		}
		DispatchQueue.main.async {
			self.refreshControl?.endRefreshing()
			self.refreshControl?.removeTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
			self.refreshControl = nil // do it on main thread ONLY (else you will have big top space after "pull-to-refresh")
		}
	}
	
	// pull to refresh
	@objc internal func onRefresh(){
//		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 2) {
//			DispatchQueue.main.async {
//				self.refreshControl?.endRefreshing()
//			}
//		}
		refreshingNow = true
		NetworkService.shared.downloadCompaniesFromServer(callback: {
			DispatchQueue.main.async {
				self.fetchRealmData()
				self.refreshingNow = false
				self.removeRefreshControl()
				self.animateTableWithSections()
				print(#function)
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
		try! realm.write {
			let count = tableView.numberOfRows(inSection: 0)
			let rows = (0..<count).map { IndexPath(row: $0, section: 0)}
			realm.deleteAll()
			tableView.deleteRows(at: rows, with: .right)
		}
	}
	
	@objc private func onPlusClick(){
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
		try! realm.write {
			companiesArr.realm?.add(realmCompanyObject)
			tableView.insertRows(at: [indexPath], with: .top)
		}
	}
	
	func didEditCompany() {
		if let index = companiesArr.index(of: companyToUpdate) {
			let indexPath = IndexPath(row: index, section: 0)
			DispatchQueue.main.async {
				self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
			}
		}
		
	}
}

















