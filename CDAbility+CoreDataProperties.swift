//
//  CDAbility+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData


extension CDAbility {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAbility> {
    return NSFetchRequest<CDAbility>(entityName: "CDAbility")
  }
  
  @NSManaged public var isHidden: Bool
  @NSManaged public var cdName: String?
  @NSManaged public var slot: Int16
  @NSManaged public var pokemons: NSSet?
  
}

// MARK: Generated accessors for pokemons
extension CDAbility {
  
  @objc(addPokemonsObject:)
  @NSManaged public func addToPokemons(_ value: CDPokemon)
  
  @objc(removePokemonsObject:)
  @NSManaged public func removeFromPokemons(_ value: CDPokemon)
  
  @objc(addPokemons:)
  @NSManaged public func addToPokemons(_ values: NSSet)
  
  @objc(removePokemons:)
  @NSManaged public func removeFromPokemons(_ values: NSSet)
  
}
