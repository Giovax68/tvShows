//
//  TabBarRouter.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import UIKit

class TabBarRouter {
	
	private var sourceView: UITabBarController?
	var controller: UITabBarController {
		return self.createViewController()
	}
	
	private func createViewController() -> UITabBarController {
		let view = TabBarView(nibName: "TabBarView", bundle: .main)
		return view
	}
	
	func setSorceView(_ sourceView: UITabBarController?) {
		guard let view = sourceView else { fatalError("Error Desconocido") }
		self.sourceView = view
	}
}
