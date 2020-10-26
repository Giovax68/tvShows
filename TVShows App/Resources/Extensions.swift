//
//  Extensions.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import Foundation
import UIKit

extension UIImageView {
	
	func imageFromServer(urlString: String) {
		if self.image == nil {
			guard let placeHolderImage = UIImage(named: "placeholder") else { return }
			self.image = placeHolderImage
		}
		
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { data, response, error in
			if error != nil { return }
			
			DispatchQueue.main.async {
				guard let data = data else { return }
				let image = UIImage(data: data)
				self.image = image
			}
		}.resume()
	}
}


extension String {
	var htmlToAttributedString: NSAttributedString? {
		guard let data = data(using: .utf8) else { return nil }
		do {
			return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch {
			return nil
		}
	}
	
	var htmlToString: String {
		return htmlToAttributedString?.string ?? ""
	}
}
