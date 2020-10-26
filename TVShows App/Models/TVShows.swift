//
//  TVShows.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import Foundation
	
struct TVShow: Codable {
	let id: Int
	let name: String
	let genres: [String]
	let language: String
	let externals: Externals
	let rating: Rating
	let image: Cover
	let summary: String
	let premiered: String
	
	init(show: Show) {
		self.id = Int(show.id)
		self.name = show.name
		self.genres = show.genres
		self.language = show.language
		self.externals = Externals(imdb: show.imdb)
		self.rating = Rating(average: show.rating)
		self.image = Cover(medium: show.image)
		self.summary = show.summary
		self.premiered = show.premiered
	}
}

struct Rating: Codable {
	let average: Double?
}

struct Cover: Codable {
	let medium: String
}

struct Externals: Codable {
	let imdb: String?
}
