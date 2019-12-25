//
//  CDType+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDType: NSManagedObject {

  static func initialize(
    with type: JSONPokemonType,
    in context: NSManagedObjectContext
  ) -> CDType {
    
    let newType      = CDType(context: context)
    newType.name     = type.type.name
    newType.slot     = Int16(type.slot)
    return newType
  }
}

// MARK: - Comparable

extension CDType: Comparable {
  
  public static func < (lhs: CDType, rhs: CDType) -> Bool {
    lhs.slot < rhs.slot
  }
}
