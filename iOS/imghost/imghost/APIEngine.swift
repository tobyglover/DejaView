//
//  APIEngine.swift
//  Pods
//
//  Created by Max Greenwald on 10/15/16.
//
//

import UIKit
import ImagePicker
import RealmSwift
import SwiftyJSON
import Alamofire

class APIEngine: NSObject {
	static let sharedInstance = APIEngine()
	
	let apiURL = "http://162.243.55.228/api/"
	
	override private init() {
	
	
	}
	
	private func dataTaskWithRequest(requestEnding: String, task: @escaping (JSON?) -> Void) {
		Alamofire.request(apiURL + requestEnding).responseJSON { response in
			print(response.request)  // original URL request
			print(response.response) // HTTP URL response
			print(response.data)     // server data
			print(response.result)   // result of response serialization
			
			if let fullJSON = response.result.value {
				let json = JSON(fullJSON)
				task(json)
			}
		}
	}
	
	func getPictureArr(eventID: String, ending: @escaping (Array<Image>?) -> Void) {
		dataTaskWithRequest(requestEnding: "getImages?eventId=\(eventID)", task: { result in
			
			guard let json = result else {
				ending(nil)
				return
			}
			
			var imageArr = Array<Image>()
			for (_,subJSON):(String, JSON) in json["images"] {
				let image = Image()
				image.uri = subJSON["url"].stringValue
				// add date value
				imageArr.append(image)
			}
			
			ending(imageArr)
			
		})
	}
	
	func getEventDetail(eventID: String, ending: @escaping (Bool) -> Void) {
		dataTaskWithRequest(requestEnding: "getEventInfo?eventId=\(eventID)", task: { result in
			guard let json = result else {
				ending(false)
				return
			}
				ending(json["eventId"].stringValue == eventID)
		})
	}
}
	/*
		func uploadImageData(img: UIImage, eventID: String, ending: @escaping (Bool) -> Void) {
			let imageData = UIImagePNGRepresentation(img)!
			
		
			let headers = [
				"Encoding-Type": "multipart/form-data",
				"Content-Type": "image/jpeg"
			]

	}
			/*
			
			let URL = try! URLRequest(url: apiURL + "uploadImage?eventId=\(eventID)", method: .post, headers: headers)
			
			
			Alamofire.upload(
				multipartFormData: { multipartFormData in
					
				},
				to: apiURL + "uploadImage?eventId=\(eventID)",
				encodingCompletion: { encodingResult in
					switch encodingResult {
					case .success(let upload, _, _):
						upload.responseJSON { response in
							debugPrint(response)
							ending
						}
					case .failure(let encodingError):
						print(encodingError)
					}
				}
			)/*
			
			/*
			
			Alamofire.upload(multipartFormData: { multipartFormData in
				},to: URL, encodingCompletion: { encodingResult in
								switch encodingResult {
								case .success(let upload, _, _):
									upload.responseJSON { response in
										debugPrint(response)
										ending(true) // fix this - may not be true
									}
								case .failure(let encodingError):
									print(encodingError)
					}
			})

		}
		
		
		*/
		



	}

	}*/*/*/
