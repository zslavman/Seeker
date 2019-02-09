//
//  Calc.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 20.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit
import RealmSwift

class Calc {
	
	
	/// check UITextField/UITextView on empty or just only spaces
	public static func checkBeforeUse<T>(field: T) -> String? {
		
		if let str = (field as! UITextField).text, !str.isEmpty {
			let n = str.filter{!" ".contains($0)}
			if n.count > 0 {
				return str
			}
		}
		return nil
	}
	
	
	public static func createAlert(message: String, title: String = "Ошибка", completion: (() -> ())? = nil) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OK_action = UIAlertAction(title: "OK", style: .default, handler: {
			(action) in
			if let completion = completion {
				completion()
			}
		})
		
		alertController.addAction(OK_action)
		return alertController
	}
	
	
	/// Validating UITextFields
	///
	/// - Parameters:
	///   - textfields: array of textfields
	///   - alertStrings: array of alert messages
	public static func isFormValid<T>(textfields:[T], alertStrings:[String?]) -> UIAlertController?{
		
		for (index, _) in textfields.enumerated(){
			
			if Calc.checkBeforeUse(field: textfields[index]) == nil { 	// if field is empty
				let message = alertStrings[index] ?? "Неправильное поданы агрументы alertStrings"
				return Calc.createAlert(message: message)
			}
		}
		return nil
	}
	
	
	public static func convertDate(founded: Date) -> String{
		let dateFormater = DateFormatter()
		dateFormater.locale = Locale(identifier: "RU")
		dateFormater.dateFormat = "dd MMM yyyy"
		let dateString = dateFormater.string(from: founded)
		return dateString
	}
	
	
	/// coloraise string into two colors
	public static func twoColorString(strings:(String, String), colors:(UIColor, UIColor)) -> NSAttributedString {
		let atr = NSMutableAttributedString(string: "")
		atr.append(NSAttributedString(string: strings.0, attributes: [
			.font: UIFont.boldSystemFont(ofSize: 16),
			.foregroundColor: colors.0,
		]))
		atr.append(NSAttributedString(string: strings.1, attributes: [
			.font: UIFont.boldSystemFont(ofSize: 16),
			.foregroundColor: colors.1,
		]))
		return atr
	}
	
	
	/// execution speed measurement
	static func timeMeasuringCodeRunning(title:String, operationBlock: () -> ()) {
		let start = CFAbsoluteTimeGetCurrent()
		operationBlock()
		let finish = CFAbsoluteTimeGetCurrent()
		let timeElapsed = finish - start
		let roundedTime = String(format: "%.3f", timeElapsed)
		print ("Время выполнения \(title) = \(roundedTime) секунд")
	}
	
}


func realmInstance() throws -> Realm {
	let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
	let realm = try! Realm(configuration: config)
	print(Realm.Configuration.defaultConfiguration.fileURL!) // local path for Realm Browser
	return realm
}

















