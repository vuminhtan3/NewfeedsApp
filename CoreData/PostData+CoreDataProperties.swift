//
//  PostData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 21/06/2023.
//
//

import Foundation
import CoreData


extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var address: String?

}

extension PostData : Identifiable {

}
