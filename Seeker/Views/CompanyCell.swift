//
//  CompanyCell.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 23.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class CompanyCell: UITableViewCell {
	
	public var company: CompanyModel? {
		didSet {
			setValues()
		}
	}
	private let companyPhoto: UIImageView = {
		let iv = UIImageView()
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
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
			mainLabel.attributedText = Calc.twoColorString(strings: (name, "  #  Основана: \(string)"), colors: (UIColor.white, Props.green4))
		}
		if let imageBinary = company?.imageData {
			let img = UIImage(data: imageBinary)
			companyPhoto.image = img
			companyPhoto.layer.cornerRadius = photoSize / 2
			companyPhoto.layer.borderColor = Props.green1.cgColor
			companyPhoto.layer.borderWidth = 1
			companyPhoto.clipsToBounds = true
		}
	}
	
	
}














