//
//  EventsTableViewController.swift
//  imghost
//
//  Created by Max Greenwald on 10/14/16.
//
//

import UIKit
import DZNEmptyDataSet
import RealmSwift

class EventsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.emptyDataSetSource = self;
		self.tableView.emptyDataSetDelegate = self;
      
		// A little trick for removing the cell separators
		self.tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	@IBAction func enterEventCode() {
		let codePopup = UIAlertController(title: "Enter Event Code", message: nil, preferredStyle: .alert)
		codePopup.addTextField{(textField) in
			textField.placeholder = "Event Code"
		}
		
		let submitAction = UIAlertAction(title: "Enter", style: .default, handler: { (action) in
			if let code = codePopup.textFields?[0].text {
				self.transitionToPhotosCollection(eventCode: code)
				print("got code \(code)")
			} else {
				print("ERROR - no text field")
			}
			
			
			

		})
		
		codePopup.addAction(submitAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		codePopup.addAction(cancelAction)
		
		present(codePopup, animated: true, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		let realm = try! Realm()
		let events = realm.objects(Event.self)
        return events.count
    }
	

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsTableViewCell
		
		let realm = try! Realm()
		let events = realm.objects(Event.self)
		let event = events[indexPath.row]
		
		
		cell.title.text = event.name
		cell.desc.text = event.desc
		cell.code.text = event.external_id
		
		cell.pic.downloadedFrom(link: event.eventImage)
		
		//cell.imageView?.image = UIImage(data: Data(contentsOf: URL(string: event.eventImage)!))
		
		
        // Configure the cell...

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let realm = try! Realm()
		let events = realm.objects(Event.self)
		let event = events[indexPath.row]
		
		self.transitionToPhotosCollection(eventCode: event.external_id)
	}
	
	

	

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

	/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "photos") {
			let photos = segue.destination as! PhotosCollectionViewController
			if let code = mostRecentEventCode {
				photos.eventCode = code
			}
		}
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
	
	func transitionToPhotosCollection(eventCode: String) {
		
		APIEngine.sharedInstance.getEventDetail(eventID: eventCode, ending: {eventExists in
			
			if (eventExists == true) {
			
				let photos = self.storyboard!.instantiateViewController(withIdentifier: "photos") as! PhotosCollectionViewController
				photos.eventCode = eventCode
				self.navigationController?.pushViewController(photos, animated: true)
			} else {
				
				let alert = UIAlertController(title: "Error", message: "We have encounterend an error retrieving your event. Check network settings.", preferredStyle: .alert)
				let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
				alert.addAction(ok)
				self.present(alert, animated: true, completion: nil)
			}
		})
	}
	
	
	// MARK: - DNZEmptyDataSource
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString(string: "Howdy!", attributes: [NSForegroundColorAttributeName : UIColor.white])
	}
	
	func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		return NSAttributedString(string: "Please enter your event code:", attributes: [NSForegroundColorAttributeName : UIColor.white])
	}
	
	func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
		return UIColor(colorLiteralRed: 0.0, green: 177.0/255.0, blue: 83.0/255.0, alpha: 1.0)
	}
	/*
	func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
		var attributes = Dictionary<String, Any>()
		attributes[NSFontAttributeName] = UIFont.boldSystemFont(ofSize: 14)
		attributes[NSForegroundColorAttributeName] = UIColor.darkGray
		return NSAttributedString(string: "Enter Event Code", attributes: attributes)
	}
	
	func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
		
		let capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
		let rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0)
		let image = UIImage(named: "button_background_icloud_" + ((state == .normal) ? "normal" : "highlight"))

		return image!.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets)
		
		//return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
	}
	
	func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
		enterEventCode()
	} */
	



}


extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let _ = response?.mimeType,
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
			}.resume()
	}
	func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		print("Got hereOOOOO")
		guard let url = URL(string: link) else { return }
		downloadedFrom(url: url, contentMode: mode)
	}
}
