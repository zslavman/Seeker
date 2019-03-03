//
//  AddCompanyController.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

protocol AddCompanyProtocol:class {
	func addCompany(company: CompanyEntity)
	func didEditCompany()
	func returnAllCompanies() -> [RealmCompany]
}
	

class AddCompanyController: UIViewController {

	weak public var companiesControllerDelegate: AddCompanyProtocol?
	public var company: RealmCompany? {
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
		label.backgroundColor = .white
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
	private let datePicker: UIDatePicker = {
		let dp = UIDatePicker()
		dp.datePickerMode = .date
		dp.locale = Locale(identifier: "RU")
		dp.translatesAutoresizingMaskIntoConstraints = false
		return dp
	}()
	private let imageSize:CGFloat = 100
	internal lazy var isImageInstalled = false // don't want to save default picture in storage
	
	
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
	
	@objc private func onSaveClick(){
		if company == nil {
			createCompany()
		}
		else {
			editAndSaveCompanyChanges()
		}
	}
	
	@objc private func onPhotoClick(){
		DispatchQueue.main.async { // ?? doesn't work
			self.view.endEditing(true)
		}
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}
	
	/// create new company
	private func createCompany(){
		if let alertController = Calc.isFormValid(textfields: [nameInputField], alertStrings: ["Введите имя компании!"]){
			present(alertController, animated: true)
			nameInputField.text = ""
			return
		}
		let str = nameInputField.text!
		if isCompanyAlreadyExist(givenName: str){
			let alertController = Calc.createAlert(message: "Компания '\(str)' уже существует!")
			present(alertController, animated: true)
			return
		}
		var imgData: Data!
		if let image = photoPicker.image, isImageInstalled {
			imgData = image.jpegData(compressionQuality: 0.6)
		}
		let newCompany = CompanyEntity(founded: datePicker.date, imageData: imgData, imageUrl: nil, name: str)
		
		dismiss(animated: true, completion: {
			self.companiesControllerDelegate?.addCompany(company: newCompany)
		})
	}
	
	/// check if you already have a company with same name
	private func isCompanyAlreadyExist(givenName: String) -> Bool {
		var compArr = companiesControllerDelegate!.returnAllCompanies()
		compArr = compArr.filter{$0.name == givenName}
		return compArr.count > 0
	}
	
	/// edit company
	private func editAndSaveCompanyChanges(){
		guard let name = Calc.checkBeforeUse(field: nameInputField) else { return }
		
		var maybeData: Data?
		if let image = self.photoPicker.image, self.isImageInstalled {
			let imageData = image.jpegData(compressionQuality: 0.6)
			maybeData = imageData
		}
		if let company = company {
			let realm = try! realmInstance()
			try! realm.write {
				company.founded = datePicker.date
				company.imageData = maybeData
				company.name = name
			}
		}
		dismiss(animated: true, completion: {
			self.companiesControllerDelegate?.didEditCompany()
		})
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
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// Local variable inserted by Swift 4.2 migrator.
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
		
		var selectedImage:UIImage?
		if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage{
			selectedImage = editedImage
		}
		else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
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






































// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
