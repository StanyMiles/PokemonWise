//
//  CoreDataClient.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 07.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import CoreData

struct CoreDataClient {
  
  // MARK: - Properties
  
  let stack: CoreDataStack
  
  // MARK: - Initializer
  
  init(stack: CoreDataStack = CoreDataStack()) {
    self.stack = stack
  }
  
  // MARK: - Funcs
  
  func save(
    _ pokemonListItems: [NamedAPIResource],
    startIndex: Int16,
    context: NSManagedObjectContext
  ) {
    
    var position = startIndex
    
    for item in pokemonListItems {
      CDListItem.initialize(
        with: item,
        position: position,
        in: context)
      position += 1
    }
    
    try? context.save()
    self.stack.saveChanges()
  }
  
  func save(
    _ jsonPokemon: JSONPokemon,
    urlString: String,
    in context: NSManagedObjectContext
  ) {
    
    CDPokemon.initialize(
      with: jsonPokemon,
      urlString: urlString,
      in: context)
    
    try? context.save()
    stack.saveChanges()
  }
  
  func save(
    _ imageData: Data,
    fromUrlString urlString: String,
    in context: NSManagedObjectContext
  ) {
    
    guard let sprite = try? requestSprite(
      withUrlString: urlString,
      in: context) else {
        return
    }
    sprite.imageData = imageData
    
    try? context.save()
    stack.saveChanges()
  }
  
  func requestPokemonListItems(
    forPage page: Int,
    limit: Int
  ) throws -> [CDListItem] {
    
    guard page > 0 else {
      throw Error.incorrectPage
    }
    
    let offset = (page - 1) * limit
    
    let fetchRequest: NSFetchRequest<CDListItem> = CDListItem.fetchRequest()
    fetchRequest.fetchOffset = offset
    fetchRequest.fetchLimit = limit
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(
        key: #keyPath(CDListItem.position),
        ascending: true)
    ]
    
    let context = stack.mainManagedObjectContext
    let listItems = try context.fetch(fetchRequest)
    
    return listItems
  }
  
  func requestPokemon(
    withUrlString urlString: String
  ) throws -> CDPokemon {
    
    let fetchRequest: NSFetchRequest<CDPokemon> = CDPokemon.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(
      format: #keyPath(CDPokemon.urlString) + " == %@",
      urlString)
    
    let context = stack.mainManagedObjectContext
    let pokemons = try context.fetch(fetchRequest)
    
    guard let pokemon = pokemons.first else {
      throw Error.noData
    }
    
    return pokemon
  }
  
  func requestSprite(
    withUrlString urlString: String,
    in context: NSManagedObjectContext? = nil
  ) throws -> CDSprite {
    
    let fetchRequest: NSFetchRequest<CDSprite> = CDSprite.fetchRequest()
    fetchRequest.fetchLimit = 1
    fetchRequest.predicate = NSPredicate(
      format: #keyPath(CDSprite.urlString) + " == %@",
      urlString)
    
    let context = context ?? stack.mainManagedObjectContext
    let sprites = try context.fetch(fetchRequest)
    
    guard let sprite = sprites.first else {
      throw Error.noData
    }
    
    return sprite
  }
}

// MARK: - Error

extension CoreDataClient {
  
  enum Error: Swift.Error {
    case incorrectPage
    case noData
  }
}
