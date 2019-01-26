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


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		configureAppearance()
		
		window = UIWindow()
		window?.makeKeyAndVisible()
		
		// View controller-based status bar appearance = NO (plist)
		application.statusBarStyle = .lightContent
		
		window?.rootViewController = UINavigationController(rootViewController: CompaniesController())
		//window?.rootViewController = UINavigationController(rootViewController: CompaniesAutoUpdateController())
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
	
}






















