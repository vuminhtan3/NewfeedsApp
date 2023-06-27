//
//  ProfileData+CoreDataProperties.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 23/06/2023.
//
//

import Foundation
import CoreData


extension ProfileData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileData> {
        return NSFetchRequest<ProfileData>(entityName: "ProfileData")
    }


}

extension ProfileData : Identifiable {

}
