//
//  ProfileData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 21/06/2023.
//
//

import Foundation
import CoreData


extension ProfileData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileData> {
        return NSFetchRequest<ProfileData>(entityName: "ProfileData")
    }

    @NSManaged public var bio: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var gender: String?
    @NSManaged public var avatar: String?
    @NSManaged public var owner: AuthorData?

}

extension ProfileData : Identifiable {

}
