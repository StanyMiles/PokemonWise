//
//  CDStat+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

extension CDStat {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStat> {
    return NSFetchRequest<CDStat>(entityName: "CDStat")
  }
  
  @NSManaged public var name: String
  @NSManaged public var effort: Int16
  @NSManaged public var baseStat: Int16
  @NSManaged public var pokemon: CDPokemon?
  
}
