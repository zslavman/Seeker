//
//  AddEmployee.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

protocol AddEmployeeDelegate:class {
	func updateEmployes(employee: Employee)
}


class AddEmployeeController: UIViewController {

	public weak var delegate:AddEmployeeDelegate?
	public var company: CompanyModel?
	
	private let nameLabel: UILabelWithEdges = {
		let label = UILabelWithEdges()
		label.text = "Имя"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textInsets.left = 15
		return label
	}()
	private let nameInputField: UITextField = {
		let label = UITextField()
		label.placeholder = "Введите имя"
		label.layer.cornerRadius = 14
		label.clipsToBounds = true
		label.layer.borderWidth = 1
		label.layer.borderColor = Props.green4.cgColor
		label.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: label.frame.height))
		label.leftViewMode = .always
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = Props.darkGreen
		navigationItem.title = "Create Employee"
		setupCancelButton()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Сохранить",
			style: .plain,
			target: self,
			action: #selector(onSaveClick)
		)
		
		createBackground()
		
		setupUI()
	}
	

	private func setupUI(){
		view.addSubview(nameLabel)
		view.addSubview(nameInputField)
		
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			nameInputField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
			nameInputField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
			nameInputField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
		])
	}
	
	
	@objc private func onSaveClick(){
		guard let name = Calc.checkBeforeUse(field: nameInputField)
			else {
				let alertController = Calc.createAlert(message: "Введите имя", completion: nil)
				present(alertController, animated: true, completion: nil)
				nameInputField.text = ""
				return
		}
		guard let company = self.company else { return }
		
		let tuple = CoreDataManager.shared.createEmployee(employeeName: name, company: company)
		if tuple.1 == nil {
			dismiss(animated: true, completion: {
				self.delegate?.updateEmployes(employee: tuple.0!)
			})
		}
	}
	
	

}














