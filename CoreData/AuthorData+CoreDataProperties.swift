//
//  AuthorData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 21/06/2023.
//
//

import Foundation
import CoreData


extension AuthorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthorData> {
        return NSFetchRequest<AuthorData>(entityName: "AuthorData")
    }

    @NSManaged public var username: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var id: String?
    @NSManaged public var isAdmin: String?
    @NSManaged public var profile: ProfileData?

}

extension AuthorData : Identifiable {

}
