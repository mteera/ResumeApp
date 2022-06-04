//
//  Info+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//
//

import Foundation
import CoreData


extension Info {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Info> {
        return NSFetchRequest<Info>(entityName: "Info")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var number: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var resume: Resume?

}

extension Info : Identifiable {

}
