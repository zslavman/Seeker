//
//  AddCompanyController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import CoreData


protocol AddCompanyProtocol:class {
	func addCompany(company: CompanyModel)
}


class AddCompanyController: UIViewController {

	public var company:CompanyModel? {
		didSet{
			nameInputField.text = company?.name
		}
	}
	
	weak public var companiesControllerDelegate: AddCompanyProtocol?
	
	private let backgroundView: UIView = {
		let bv = UIView()
		bv.backgroundColor = Props.blue4
		bv.translatesAutoresizingMaskIntoConstraints = false
		return bv
	}()
	
	private let nameLabel: UILabelWithEdges = {
		let label = UILabelWithEdges()
		label.text = "Имя"
		label.backgroundColor = .green
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textInsets.left = 15
		return label
	}()
	private let nameInputField: UITextField = {
		let label = UITextField()
		label.placeholder = "Введите имя"
		label.backgroundColor = .red
		label.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: label.frame.height))
		label.leftViewMode = .always
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		
		//navigationItem.title = "Добавить компанию"
		view.backgroundColor = .white
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Отмена",
			style: .plain,
			target: self,
			action: #selector(onCancelClick)
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Сохранить",
			style: .plain,
			target: self,
			action: #selector(onSaveClick)
		)
    }


	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company == nil ? "Добавить компанию" : "Редакт. компанию"
	}
	
	
	
	@objc private func onCancelClick(){
		dismiss(animated: true, completion: nil)
	}
	
	
	
	
	
	@objc private func onSaveClick(){
		if company == nil {
			createCompany()
		}
		else {
			saveCompanyChanges()
		}
		
  	}
	
	
	
	
	private func createCompany(){
		
		guard let name = Calc.checkBeforeUse(field: nameInputField) else { return }
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let newCompany = NSEntityDescription.insertNewObject(forEntityName: "CompanyModel", into: context)
		
		newCompany.setValue(name, forKey: "name")
		
		// 2) perform the save
		do {
			try context.save()
			dismiss(animated: true) {
				self.companiesControllerDelegate?.addCompany(company: newCompany as! CompanyModel)
			}
		}
		catch let err {
			print("Failed to save data: \(err.localizedDescription)")
		}
	}

	
	
	
	private func saveCompanyChanges(){
		
		guard let name = Calc.checkBeforeUse(field: nameInputField) else { return }
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		company?.name = name
		
		
		context.save()
		
		dismiss(animated: true, completion: nil)
	}
	
	
	
	
	
	private func setupUI(){
		view.addSubview(backgroundView)
		view.addSubview(nameLabel)
		view.addSubview(nameInputField)
		
		NSLayoutConstraint.activate([
			backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			//nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			nameInputField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			nameInputField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
			nameInputField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
			
			
		])
		
		
	}
	
	

}





































