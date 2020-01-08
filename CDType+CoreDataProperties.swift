//
//  CDType+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData


extension CDType {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDType> {
    return NSFetchRequest<CDType>(entityName: "CDType")
  }
  
  @NSManaged public var cdName: String?
  @NSManaged public var slot: Int16
  @NSManaged public var pokemon: CDPokemon?
  
}
