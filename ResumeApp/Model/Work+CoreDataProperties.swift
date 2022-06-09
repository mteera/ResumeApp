//
//  Work+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 8/6/22.
//
//

import Foundation
import CoreData


extension Work {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Work> {
        return NSFetchRequest<Work>(entityName: "Work")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var duration: Int16
    @NSManaged public var resume: Resume?

}

extension Work : Identifiable {

}
