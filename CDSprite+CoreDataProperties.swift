//
//  CDSprite+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData


extension CDSprite {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSprite> {
    return NSFetchRequest<CDSprite>(entityName: "CDSprite")
  }
  
  @NSManaged public var imageData: Data?
  @NSManaged public var isFemale: Bool
  @NSManaged public var cdName: String?
  @NSManaged public var cdUrlString: String?
  @NSManaged public var pokemon: CDPokemon?
  
}
