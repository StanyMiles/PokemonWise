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
  var context: NSManagedObjectContext!
  var privateContext: NSManagedObjectContext!
  
  // MARK: - Lyfecycle
  
  override func setUp() {
    super.setUp()
    modelName = "PokemonWise"
    storeType = NSInMemoryStoreType
    sut = CoreDataStack(
      modelName: modelName,
      persistentStoreType: storeType)
    context = sut.mainManagedObjectContext
  }
  
  override func tearDown() {
    sut = nil
    modelName = nil
    storeType = nil
    context = nil
    privateContext = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenPrivateContext() {
    privateContext = sut.makePrivateChildContext()
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
    let _ = CDListItem(context: context)
    
    // when
    sut.saveChanges()
    
    // then
    XCTAssertTrue(context.hasChanges)
  }
  
  func test_mainManagedObjectContext_concurrencyTypeIsMainQueueConcurrencyType() {
    XCTAssertEqual(context.concurrencyType, .mainQueueConcurrencyType)
  }
  
  func test_makePrivateChildContext_setsMainContextAsParent() {
    // given
    givenPrivateContext()
    
    // then
    XCTAssertEqual(privateContext.parent, context)
  }
  
  func test_makePrivateChildContext_concurrencyTypeIsPrivate() {
    // given
    givenPrivateContext()
    
    // then
    XCTAssertEqual(privateContext.concurrencyType, .privateQueueConcurrencyType)
  }
  
  #warning("test mergePolicy")
  
//  func test_makePrivateChildContext_setsNSMergeByPropertyObjectTrumpMergePolicy() {
//    // given
//    let privateContext = sut.makePrivateChildContext()
//    privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//    // then
//    //    XCTAssertTrue(privateContext.mergePolicy === NSMergeByPropertyObjectTrumpMergePolicy)
//  }
}
