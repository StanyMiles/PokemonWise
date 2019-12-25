//
//  CDPokemon+CoreDataProperties.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

extension CDPokemon {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPokemon> {
    return NSFetchRequest<CDPokemon>(entityName: "CDPokemon")
  }
  
  @NSManaged public var id: Int16
  @NSManaged public var name: String
  @NSManaged public var baseExperience: Int16
  @NSManaged public var height: Int16
  @NSManaged public var weight: Int16
  @NSManaged public var species: String
  @NSManaged public var urlString: String
  @NSManaged public var abilities: NSSet?
  @NSManaged public var moves: NSSet?
  @NSManaged public var sprites: NSSet?
  @NSManaged public var stats: NSSet?
  @NSManaged public var types: NSSet?
  
}

// MARK: Generated accessors for abilities
extension CDPokemon {
  
  @objc(addAbilitiesObject:)
  @NSManaged public func addToAbilities(_ value: CDAbility)
  
  @objc(removeAbilitiesObject:)
  @NSManaged public func removeFromAbilities(_ value: CDAbility)
  
  @objc(addAbilities:)
  @NSManaged public func addToAbilities(_ values: NSSet)
  
  @objc(removeAbilities:)
  @NSManaged public func removeFromAbilities(_ values: NSSet)
  
}

// MARK: Generated accessors for moves
extension CDPokemon {
  
  @objc(addMovesObject:)
  @NSManaged public func addToMoves(_ value: CDMove)
  
  @objc(removeMovesObject:)
  @NSManaged public func removeFromMoves(_ value: CDMove)
  
  @objc(addMoves:)
  @NSManaged public func addToMoves(_ values: NSSet)
  
  @objc(removeMoves:)
  @NSManaged public func removeFromMoves(_ values: NSSet)
  
}

// MARK: Generated accessors for sprites
extension CDPokemon {
  
  @objc(addSpritesObject:)
  @NSManaged public func addToSprites(_ value: CDSprite)
  
  @objc(removeSpritesObject:)
  @NSManaged public func removeFromSprites(_ value: CDSprite)
  
  @objc(addSprites:)
  @NSManaged public func addToSprites(_ values: NSSet)
  
  @objc(removeSprites:)
  @NSManaged public func removeFromSprites(_ values: NSSet)
  
}

// MARK: Generated accessors for stats
extension CDPokemon {
  
  @objc(addStatsObject:)
  @NSManaged public func addToStats(_ value: CDStat)
  
  @objc(removeStatsObject:)
  @NSManaged public func removeFromStats(_ value: CDStat)
  
  @objc(addStats:)
  @NSManaged public func addToStats(_ values: NSSet)
  
  @objc(removeStats:)
  @NSManaged public func removeFromStats(_ values: NSSet)
  
}

// MARK: Generated accessors for types
extension CDPokemon {
  
  @objc(addTypesObject:)
  @NSManaged public func addToTypes(_ value: CDType)
  
  @objc(removeTypesObject:)
  @NSManaged public func removeFromTypes(_ value: CDType)
  
  @objc(addTypes:)
  @NSManaged public func addToTypes(_ values: NSSet)
  
  @objc(removeTypes:)
  @NSManaged public func removeFromTypes(_ values: NSSet)
  
}
