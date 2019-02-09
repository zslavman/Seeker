//
//  RealmModels.swift
//  Seeker
//
//  Created by Zinko Viacheslav on 09.02.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCompany: Object {
	@objc dynamic var founded: Date?
	@objc dynamic var imageData: Data?
	@objc dynamic var imageUrl: String?
	@objc dynamic var membership: String = String()
	@objc dynamic var name: String?
	let employees = List<RealmEmployee>()
	
	override class func primaryKey() -> String? {
		return "name"
	}
	
	convenience init(entity: CompanyEntity) {
		self.init()
		self.founded = entity.founded
		self.imageData = entity.imageData
		self.imageUrl = entity.imageUrl
		self.membership = entity.membership
		self.name = entity.name
	}
}

class RealmEmployee: Object {
	@objc dynamic var name: String?
	@objc dynamic var type: String?
	var company = LinkingObjects(fromType: RealmCompany.self, property: "employees")
	//var privateInformation = LinkingObjects(fromType: RealmPrivateInformation.self, property: "employee")
	var privateInformation: RealmPrivateInformation?
	
	override class func primaryKey() -> String? {
		return "name"
	}
	
	convenience init(entity: EmployeeEntity) {
		self.init()
		self.name = entity.name
		self.type = entity.type
	}
}

class RealmPrivateInformation: Object {
	@objc dynamic var birthDay: String?
	@objc dynamic var taxId: String?
//	var employee = LinkingObjects(fromType: RealmEmployee.self, property: "privateInformation")
	var employee: RealmEmployee?
	
	convenience init(entity: PrivateInformationEntity) {
		self.init()
		self.birthDay = entity.birthDay
		self.taxId = entity.taxId
	}
}






