//
//  CDListItem+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData


extension CDListItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDListItem> {
    return NSFetchRequest<CDListItem>(entityName: "CDListItem")
  }
  
  @NSManaged public var cdName: String?
  @NSManaged public var position: Int16
  @NSManaged public var cdUrlString: String?
  
}
