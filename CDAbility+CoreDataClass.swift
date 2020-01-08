//
//  CDAbility+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDAbility: NSManagedObject {
  
  // MARK: - Properties
  
  var name: String {
    get { cdName ?? "no name" }
    set { cdName = newValue }
  }
  
  // MARK: - Funcs
  
  static func initialize(
    with ability: JSONPokemonAbility,
    in context: NSManagedObjectContext
  ) -> CDAbility {
    
    let newAbility      = CDAbility(context: context)
    newAbility.name     = ability.ability.name
    newAbility.isHidden = ability.isHidden
    newAbility.slot     = Int16(ability.slot)
    return newAbility
  }
}

// MARK: - Comparable

extension CDAbility: Comparable {
  
  public static func < (lhs: CDAbility, rhs: CDAbility) -> Bool {
    lhs.slot < rhs.slot
  }
}
