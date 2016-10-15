//
//  Model.swift
//  imghost
//
//  Created by Max Greenwald on 10/15/16.
//
//

import RealmSwift

// Event model
class Event: Object {
	dynamic var external_id = ""
	dynamic var name = ""
	dynamic var desc = ""
	dynamic var eventImage = ""
	dynamic var created: NSDate?
	
	override static func primaryKey() -> String? {
		return "external_id"
	}
}

// Image model
class Image: Object {
	dynamic var uri = ""
	dynamic var event: Event?
	dynamic var created: NSDate?
}
