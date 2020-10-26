//
//  Connector.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import Foundation
import RxSwift

class Connector {
	
	func getShows() -> Observable<[TVShow]> {
		return Observable.create { observer in
			let session = URLSession.shared
			var request = URLRequest(url: URL(string: Constants.URL.main+Constants.Endpoint.shows)!)
			
			request.httpMethod = "GET"
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			
			session.dataTask(with: request) { (data, response, error) in
				guard let data = data, let response = response as? HTTPURLResponse, error == nil else { return }
				
				if response.statusCode == 200 {
					do {
						let shows = try JSONDecoder().decode(Array<TVShow>.self, from: data)
						observer.onNext(shows)
					} catch let err{
						observer.onError(err)
						print(err.localizedDescription)
					}
				}else{
					print("Error \(response.statusCode)")
				}
			}.resume()
			
			return Disposables.create {
				session.finishTasksAndInvalidate()
			}
		}
	}
}
