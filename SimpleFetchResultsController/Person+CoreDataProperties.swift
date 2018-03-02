//
//  Person+CoreDataProperties.swift
//  SimpleFetchResultsController
//
//  Created by Mazharul Huq on 3/1/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
