//
//  Resume+CoreDataProperties.swift
//  ResumeApp
//
//  Created by mongkol.teera on 8/6/22.
//
//

import Foundation
import CoreData


extension Resume {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Resume> {
        return NSFetchRequest<Resume>(entityName: "Resume")
    }

    @NSManaged public var objective: String?
    @NSManaged public var skills: [String]?
    @NSManaged public var title: String?
    @NSManaged public var education: NSSet?
    @NSManaged public var info: Info?
    @NSManaged public var projects: NSSet?
    @NSManaged public var work: NSSet?

}

// MARK: Generated accessors for education
extension Resume {

    @objc(addEducationObject:)
    @NSManaged public func addToEducation(_ value: Education)

    @objc(removeEducationObject:)
    @NSManaged public func removeFromEducation(_ value: Education)

    @objc(addEducation:)
    @NSManaged public func addToEducation(_ values: NSSet)

    @objc(removeEducation:)
    @NSManaged public func removeFromEducation(_ values: NSSet)

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

// MARK: Generated accessors for work
extension Resume {

    @objc(addWorkObject:)
    @NSManaged public func addToWork(_ value: Work)

    @objc(removeWorkObject:)
    @NSManaged public func removeFromWork(_ value: Work)

    @objc(addWork:)
    @NSManaged public func addToWork(_ values: NSSet)

    @objc(removeWork:)
    @NSManaged public func removeFromWork(_ values: NSSet)

}

extension Resume : Identifiable {

}
