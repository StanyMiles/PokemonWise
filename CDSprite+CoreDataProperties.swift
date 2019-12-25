//
//  CDSprite+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

extension CDSprite {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSprite> {
    return NSFetchRequest<CDSprite>(entityName: "CDSprite")
  }
  
  @NSManaged public var urlString: String
  @NSManaged public var name: String
  @NSManaged public var imageData: Data?
  @NSManaged public var isFemale: Bool
  @NSManaged public var pokemon: CDPokemon?
  
}
