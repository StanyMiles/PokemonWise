//
//  CoreDataManager.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import CoreData

struct CoreDataManager {
  
  // MARK: - Properties
  
  let stack: CoreDataStack
  
  // MARK: - Initializer
  
  init(stack: CoreDataStack = CoreDataStack()) {
    self.stack = stack
  }
  
  // MARK:- Funcs
  
  func saveContext() {
    stack.saveChanges()
  }
  
  func makePrivateChildContext() -> NSManagedObjectContext {
    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateContext.parent = stack.mainManagedObjectContext
    privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return privateContext
  }
  
  func requestPokemonListItems(
    forPage page: Int,
    limit: Int
  ) throws -> [CDListItem] {
    
    assert(page > 0, "Pages must start with 1")
    
    let fetchRequest: NSFetchRequest<CDListItem> = CDListItem.fetchRequest()
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(key: #keyPath(CDListItem.position),
                       ascending: true)
    ]
    
    let offset = (page - 1) * limit
    fetchRequest.fetchOffset = offset
    fetchRequest.fetchLimit = limit
    
    let context = stack.mainManagedObjectContext
    let fetchResults = try context.fetch(fetchRequest)
    
    return fetchResults
  }
  
  func requestPokemon(withURLString urlString: String) throws -> CDPokemon {
    
    let fetchRequest: NSFetchRequest<CDPokemon> = CDPokemon.fetchRequest()
    fetchRequest.fetchLimit = 1
    let predicate = NSPredicate(format: #keyPath(CDPokemon.urlString) + " == %@", urlString)
    fetchRequest.predicate = predicate
    
    let context = stack.mainManagedObjectContext
    let fetchResults = try context.fetch(fetchRequest)
    
    guard let cdPokemon = fetchResults.first else {
      throw CoreDataError.noData
    }
    
    return cdPokemon
  }
  
  func requestCDSprite(
    withUrlString urlString: String,
    in context: NSManagedObjectContext? = nil
  ) throws -> CDSprite {
    
    let fetchRequest: NSFetchRequest<CDSprite> = CDSprite.fetchRequest()
    fetchRequest.fetchLimit = 1
    let predicate = NSPredicate(format: #keyPath(CDSprite.urlString) + " == %@", urlString)
    fetchRequest.predicate = predicate
    
    let context = context ?? stack.mainManagedObjectContext
    let fetchResults = try context.fetch(fetchRequest)
    
    guard let cdSprite = fetchResults.first else {
      throw CoreDataError.noData
    }
    
    return cdSprite
  }
  
  func save(
    pokemonListItems: [NamedAPIResource],
    startIndex: Int,
    in context: NSManagedObjectContext
  ) {
    
    var index = Int16(startIndex)
    
    for item in pokemonListItems {
      CDListItem.initialize(
        with: item,
        position: index,
        in: context)
      
      index += 1
    }
    
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      self.stack.saveChanges()
      
    } catch {
      #if DEBUG
      print("Failed to save pokemonListItems:", error)
      #endif
    }
  }
  
  func save(
    jsonPokemon: JSONPokemon,
    urlString: String,
    in context: NSManagedObjectContext
  ) {
    
    CDPokemon.initialize(
      with: jsonPokemon,
      urlString: urlString,
      in: context)
    
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      self.stack.saveChanges()
      
    } catch {
      #if DEBUG
      print("Failed to save pokemon:", error)
      #endif
    }
  }
  
  func save(
    imageData: Data,
    forURLString urlString: String,
    in context: NSManagedObjectContext
  ) {
    
    guard let sprite = try? requestCDSprite(withUrlString: urlString, in: context) else { return }
    sprite.imageData = imageData
    
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      self.stack.saveChanges()
      
    } catch {
      #if DEBUG
      print("Failed to save imageData:", error)
      #endif
    }
  }
}

// MARK: - Errors

extension CoreDataManager {
  
  enum CoreDataError: Error {
    case noData
  }
}
