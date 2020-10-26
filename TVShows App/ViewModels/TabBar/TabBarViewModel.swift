//
//  TabBarViewModel.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import RxSwift

class TabBarViewModel {
	private weak var view: TabBarView?
	private var router: TabBarRouter?
	
	func bind(view: TabBarView, router: TabBarRouter){
		self.view = view
		self.router = router
		self.router?.setSorceView(view)
	}
}
