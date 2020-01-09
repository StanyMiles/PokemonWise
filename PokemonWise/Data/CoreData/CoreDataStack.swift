//
//  CoreDataStack.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import CoreData

class CoreDataStack {
  
  // MARK: - Properties
  
  /// Storing NSManagedObjectModel here, because during tests
  /// it gets loaded multiple times per application launch and CoreData doesn't like that
  private static var loadedManagedObjectModel: NSManagedObjectModel?
  
  let modelName: String
  let persistentStoreType: String
  
  private var persistentStoreURL: URL {
    let storeName = "\(modelName).sqlite"
    let fileManager = FileManager.default
    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0]
    return documentsDirectoryURL.appendingPathComponent(storeName)
  }
  
  private lazy var managedObjectModel: NSManagedObjectModel? = {
    if let model = Self.loadedManagedObjectModel {
      return model
    }
    guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
      return nil
    }
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
    Self.loadedManagedObjectModel = managedObjectModel
    return managedObjectModel
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    guard let managedObjectModel = managedObjectModel else { return nil }
    
    let persistentStoreURL = self.persistentStoreURL
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
      let options = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
      ]
      try persistentStoreCoordinator.addPersistentStore(
        ofType: persistentStoreType,
        configurationName: nil,
        at: persistentStoreURL,
        options: options)
      
    } catch {
      #if DEBUG
      let addPersistentStoreError = error as NSError
      print("Unable to Add Persistent Store \n", addPersistentStoreError.localizedDescription)
      #endif
    }
    
    return persistentStoreCoordinator
  }()
  
  private lazy var privateManagedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
  }()
  
  public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.parent = self.privateManagedObjectContext
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
  }()
  
  // MARK: - Initializer
  
  init(
    modelName: String = "PokemonWise",
    persistentStoreType: String = NSSQLiteStoreType
  ) {
    self.modelName = modelName
    self.persistentStoreType = persistentStoreType
  }
  
  // MARK: - Funcs
  
  public func makePrivateChildContext() -> NSManagedObjectContext {
    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateContext.parent = mainManagedObjectContext
    privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return privateContext
  }
  
  public func saveChanges() {
    mainManagedObjectContext.performAndWait {
      do {
        if self.mainManagedObjectContext.hasChanges {
          try self.mainManagedObjectContext.save()
        }
      } catch {
        #if DEBUG
        let saveError = error as NSError
        print("Unable to Save Changes of Main Managed Object Context")
        print("\(saveError), \(saveError.localizedDescription)")
        #endif
      }
    }
    
    privateManagedObjectContext.perform {
      do {
        if self.privateManagedObjectContext.hasChanges {
          try self.privateManagedObjectContext.save()
        }
      } catch {
        #if DEBUG
        let saveError = error as NSError
        print("Unable to Save Changes of Private Managed Object Context")
        print("\(saveError), \(saveError.localizedDescription)")
        #endif
      }
    }
  }
}
