//
//  Calc.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 20.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class Calc {
	
	
	/// check UITextField/UITextView on empty or fust only spaces
	public static func checkBeforeUse<T>(field: T) -> String? {
		
		if let str = (field as! UITextField).text, !str.isEmpty {
			let n = str.filter{!" ".contains($0)}
			if n.count > 0 {
				return str
			}
		}
		return nil
	}
	
}
