//
//  CustomTabBarView.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import UIKit

class TabBarView: UITabBarController {
	
	private var router = TabBarRouter()
	private var viewModel = TabBarViewModel()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		viewModel.bind(view: self, router: router)
        configure()
    }
	
	private func configure() {
		let vc1 = HomeRouter().viewController
		let navC1 = configureNavBar(vc1, "TV Shows")
		navC1.tabBarItem.image = UIImage(systemName: "tv")
		navC1.tabBarItem.selectedImage = UIImage(systemName: "tv.fill")
		navC1.tabBarItem.title = "TV Shows"
		
		let vc2 = FavRouter().viewController
		let navC2 = configureNavBar(vc2, "Favorite Shows")
		navC2.tabBarItem.image = UIImage(systemName: "star.square")
		navC2.tabBarItem.selectedImage = UIImage(systemName: "star.square.fill")
		navC2.tabBarItem.title = "My Favs"
		
		self.viewControllers = [navC1, navC2]
		self.selectedViewController = navC1
		
		tabBar.barTintColor = .red
		tabBar.isTranslucent = false
		tabBar.tintColor = .white
		tabBar.unselectedItemTintColor = .white
	}
	
	private func configureNavBar(_ controller: UIViewController, _ title: String) -> UINavigationController {

		controller.navigationItem.title = title
		
		let navC = UINavigationController(rootViewController: controller)
		navC.navigationBar.tintColor = .white
		navC.navigationBar.barTintColor = .red
		navC.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor:UIColor.white,
			NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: CGFloat(25))!
		]
		return navC
	}
}
