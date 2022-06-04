//
//  Project+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var name: String?
    @NSManaged public var teamSize: String?
    @NSManaged public var summary: String?
    @NSManaged public var role: String?
    @NSManaged public var resume: Resume?

}

extension Project : Identifiable {

}
