//
//  DetailViewModel.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import RxSwift

class DetailViewModel {
	
	private(set) weak var view: DetailView?
	private var router: DetailRouter?
	
	func bind(view: DetailView, router: DetailRouter){
		self.view = view
		self.router = router
		self.router?.setSorceView(view)
	}
}
