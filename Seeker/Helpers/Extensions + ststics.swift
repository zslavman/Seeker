//
//  Extensions + ststics.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


extension UIColor {
	
	convenience init(hex: Int) {
		let components = (
			R: CGFloat((hex >> 16) & 0xff) / 255,
			G: CGFloat((hex >> 08) & 0xff) / 255,
			B: CGFloat((hex >> 00) & 0xff) / 255
		)
		self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
	}
	// let purple = UIColor(hex: 0xAB47BC)
	
	static let poisonGreen = UIColor(hex: 0x00ff00)
}




// кастомная лейба, в которой можно установить паддинги
class UILabelWithEdges: UILabel {
	
	var textInsets = UIEdgeInsets.zero {
		didSet { invalidateIntrinsicContentSize() }
	}
	
	override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
		let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
		let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
		return UIEdgeInsetsInsetRect(textRect, invertedInsets)
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
	}
}



extension UIViewController {
	
	internal func setupButtonsInNavBar(selector: Selector){
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: #imageLiteral(resourceName: "plus_bttn"),
			style: .plain,
			target: self,
			action: selector
		)
	}
	
	
	internal func setupCancelButton(){
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Отмена",
			style: .plain,
			target: self,
			action: #selector(onCancelClick)
		)
	}
	
	
	@objc private func onCancelClick(){
		dismiss(animated: true, completion: nil)
	}
	
	
	@discardableResult internal func createBackground(height: CGFloat = 350) -> UIView{
		
		let backView = UIView()
		backView.backgroundColor = Props.blue5
		backView.translatesAutoresizingMaskIntoConstraints = false
		backView.isUserInteractionEnabled = true
		backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
		
		view.addSubview(backView)
		
		NSLayoutConstraint.activate([
			backView.topAnchor.constraint(equalTo: view.topAnchor),
			backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backView.heightAnchor.constraint(equalToConstant: height)
		])
		return backView
	}
	
	
	@objc private func dismissKeyboard(){
		view.endEditing(true)
	}

	
}




































