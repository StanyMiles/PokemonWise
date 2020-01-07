//
//  CoreDataStackTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 07.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class CoreDataStackTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: CoreDataStack!
  var modelName: String!
  var storeType: String!
  
  // MARK: - Lyfecycle
  
  override func setUp() {
    super.setUp()
    modelName = "PokemonWise"
    storeType = NSInMemoryStoreType
    sut = CoreDataStack(
      modelName: modelName,
      persistentStoreType: storeType)
  }
  
  override func tearDown() {
    sut = nil
    modelName = nil
    storeType = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_init_setsModelName() {
    XCTAssertEqual(sut.modelName, modelName)
  }
  
  func test_init_setsPersistentStoreType() {
    XCTAssertEqual(sut.persistentStoreType, storeType)
  }
  
  func test_init_setsDefaultModelName() {
    // when
    sut = CoreDataStack()
    
    // then
    XCTAssertEqual(sut.modelName, modelName)
  }
  
  func test_init_setsDefaultPersistentStoreType() {
    // when
    sut = CoreDataStack()
    
    // then
    XCTAssertEqual(sut.persistentStoreType, NSSQLiteStoreType)
  }
  
  func test_saveChanged_givenItem_savesMainManagedObjectContext() {
    // given
    let context = sut.mainManagedObjectContext
    let item = CDListItem(context: context)
    item.name = "name"
    item.urlString = "http://example.com"
    
    // when
    sut.saveChanges()
    
    // then
    XCTAssertFalse(context.hasChanges)
  }
  
  func test_saveChanged_givenItemWithEmptyProperties_doesntSaveMainManagedObjectContext() {
    // given
    let context = sut.mainManagedObjectContext
    let _ = CDListItem(context: context)
    
    // when
    sut.saveChanges()
    
    // then
    XCTAssertTrue(context.hasChanges)
  }
}
