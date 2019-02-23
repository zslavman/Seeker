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




// custom label, witch have a paddings
class UILabelWithEdges: UILabel {
	
	var textInsets = UIEdgeInsets.zero {
		didSet { invalidateIntrinsicContentSize() }
	}
	
	override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		let insetRect = bounds.inset(by: textInsets)
		let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
		let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
		return textRect.inset(by: invertedInsets)
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: textInsets))
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




//let imagesCache = NSCache<NSString, UIImage>()
var imagesCache = [String:UIImage]()

class ImageLoader: UIImageView {
	
	private var urlString: String?
	
	/// download image from url
	public func loadImage(urlString: String, callback: @escaping (UIImage?) -> Void) {
		if let imageFromCache = imagesCache[urlString] {
			callback(imageFromCache)
			return
		}
		self.urlString = urlString
		//image = nil
		guard let url = URL(string: urlString) else { return }
		
		let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
		URLSession.shared.dataTask(with: request) {
			[weak self] (data, response, error) in
			guard let strongRef = self else { return }
			
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else { return }
			if let downlodedImage = UIImage(data: data){
				imagesCache[urlString] = downlodedImage
				if urlString != strongRef.urlString { // fix blinking & if self removed by ARC
					return
				}
				callback(downlodedImage)
			}
		}.resume()
	}
	
	
}





































