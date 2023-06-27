//
//  PostData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 27/06/2023.
//
//

import Foundation
import CoreData


extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var address: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var longitude: Int16
    @NSManaged public var latitude: Int16
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isPin: Bool

}

extension PostData : Identifiable {

}
