//
//  Note.swift
//  Noty
//
//  Created by Marvin Adademey on 16/01/2017.
//  Copyright © 2017 Marvin Adademey. All rights reserved.
//

import Foundation
import CoreData


@objc(note)

class note: NSManagedObject {

    // Attributes
    @NSManaged var name: String
    @NSManaged var content: String
    @NSManaged var date: String
    @NSManaged var lng: Double
    @NSManaged var lat: Double
    @NSManaged var reminder: Bool
    
}
