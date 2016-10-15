//
//  PhotosCollectionViewController.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit
import ImagePicker
import RealmSwift


private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController, ImagePickerDelegate, UIGestureRecognizerDelegate {
	@IBOutlet var longpress: UILongPressGestureRecognizer!
	
	@IBOutlet var saveButton: UIButton!
	var eventCode: String?
	var images: Array<Image>?
	
	var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.saveButton.isHidden = true
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
		longpress.addTarget(self, action: #selector(handleHoldGesture))
		if (eventCode == nil) {
			print("Nope, messed up up")
			//maybe present an error here?
			self.navigationController?.popViewController(animated: true)
		} else {
			print("event Code in Collection: \(eventCode)")
			getPicsFromEvent()
			
			
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
	
	func getPicsFromEvent () {
		APIEngine.sharedInstance.getPictureArr(eventID: eventCode!, ending: {imgArr in
			
			self.images = imgArr
			self.collectionView?.reloadData()
		})
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
		if let imgArr = images {
			return imgArr.count
		} else {
			return 0
		}
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoCollectionViewCell
		if let imgArr = images {
			let pic = imgArr[indexPath.row]
			print(pic.uri)
			cell.imageView.downloadedFrom(link: pic.uri)
		}
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
		currentImage = sender.imageView.image
		let newImageView = UIImageView(image: imageView?.image)
		newImageView.frame = self.view.frame
		newImageView.backgroundColor = UIColor.black
		newImageView.contentMode = .scaleAspectFit
		newImageView.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action:#selector(dismissFullscreenImage))
		newImageView.addGestureRecognizer(tap)
		self.view.addSubview(newImageView)
		saveButton.isHidden = false
		saveButton.bounds = CGRect(x: 30, y: 60, width: 200, height: 60)
		self.view.addSubview(saveButton)
		
	}
	
	func dismissFullscreenImage(sender: UITapGestureRecognizer) {
		
		saveButton.isHidden = true
		
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
		guard let code = eventCode else {return}
		for image in images {
			/*APIEngine.sharedInstance.uploadImageData(img: image, eventID: code, ending: {success in

				
				if (success == true) {
					self.getPicsFromEvent()
					self.collectionView?.reloadData()
					print("Woo!")
				} else {
				}
			})*/
		}
		
		print("done")
	}
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
		print("Cancel")
	}
	
	@IBAction func imageLongTapped(sender: PhotoCollectionViewCell) {
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		let imageView = sender.imageView
		
		print("image long pressed")
	}
	
	func handleHoldGesture (gestureRecognizer: UILongPressGestureRecognizer)
	{
	
	 print("in recognizer")
		
	}
	
	@IBAction func saveToPhone(_ sender: AnyObject) {
		
		let alert = UIAlertController(title: "Saved!", message: "We have saved your image to the phone.", preferredStyle: .alert)
		let ok = UIAlertAction(title: "Thanks!", style: .cancel, handler: nil)
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
		
		guard let ci = currentImage else {return}
		
		UIImageWriteToSavedPhotosAlbum(ci, nil, nil, nil)
		
		
		
		
		
	}
	
}




