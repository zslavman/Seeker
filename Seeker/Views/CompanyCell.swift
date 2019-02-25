//
//  CompanyCell.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class CompanyCell: UITableViewCell {
	
	public var company: RealmCompany? {
		didSet {
			setValues()
		}
	}
	private var companyPhoto: ImageLoader = {
		let iv = ImageLoader()
		iv.image = #imageLiteral(resourceName: "select_photo")
		iv.contentMode = .scaleAspectFill
		iv.translatesAutoresizingMaskIntoConstraints = false
		return iv
	}()
	private let mainLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	private let photoSize: CGFloat = 40
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = Props.green3
		setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setupUI(){
		addSubview(companyPhoto)
		addSubview(mainLabel)
		
		NSLayoutConstraint.activate([
			companyPhoto.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
			companyPhoto.widthAnchor.constraint(equalToConstant: photoSize),
			companyPhoto.heightAnchor.constraint(equalToConstant: photoSize),
			companyPhoto.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
			mainLabel.leftAnchor.constraint(equalTo: companyPhoto.rightAnchor, constant: 16),
			mainLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
		])
	}
	
	
	private func setValues(){
		mainLabel.text = company?.name
		if let name = company?.name, let founded = company?.founded {
			let string = Calc.convertDate(founded: founded)
			mainLabel.attributedText = Calc.twoColorString(strings: (name, "  # Основана: \(string)"), colors: (UIColor.white, Props.green4))
		}
		if let imageBinary = company?.imageData {
			let img = UIImage(data: imageBinary)
			setLoadedImage(img: img!)
		}
		else if let imageUrl = company?.imageUrl {
			companyPhoto.loadImage(urlString: imageUrl, callback: {
				(img) in
				guard let img = img else { return }
				DispatchQueue.main.async {
					self.setLoadedImage(img: img, saveToRealm: true)
				}
			})
		}
	}
	
	private func setLoadedImage(img: UIImage, saveToRealm: Bool = false) {
		DispatchQueue.main.async {
			self.companyPhoto.image = img
			self.companyPhoto.layer.cornerRadius = self.photoSize / 2
			self.companyPhoto.layer.borderColor = Props.green1.cgColor
			self.companyPhoto.layer.borderWidth = 1
			self.companyPhoto.clipsToBounds = true
		
			guard let company = self.company, saveToRealm else { return }
			guard !company.isInvalidated else { return } // fixing realm-failure on deleting before download complete
			let realm = try! realmInstance()
			try! realm.write {
				company.imageUrl = nil
				company.imageData = img.jpegData(compressionQuality: 0.6)
			}
		}
	}
	
}


















