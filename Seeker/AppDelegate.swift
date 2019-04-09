//
//  AppDelegate.swift
//  Seeker
//
//  Created by Zinko Vyacheslav on 19.01.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		configureAppearance()
		
		window = UIWindow()
		window?.makeKeyAndVisible()
		
		// View controller-based status bar appearance = NO (plist) if iOS < 9
		//application.statusBarStyle = .lightContent
		window?.rootViewController = UINavigationController(rootViewController: CompaniesController())
		return true
	}


	private func configureAppearance(){
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().prefersLargeTitles = true
		UINavigationBar.appearance().barTintColor = Props.green1
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().titleTextAttributes = [
			.foregroundColor: Props.green4
		]
		UINavigationBar.appearance().largeTitleTextAttributes = [
			.foregroundColor: Props.green4
		]
	}
	
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		print("url = \(url)")
		let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
		let host = urlComponents?.host ?? ""
		print(host)
		
		if host == "pppo" {
			//			let sb = UIStoryboard(name: "Main", bundle: .main)
			//			let secretVC = sb.instantiateViewController(withIdentifier: "SecretVC") as? SecretViewController
			//			secretVC?.secretMessage = urlComponents?.queryItems?.first?.value
			//			window?.rootViewController = secretVC
		}
		return true
	}
	
}


extension UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		//return topViewController?.preferredStatusBarStyle ?? .lightContent
		return .lightContent
	}
}




















