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
	func didEditCompany(company: CompanyModel)
}
	

class AddCompanyController: UIViewController {

	weak public var companiesControllerDelegate: AddCompanyProtocol?
	public var company:CompanyModel? {
		didSet{
			nameInputField.text = company?.name
			if let founded = company?.founded {
				datePicker.date = founded
			}
			if let imageBinary = company?.imageData {
				photoPicker.image = UIImage(data: imageBinary)
				roundPhoto()
				isImageInstalled = true
			}
		}
	}
//	lazy var backView: UIView = {
//		let bv = UIView()
//		bv.backgroundColor = Props.blue5
//		bv.translatesAutoresizingMaskIntoConstraints = false
//		bv.isUserInteractionEnabled = true
//		bv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
//		return bv
//	}()
	private lazy var photoPicker:UIImageView = {
		let iv = UIImageView()
		iv.translatesAutoresizingMaskIntoConstraints = false
		iv.contentMode = .scaleAspectFit
		iv.image = UIImage(named: "select_photo")
		iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPhotoClick)))
		iv.isUserInteractionEnabled = true
		return iv
	}()
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
		label.layer.borderWidth = 1
		label.layer.borderColor = Props.green4.cgColor
		label.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: label.frame.height))
		label.leftViewMode = .always
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	private let datePicker: UIDatePicker = {
		let dp = UIDatePicker()
		dp.datePickerMode = .date
		dp.locale = Locale(identifier: "RU")
		dp.translatesAutoresizingMaskIntoConstraints = false
		return dp
	}()
	private let imageSize:CGFloat = 100
	internal lazy var isImageInstalled = false // I don't want to save default picture in storage
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()

		view.backgroundColor = Props.darkGreen
		
		setupCancelButton()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Сохранить",
			style: .plain,
			target: self,
			action: #selector(onSaveClick)
		)
    }

	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		nameInputField.becomeFirstResponder()
	}
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company == nil ? "Добавить компанию" : "Редакт. компанию"
	}
	
	

	
//	@objc private func dismissKeyboard() {
//		nameInputField.resignFirstResponder()
//	}
	
	
	@objc private func onSaveClick(){
		if company == nil {
			createCompany()
		}
		else {
			saveCompanyChanges()
		}
	}
	
	
	@objc private func onPhotoClick(){
		DispatchQueue.main.async { // ??
			self.view.endEditing(true)
		}
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}
	
	
	private func createCompany(){
		guard let name = Calc.checkBeforeUse(field: nameInputField)
		else {
			let alertController = Calc.createAlert(message: "Введите имя компании!", completion: nil)
			present(alertController, animated: true, completion: nil)
			nameInputField.text = ""
			return
		}

		let context = CoreDataManager.shared.persistentContainer.viewContext
		let newCompany = NSEntityDescription.insertNewObject(forEntityName: "CompanyModel", into: context)
		
		newCompany.setValue(name, forKey: "name")
		newCompany.setValue(datePicker.date, forKey: "founded")
		if let image = photoPicker.image, isImageInstalled {
			let data = UIImageJPEGRepresentation(image, 0.6)
			newCompany.setValue(data, forKey: "imageData")
		}
		
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
		company?.founded = datePicker.date
		if let image = photoPicker.image, isImageInstalled {
			let imageData = UIImageJPEGRepresentation(image, 0.6)
			company?.imageData = imageData
		}
		
		do {
			try context.save()
			dismiss(animated: true) {
				self.companiesControllerDelegate?.didEditCompany(company: self.company!)
			}
		}
		catch let err {
			print("Failed to save data: \(err.localizedDescription)")
		}
	}

	
	private func setupUI(){
		let backView = createBackground()
		view.addSubview(nameLabel)
		view.addSubview(nameInputField)
		view.addSubview(datePicker)
		view.addSubview(photoPicker)
		
		NSLayoutConstraint.activate([
			photoPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			photoPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			photoPicker.widthAnchor.constraint(equalToConstant: imageSize),
			photoPicker.heightAnchor.constraint(equalToConstant: imageSize),
			
			nameLabel.topAnchor.constraint(equalTo: photoPicker.bottomAnchor, constant: 20),
			nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			nameLabel.widthAnchor.constraint(equalToConstant: 100),
			nameLabel.heightAnchor.constraint(equalToConstant: 50),
			
			nameInputField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
			nameInputField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
			nameInputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
			nameInputField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
			
			datePicker.topAnchor.constraint(equalTo: nameInputField.bottomAnchor),
			datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			datePicker.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
		])
	}
	
	
	internal func roundPhoto() {
		photoPicker.layer.cornerRadius = imageSize / 2
		photoPicker.clipsToBounds = true
		photoPicker.layer.borderColor = Props.green4.cgColor
		photoPicker.layer.borderWidth = 1
	}
	
}


extension AddCompanyController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImage:UIImage?
		if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
			selectedImage = editedImage
		}
		else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
			selectedImage = originalImage
		}
		if selectedImage != nil {
			photoPicker.image = selectedImage
			roundPhoto()
			isImageInstalled = true
		}
		
		dismiss(animated: true, completion: nil)
	}
	
}





































