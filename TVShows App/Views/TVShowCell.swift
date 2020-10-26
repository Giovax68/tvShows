//
//  TVShowCell.swift
//  TVShows App
//
//  Created by Giovanny Bonifaz on 24/10/20.
//

import UIKit

class TVShowCell: UITableViewCell {
	@IBOutlet weak var cover: UIImageView!
	@IBOutlet weak var title: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
