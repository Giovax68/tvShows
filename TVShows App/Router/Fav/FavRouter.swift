//
//  FavRouter.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import UIKit

class FavRouter {
	
	private var sourceView: UIViewController?
	var viewController: UIViewController {
		return self.createViewController()
	}
	
	private func createViewController() -> UIViewController {
		let view = FavView(nibName: "FavView", bundle: Bundle.main)
		return view
	}
	
	func setSorceView(_ sourceView: UIViewController?) {
		guard let view = sourceView else { fatalError("Error Desconocido") }
		self.sourceView = view
	}
	
	func navigateToDetail(_ tvShow: TVShow) {
		let detailView = DetailRouter(tvShow).viewController as! DetailView
		sourceView?.navigationController?.pushViewController(detailView, animated: true)
	}
}
