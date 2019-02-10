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
	@objc dynamic var id = UUID().uuidString
	let employees = List<RealmEmployee>()
	
	override class func primaryKey() -> String? {
		return "id"
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
	@objc dynamic var id: String = UUID().uuidString
	@objc dynamic var privateInformation: RealmPrivateInformation?
	var company = LinkingObjects(fromType: RealmCompany.self, property: "employees")
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
	convenience init(entity: EmployeeEntity) {
		self.init()
		self.name = entity.name
		self.type = entity.type
	}
}


class RealmPrivateInformation: Object {
	@objc dynamic var birthDay: Date?
	@objc dynamic var taxId: String?
	@objc dynamic var id: String = UUID().uuidString
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
	convenience init(entity: PrivateInformationEntity) {
		self.init()
		self.birthDay = entity.birthDay
		self.taxId = entity.taxId
	}
}






