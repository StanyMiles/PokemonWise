//
//  CDStat+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDStat: NSManagedObject {

  // MARK: - Proprteies
  
  var name: String {
    get { cdName ?? "no name" }
    set { cdName = newValue }
  }
  
  // MARK: - Funcs
  
  static func initialize(
    with stat: JSONPokemonStat,
    in context: NSManagedObjectContext
  ) -> CDStat {
    
    let newStat      = CDStat(context: context)
    newStat.name     = stat.stat.name
    newStat.effort   = Int16(stat.effort)
    newStat.baseStat = Int16(stat.baseStat)
    return newStat
  }
}

// MARK: - Comparable

extension CDStat: Comparable {
  
  public static func < (lhs: CDStat, rhs: CDStat) -> Bool {
    lhs.name.compare(rhs.name) == .orderedAscending
  }
}
