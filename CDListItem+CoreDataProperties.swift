//
//  CDListItem+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

extension CDListItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDListItem> {
    return NSFetchRequest<CDListItem>(entityName: "CDListItem")
  }
  
  @NSManaged public var name: String
  @NSManaged public var urlString: String
  @NSManaged public var position: Int16
  
}
