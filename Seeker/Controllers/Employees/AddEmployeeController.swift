//
//  AddEmployee.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddEmployeeDelegate: class {
	func updateEmployes(employee: RealmEmployee)
}

class AddEmployeeController: UIViewController {

	public weak var delegate: AddEmployeeDelegate?
	public var company: RealmCompany!
	// if need to change order - do it in next two arrays
	public static let segmentVars = [
		"executive",
		"managers",
		"staff",
	]
	public static let tabNames = [
		"Руководство",
		"Менджмент",
		"Персонал"
	]
	private let dFormat = "dd.MM.yyyy"
	private let nameLabel: UILabelWithEdges = {
		let label = UILabelWithEdges()
		label.text = "Имя"
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textInsets.left = 15
		return label
	}()
	private let nameInput: UITextField = {
		let label = UITextField()
		label.backgroundColor = .white
		label.placeholder = "Введите имя"
		label.layer.cornerRadius = 14
		label.clipsToBounds = true
		label.layer.borderWidth = 0.75
		label.layer.borderColor = Props.green4.cgColor
		label.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: label.frame.height))
		label.leftViewMode = .always
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	private let birthdayLabel: UILabelWithEdges = {
		let label = UILabelWithEdges()
		label.text = "Дата рожд."
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textInsets.left = 15
		return label
	}()
	private let birthdayInput: UITextField = {
		let label = UITextField()
		label.keyboardType = .numbersAndPunctuation
		label.autocorrectionType = UITextAutocorrectionType.no
		label.backgroundColor = .white
		label.placeholder = "чч.мм.гггг"
		label.layer.cornerRadius = 14
		label.clipsToBounds = true
		label.layer.borderWidth = 0.75
		label.layer.borderColor = Props.green4.cgColor
		label.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: label.frame.height))
		label.leftViewMode = .always
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	private let typeSegmentedControl: UISegmentedControl = {
		let sc = UISegmentedControl(items: AddEmployeeController.tabNames)
		sc.translatesAutoresizingMaskIntoConstraints = false
		sc.tintColor = Props.green1
		sc.selectedSegmentIndex = 0
		sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
		sc.layer.cornerRadius = 8
		sc.layer.borderColor = Props.green1.cgColor
		sc.layer.borderWidth = 1
		sc.clipsToBounds = true
		return sc
	}()
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = Props.darkGreen
		navigationItem.title = "Добавить сотрудника"
		setupCancelButton()
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Сохранить",
			style: .plain,
			target: self,
			action: #selector(onSaveClick)
		)
		setupUI()
		birthdayInput.text = generateRandDate()
	}
	

	private func setupUI(){
		createBackground(height: 190)
		view.addSubview(nameLabel)
		view.addSubview(nameInput)
		view.addSubview(birthdayLabel)
		view.addSubview(birthdayInput)
		view.addSubview(typeSegmentedControl)
		
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			nameLabel.widthAnchor.constraint(equalToConstant: 120),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			nameInput.topAnchor.constraint(equalTo: nameLabel.topAnchor),
			nameInput.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
			nameInput.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
			
			birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
			birthdayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			birthdayLabel.widthAnchor.constraint(equalToConstant: 120),
			birthdayLabel.heightAnchor.constraint(equalToConstant: 50),
			
			birthdayInput.topAnchor.constraint(equalTo: birthdayLabel.topAnchor),
			birthdayInput.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor),
			birthdayInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
			birthdayInput.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
			
			typeSegmentedControl.topAnchor.constraint(equalTo: birthdayInput.bottomAnchor, constant: 15),
			typeSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
			typeSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
			typeSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
		])
	}
	
	
	private func generateRandDate() -> String {
		let newDate = Calc.randomWithinYearsBeforeToday(20, 40)
		let strDate = Calc.convertDate(date: newDate)
		return strDate
	}
	
	
	@objc private func onSaveClick(){
		if let alertController = Calc.isFormValid(textfields: [nameInput, birthdayInput], alertStrings: ["Введите имя", "Введите дату"]){
			present(alertController, animated: true)
			return
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dFormat
		
		guard let birthDate = dateFormatter.date(from: birthdayInput.text!) else {
			let alertController = Calc.createAlert(message: "Неверный формат даты!")
			present(alertController, animated: true)
			return
		}
		let type = AddEmployeeController.segmentVars[typeSegmentedControl.selectedSegmentIndex]
		// create new EmployeeEntity
		let emplEnt = EmployeeEntity(name: nameInput.text!, type: type)
		let newRealmEmpl = RealmEmployee(entity: emplEnt)
		// create new nested entity newRealmEmpl.privateInformation
		let privEnt = PrivateInformationEntity(birthDay: birthDate, taxId: "")
		let newRealInf = RealmPrivateInformation(entity: privEnt)
		newRealmEmpl.privateInformation = newRealInf
		
		let realm = try! realmInstance()
		try! realm.write {
			company.employees.append(newRealmEmpl)
			dismiss(animated: true, completion: {
				self.delegate?.updateEmployes(employee: newRealmEmpl)
			})
		}
	}
	
}














