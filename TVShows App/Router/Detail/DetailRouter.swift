//
//  DetailRouter.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import UIKit

class DetailRouter {
	
	var tvShow: TVShow
	private var sourceView: UIViewController?
	var viewController: UIViewController {
		return self.createViewController()
	}
	
	init(_ tvShow: TVShow) {
		self.tvShow = tvShow
	}
	
	private func createViewController() -> UIViewController {
		let view = DetailView(nibName: "DetailView", bundle: Bundle.main)
		view.tvShow = self.tvShow
		return view
	}
	
	func setSorceView(_ sourceView: UIViewController?) {
		guard let view = sourceView else { fatalError("Error Desconocido") }
		self.sourceView = view
	}
	
}
