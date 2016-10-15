//
//  PhotosCollectionViewFlowLayout.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit

class PhotosCollectionViewFlowLayout: UICollectionViewFlowLayout {

	override init() {
		super.init()
		setupLayout()
	}
 
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupLayout()
	}
 
	func setupLayout() {
		minimumInteritemSpacing = 1
		minimumLineSpacing = 1
		scrollDirection = .vertical
	}
	
	override var itemSize: CGSize {
		set {
			
		}
		get {
			let numberOfColumns: CGFloat = 3
			
			let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
			return CGSize(width: itemWidth, height: itemWidth)
		}
	}

}
