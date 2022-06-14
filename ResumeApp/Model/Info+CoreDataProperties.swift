//
//  Info+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 14/6/22.
//
//

import Foundation
import CoreData


extension Info {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Info> {
        return NSFetchRequest<Info>(entityName: "Info")
    }

    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var image: Data?
    @NSManaged public var lastName: String?
    @NSManaged public var number: String?
    @NSManaged public var title: String?
    @NSManaged public var resume: Resume?

}

extension Info : Identifiable {

}
