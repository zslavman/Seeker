//
//  Calc.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 20.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


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
	
	
	public static func createAlert(message: String, title: String = "", completion: (() -> ())?) -> UIAlertController {
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
	
	
	public static func convertDate(founded: Date) -> String{
		let dateFormater = DateFormatter()
		dateFormater.locale = Locale(identifier: "RU")
		dateFormater.dateFormat = "dd MMM yyyy"
		let dateString = dateFormater.string(from: founded)
		return dateString
	}
	
	
	
}












