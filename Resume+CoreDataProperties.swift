//
//  Resume+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 4/6/22.
//
//

import Foundation
import CoreData


extension Resume {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Resume> {
        return NSFetchRequest<Resume>(entityName: "Resume")
    }

    @NSManaged public var title: String?
    @NSManaged public var objective: String?
    @NSManaged public var skills: [String]?
    @NSManaged public var info: Info?
    @NSManaged public var projects: NSSet?
    @NSManaged public var education: Education?

}

// MARK: Generated accessors for projects
extension Resume {

    @objc(addProjectsObject:)
    @NSManaged public func addToProjects(_ value: Project)

    @objc(removeProjectsObject:)
    @NSManaged public func removeFromProjects(_ value: Project)

    @objc(addProjects:)
    @NSManaged public func addToProjects(_ values: NSSet)

    @objc(removeProjects:)
    @NSManaged public func removeFromProjects(_ values: NSSet)

}

extension Resume : Identifiable {

}
