//
//  CDMove+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDMove: NSManagedObject {
  
  static func initialize(
    with move: JSONPokemonMove,
    in context: NSManagedObjectContext
  ) -> CDMove {
    
    let newMove   = CDMove(context: context)
    newMove.name  = move.move.name
    return newMove
  }
}

// MARK: - Comparable

extension CDMove: Comparable {
  
  public static func < (lhs: CDMove, rhs: CDMove) -> Bool {
    lhs.name.compare(rhs.name) == .orderedAscending
  }
}
