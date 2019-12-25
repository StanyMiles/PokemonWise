//
//  CDType+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

extension CDType {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDType> {
    return NSFetchRequest<CDType>(entityName: "CDType")
  }
  
  @NSManaged public var name: String
  @NSManaged public var slot: Int16
  @NSManaged public var pokemon: CDPokemon?
  
}
