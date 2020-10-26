//
//  HomeViewModel.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import Foundation
import RxSwift

class HomeViewModel {
	private weak var view: HomeView?
	private var router: HomeRouter?
	private var connector = Connector()
	
	func bind(view: HomeView, router: HomeRouter){
		self.view = view
		self.router = router
		self.router?.setSorceView(view)
	}
	
	func getShowListData() -> Observable<[TVShow]> {
		return connector.getShows()
	}
	
	func makeDetailView(_ tvShow: TVShow) {
		router?.navigateToDetail(tvShow)
	}
}
