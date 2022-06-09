//
//  Education+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 8/6/22.
//
//

import Foundation
import CoreData


extension Education {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Education> {
        return NSFetchRequest<Education>(entityName: "Education")
    }

    @NSManaged public var degree: String?
    @NSManaged public var gpa: Double
    @NSManaged public var passYear: Int16
    @NSManaged public var resume: Resume?

}

extension Education : Identifiable {

}
