//
//  Show+CoreDataProperties.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 26/10/20.
//
//

import Foundation
import CoreData


extension Show {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Show> {
		return NSFetchRequest<Show>(entityName: "Show")
	}
	
	@NSManaged public var id: Int32
	@NSManaged public var name: String
	@NSManaged public var genres: [String]
	@NSManaged public var language: String
	@NSManaged public var imdb: String?
	@NSManaged public var rating: Double
	@NSManaged public var image: String
	@NSManaged public var summary: String
	@NSManaged public var premiered: String
	
}

extension Show : Identifiable {
	
	func setData(_ tvShow: TVShow) {
		self.id = Int32(tvShow.id)
		self.name = tvShow.name
		self.genres = tvShow.genres
		self.language = tvShow.language
		self.imdb = tvShow.externals.imdb
		self.rating = tvShow.rating.average ?? 0
		self.image = tvShow.image.medium
		self.summary = tvShow.summary
		self.premiered = tvShow.premiered
	}
}

