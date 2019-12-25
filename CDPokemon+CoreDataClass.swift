//
//  CDPokemon+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDPokemon: NSManagedObject {
  
  // MARK: - Properties
  
  var formattedAbilities: [CDAbility] {
    let abilities = self.abilities?.allObjects as? [CDAbility]
    return abilities?.sorted() ?? []
  }
  
  var formattedMoves: [CDMove] {
    let moves = self.moves?.allObjects as? [CDMove]
    return moves?.sorted() ?? []
  }

  var formattedSprites: [CDSprite] {
    let sprites = self.sprites?.allObjects as? [CDSprite]
    return sprites ?? []
  }
  
  var formattedStats: [CDStat] {
    let stats = self.stats?.allObjects as? [CDStat]
    return stats?.sorted() ?? []
  }
  
  var formattedTypes: [CDType] {
    let types = self.types?.allObjects as? [CDType]
    return types?.sorted() ?? []
  }
  
  // MARK: - Funcs
  
  @discardableResult
  static func initialize(
    with pokemon: JSONPokemon,
    urlString: String,
    in context: NSManagedObjectContext
  ) -> CDPokemon {
    
    let newPokemon            = CDPokemon(context: context)
    newPokemon.id             = Int16(pokemon.id)
    newPokemon.name           = pokemon.name
    newPokemon.baseExperience = Int16(pokemon.baseExperience)
    newPokemon.height         = Int16(pokemon.height)
    newPokemon.weight         = Int16(pokemon.weight)
    newPokemon.species        = pokemon.species.name
    newPokemon.urlString      = urlString
    
    let abilities = pokemon.abilities
      .map { CDAbility.initialize(with: $0, in: context) }
    let abilitiesSet = NSSet(array: abilities)
    newPokemon.addToAbilities(abilitiesSet)
    
    let moves = pokemon.moves
      .map { CDMove.initialize(with: $0, in: context) }
    let movesSet = NSSet(array: moves)
    newPokemon.addToMoves(movesSet)
    
    let sprites = CDSprite.initialize(
      with: pokemon.sprites,
      in: context)
    let spritesSet = NSSet(array: sprites)
    newPokemon.addToSprites(spritesSet)
    
    let stats = pokemon.stats
      .map { CDStat.initialize(with: $0, in: context) }
    let statsSet = NSSet(array: stats)
    newPokemon.addToStats(statsSet)
    
    let types = pokemon.types
      .map { CDType.initialize(with: $0, in: context) }
    let typesSet = NSSet(array: types)
    newPokemon.addToTypes(typesSet)
    
    return newPokemon
  }
  
}
