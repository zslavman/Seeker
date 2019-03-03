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
	internal var companiesArr = [RealmCompany]()
	internal var companyToUpdate: RealmCompany!// every time when you will edit company, you should save it here
	private var refreshingNow: Bool = false
	private var realm: Realm {
		return try! realmInstance()
	}
	private var subscription: NotificationToken?

	
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
		companiesArr = fetchCompanies()
		//subscribe(to: "Intel", callback: nil)
	}
	
	private func fetchCompanies() -> [RealmCompany] {
		realm.refresh()
		return realm.objects(RealmCompany.self).sorted { $0.name.lowercased() < $1.name.lowercased() }
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
			// need kill because we won't add company on second pull-down swipe
			self.refreshControl = nil // do it on main thread ONLY (else you will have big top space after "pull-to-refresh")
		}
	}
	
	// pull to refresh
	@objc internal func onRefresh(){
		// if problems with network occurred
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + 2) {
			DispatchQueue.main.async {
				self.refreshControl?.endRefreshing()
				self.refreshingNow = false
			}
		}
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
		try! realm.write {
			let count = tableView.numberOfRows(inSection: 0)
			let rows = (0..<count).map { IndexPath(row: $0, section: 0)}
			realm.deleteAll()
			companiesArr.removeAll()
			tableView.deleteRows(at: rows, with: .right)
		}
	}
	
	@objc private func onPlusClick(){
		let addCompanyController = AddCompanyController()
		let navController = UINavigationController(rootViewController: addCompanyController)
		addCompanyController.companiesControllerDelegate = self
		present(navController, animated: true, completion: nil)
	}

	internal func onEditAction(action: UITableViewRowAction, indexPath: IndexPath){
		edit(indexPath: indexPath)
	}
	
	internal func edit(indexPath: IndexPath){
		let editCompanyController = AddCompanyController()
		editCompanyController.companiesControllerDelegate = self
		editCompanyController.company = companiesArr[indexPath.row]
		companyToUpdate = companiesArr[indexPath.row]
		let navController = UINavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil)
	}
	
	
	internal func delCompany(indexPath: IndexPath){
		let willRemoved = companiesArr[indexPath.row]
		try! realm.write {
			if let object = realm.objects(RealmCompany.self).filter("id == %@", willRemoved.id).first {
				realm.delete(object)
			}
			companiesArr.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
		}
	}
	
	private func animateTableWithSections(){
		tableView.reloadData()
		let range = NSMakeRange(0, tableView.numberOfSections)
		let sections = NSIndexSet(indexesIn: range)
		tableView.reloadSections(sections as IndexSet, with: .bottom)
	}
	
	
	//------------------------------------------------------
	// test realm opportunities
	
	// subscribe on changes in any realm item of all items
	private func subscribe(callback: @escaping ([RealmCompany]) -> Void) {
		let results = realm.objects(RealmCompany.self)
		subscription = results.observe {
			changes in
			let resultsArray = Array(results)
			print("Changes = \(changes)")
			callback(resultsArray)
		}
	}
	
	private func subscribe(to itemName: String, callback: ((RealmCompany) -> ())?) {
		let item = realm.objects(RealmCompany.self).filter("name == %@", itemName)
		subscription = item.observe {
			changes in
			print("Changes = \(changes)")
			callback?(item.first!)
		}
	}
	
	private func unsubscribe() {
		subscription?.invalidate()
		subscription = nil
	}
	
	deinit {
		unsubscribe()
	}
	
}



extension CompaniesController: AddCompanyProtocol{
	func addCompany(company: CompanyEntity) {
		let realmCompanyObject = RealmCompany(entity: company)
		// define place for a company
		var testArr = companiesArr.map{$0.name}
		testArr.append(realmCompanyObject.name)
		testArr.sort{$0.localizedCaseInsensitiveCompare($1) == .orderedAscending}
		guard let index = testArr.firstIndex(of: realmCompanyObject.name) else { return }
		
		let indexPath = IndexPath(row: index, section: 0)
		try! realm.write {
			companiesArr.insert(realmCompanyObject, at: index)
			realm.add(realmCompanyObject)
			DispatchQueue.main.async {
				self.tableView.insertRows(at: [indexPath], with: .top)
			}
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
	
	func returnAllCompanies() -> [RealmCompany] {
		return companiesArr
	}
}


