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
		return 60
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "Нет компаний для отображения"
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if companiesArr.count == 0 {
			navigationItem.leftBarButtonItem?.tintColor = .clear
			addRefreshControl()
			return 150
		}
		navigationItem.leftBarButtonItem?.tintColor = .white
		removeRefreshControl()
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
		
		// cell highlight color
		let selectionColor = UIView()
		selectionColor.backgroundColor = Props.blue4
		cell.selectedBackgroundView = selectionColor
		let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(sender:)))
		longGesture.minimumPressDuration = 0.7
		cell.addGestureRecognizer(longGesture)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить", handler: {
			(_, indexPath2) in
			self.delCompany(indexPath: indexPath)
		})
		let editAction = UITableViewRowAction(style: .normal, title: "Редакт", handler: {
			(_, indexPath2) in
			self.edit(indexPath: indexPath)
		})
		editAction.backgroundColor = #colorLiteral(red: 0.8925628481, green: 0.6441024697, blue: 0.1277349157, alpha: 1)
		return [deleteAction, editAction]
	}
	
	
	@objc private func onLongPress(sender: UIGestureRecognizer){
		let location = sender.location(in: self.tableView)
		guard let indexPath = self.tableView.indexPathForRow(at: location) else { return }
		guard sender.state == .began else { return }
		
		let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let editAction = UIAlertAction(title: "Редактировать", style: .default) {
			_ in
			self.edit(indexPath: indexPath)
		}
		editAction.actionImage = UIImage(named: "icon_edit")
		actionSheetVC.addAction(editAction)
		let delAction = UIAlertAction(title: "Удалить", style: .destructive) {
			_ in
			self.delCompany(indexPath: indexPath)
		}
		delAction.actionImage = UIImage(named: "icon_del")
		actionSheetVC.addAction(delAction)
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
		actionSheetVC.addAction(cancelAction)
		
		// for iPad only
		if (UIDevice.current.userInterfaceIdiom == .pad){
			if let popoverController = actionSheetVC.popoverPresentationController {
				popoverController.sourceView = self.view
				popoverController.sourceRect = CGRect(x: location.x, y: location.y, width: 0, height: 0)
				//popoverController.permittedArrowDirections = [] // remove menu arrow
			}
		}
		present(actionSheetVC, animated: true)
	}
	
	
}














