//
//  PhotosCollectionViewController.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit
import ImagePicker

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController, ImagePickerDelegate {
	
	var eventCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		if (eventCode == nil) {
			print("Nope, messed up up")
			//maybe present an error here?
			self.navigationController?.popViewController(animated: true)
		} else {
			print("event Code in Collection: \(eventCode)")
			//process event code data
		}
		
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		self.collectionView?.collectionViewLayout = PhotosCollectionViewFlowLayout()
		

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func presentImagePicker() {
		let imagePickerController = ImagePickerController()
		imagePickerController.delegate = self
		present(imagePickerController, animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 25
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoCollectionViewCell

		if (indexPath.row == 3) {
			cell.imageView.image = UIImage(named: "Bubs")
			return cell

		}
		cell.imageView.image = UIImage(named: "Max")
        // Configure the cell
    
        return cell
    }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		imageTapped(sender: collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
		return headerView
	}


	

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
	

	
	@IBAction func imageTapped(sender: PhotoCollectionViewCell) {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		let imageView = sender.imageView
		let newImageView = UIImageView(image: imageView?.image)
		newImageView.frame = self.view.frame
		newImageView.backgroundColor = UIColor.black
		newImageView.contentMode = .scaleAspectFit
		newImageView.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action:#selector(dismissFullscreenImage))
		newImageView.addGestureRecognizer(tap)
		self.view.addSubview(newImageView)
	}
	
	func dismissFullscreenImage(sender: UITapGestureRecognizer) {
		self.navigationController?.setNavigationBarHidden(false, animated: false)
		sender.view?.removeFromSuperview()
	}
	
	// MARK: Image Picker Delegate
	
	func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		//imagePicker.dismiss(animated: true, completion: nil)
		print("wrapper")
	}
	func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		imagePicker.dismiss(animated: true, completion: nil)
		print("done")
	}
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
		print("Cancel")
	}
	
}
