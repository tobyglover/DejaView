//
//  PhotoCollectionViewCell.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit

@IBDesignable class PhotoCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}

	
}
