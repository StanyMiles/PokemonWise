//
//  CDStat+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData


extension CDStat {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStat> {
    return NSFetchRequest<CDStat>(entityName: "CDStat")
  }
  
  @NSManaged public var baseStat: Int16
  @NSManaged public var effort: Int16
  @NSManaged public var cdName: String?
  @NSManaged public var pokemon: CDPokemon?
  
}
