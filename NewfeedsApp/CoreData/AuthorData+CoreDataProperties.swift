//
//  AuthorData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 23/06/2023.
//
//

import Foundation
import CoreData


extension AuthorData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthorData> {
        return NSFetchRequest<AuthorData>(entityName: "AuthorData")
    }


}

extension AuthorData : Identifiable {

}
