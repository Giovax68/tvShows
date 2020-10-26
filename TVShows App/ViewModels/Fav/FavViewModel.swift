//
//  FavViewModel.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 25/10/20.
//

import Foundation
import RxSwift

class FavViewModel {
	private weak var view: FavView?
	private var router: FavRouter?
	private var connector = Connector()
	
	func bind(view: FavView, router: FavRouter){
		self.view = view
		self.router = router
		self.router?.setSorceView(view)
	}
	
	func getFavShowListData() -> Observable<[TVShow]> {
		return connector.getShows()
	}
	
	func makeDetailView(_ tvShow: TVShow) {
		router?.navigateToDetail(tvShow)
	}
}
