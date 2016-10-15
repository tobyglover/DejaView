//
//  EventsTableViewCell.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit

class EventsTableViewCell: UITableViewCell {
	
	@IBOutlet var title: UILabel!
	
	@IBOutlet var desc: UILabel!
	@IBOutlet var code: UILabel!
	@IBOutlet var pic: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
