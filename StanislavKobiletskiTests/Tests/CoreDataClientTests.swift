//
//  CoreDataClientTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 07.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class CoreDataClientTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: CoreDataClient!
  var stack: CoreDataStack!
  var storeType: String!
  var context: NSManagedObjectContext!
  var pokemonListItems: [NamedAPIResource]!
  var privateContext: NSManagedObjectContext!
  var jsonPokemon: JSONPokemon!
  var pokemonUrlString: String!
  var jsonSprites: JSONPokemonSprites!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    storeType = NSInMemoryStoreType
    stack = CoreDataStack(
      persistentStoreType: storeType)
    sut = CoreDataClient(stack: stack)
    context = stack.mainManagedObjectContext
  }
  
  override func tearDown() {
    sut = nil
    stack = nil
    storeType = nil
    context = nil
    pokemonListItems = nil
    privateContext = nil
    jsonPokemon = nil
    pokemonUrlString = nil
    jsonSprites = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenPrivateContext() {
    privateContext = stack.makePrivateChildContext()
  }
  
  func givenPokemonListItems() throws {
    let data = try Data.fromJSON(fileName: "Pokemons_Response")
    
    let decoder = JSONDecoder()
    let resourceList = try decoder.decode(
      NamedAPIResourceList.self,
      from: data)
    pokemonListItems = resourceList.results
  }
  
  func givenJsonPokemon() throws {
    let data = try Data.fromJSON(fileName: "SinglePokemon_Response")
    let decoder = JSONDecoder()
    jsonPokemon = try decoder.decode(
      JSONPokemon.self,
      from: data)
    pokemonUrlString = "http://example.com"
  }
  
  func givenPokemons() throws {
    let data = try Data.fromJSON(fileName: "Array_Of_Pokemons")
    let decoder = JSONDecoder()
    let jsonPokemons = try decoder.decode(
      [JSONPokemon].self,
      from: data)
    
    let urlString = "http://test-pokemon.ee/"
    
    for (i, pokemon) in jsonPokemons.enumerated() {
      let urlString = urlString + String(i)
      sut.save(
        pokemon,
        urlString: urlString,
        in: context)
    }
    
    try givenJsonPokemon()
    savePokemon(context: context)
  }
  
  func givenSprites() throws {
    let data = try Data.fromJSON(fileName: "sprites")
    let decoder = JSONDecoder()
    jsonSprites = try decoder.decode(
      JSONPokemonSprites.self,
      from: data)
    
    _ = CDSprite.initialize(
      with: jsonSprites,
      in: context)
  }
  
  // MARK: - When
  
  func savePokemonListItems(
    startIndex: Int16 = 0,
    context: NSManagedObjectContext
  ) {
    sut.save(
      pokemonListItems,
      startIndex: startIndex,
      context: context)
  }
  
  func savePokemon(
    context: NSManagedObjectContext
  ) {
    sut.save(
      jsonPokemon,
      urlString: pokemonUrlString,
      in: context)
  }
  
  // MARK: - Then
  
  func fetchCDListItems() throws -> [CDListItem] {
    let fetchRequest: NSFetchRequest<CDListItem> = CDListItem.fetchRequest()
    let listItems = try context.fetch(fetchRequest)
    return listItems
  }
  
  func fetchCDPokemons() throws -> [CDPokemon] {
    let fetchRequest: NSFetchRequest<CDPokemon> = CDPokemon.fetchRequest()
    let pokemons = try context.fetch(fetchRequest)
    return pokemons
  }
  
  // MARK: - Tests
  
  func test_init_setsCoreDataStack() {
    XCTAssertEqual(sut.stack.modelName, "PokemonWise")
    XCTAssertEqual(sut.stack.persistentStoreType, storeType)
  }
  
  func test_init_setsDefaultCoreDataStack() {
    // when
    sut = CoreDataClient()
    
    // then
    XCTAssertEqual(sut.stack.modelName, "PokemonWise")
    XCTAssertEqual(sut.stack.persistentStoreType, NSSQLiteStoreType)
  }
  
  func test_savePokemonListItems_savesData() throws {
    // given
    try givenPokemonListItems()
    
    // when
    savePokemonListItems(context: context)
    
    // then
    let requestedItems = try fetchCDListItems()
    XCTAssertEqual(pokemonListItems.count, requestedItems.count)
  }
  
  func test_savePokemonListItems_savesCorrectPositions() throws {
    // given
    try givenPokemonListItems()
    let startIndex: Int16 = 20
    var expectedPositions: [Int16] = []
    for i in startIndex..<startIndex + Int16(pokemonListItems.count) {
      expectedPositions.append(i)
    }
    
    // when
    savePokemonListItems(
      startIndex: startIndex,
      context: context)
    
    // then
    let requestedItems = try fetchCDListItems()
    let positions = requestedItems
      .map { $0.position }
      .sorted()
    
    XCTAssertEqual(positions, expectedPositions)
  }
  
  func test_savePokemonListItems_mainContextHasNoChanges() throws {
    // given
    try givenPokemonListItems()
    givenPrivateContext()
    let exp = expectation(description: "saved list items")
    var mainContextHasChanges = true
    
    // when
    privateContext.perform {
      self.savePokemonListItems(context: self.privateContext)
      self.context.perform {
        mainContextHasChanges = self.context.hasChanges
        exp.fulfill()
      }
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertFalse(mainContextHasChanges)
  }
  
  func test_savePokemonListItems_privateContextHasNoChanges() throws {
    // given
    try givenPokemonListItems()
    givenPrivateContext()
    let exp = expectation(description: "saved list items")
    var privateContextHasChanges = true
    
    // when
    privateContext.perform {
      self.savePokemonListItems(context: self.privateContext)
      privateContextHasChanges = self.privateContext.hasChanges
      exp.fulfill()
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertFalse(privateContextHasChanges)
  }
  
  #warning("test saving duplicate List Item")
  
  func test_savePokemon_savesData() throws {
    // given
    try givenJsonPokemon()
    
    // when
    savePokemon(context: context)
    let pokemons = try fetchCDPokemons()
    
    // then
    XCTAssertEqual(pokemons.count, 1)
  }
  
  func test_savePokemon_mainContextHasNoChanges() throws {
    // given
    try givenJsonPokemon()
    givenPrivateContext()
    let exp = expectation(description: "saved pokemon")
    var mainContextHasChanges = true
    
    // when
    privateContext.perform {
      self.savePokemon(context: self.privateContext)
      self.context.perform {
        mainContextHasChanges = self.context.hasChanges
        exp.fulfill()
      }
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertFalse(mainContextHasChanges)
  }
  
  func test_savePokemon_privateContextHasNoChanges() throws {
    // given
    try givenJsonPokemon()
    givenPrivateContext()
    let exp = expectation(description: "saved pokemon")
    var privateContextHasChanges = true
    
    // when
    privateContext.perform {
      self.savePokemon(context: self.privateContext)
      privateContextHasChanges = self.privateContext.hasChanges
      exp.fulfill()
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertFalse(privateContextHasChanges)
  }
  #warning("test saving duplicate pokemon")
  #warning("test for saving other duplicate models if needed")
  
//  func test_savePokemon_withSameId_doesNotSaveSecondPokemon() throws {
//    // given
//    try givenJsonPokemon()
//    givenPrivateContext()
//    let exp = expectation(description: "saved pokemons")
//
//    // when
//    privateContext.perform {
//      self.savePokemon(context: self.privateContext)
//      self.savePokemon(context: self.privateContext)
//      exp.fulfill()
//    }
//
//    wait(for: [exp], timeout: 1)
//    let pokemons = try fetchCDPokemons()
//
//    // then
//    XCTAssertEqual(pokemons.count, 1)
//  }
  
  func test_saveImage_givenSprite_savesImageToCorrectSprite() throws {
    // given
    try givenSprites()
    let spriteUrlString = jsonSprites.backDefault!
    givenPrivateContext()
    let imageData = UIImage(named: "pokemon-logo")!.pngData()!
    let exp = expectation(description: "saved image data and requested sprite")
    var expectedImageData: Data?
    
    // when
    privateContext.perform {
      self.sut.save(
        imageData,
        fromUrlString: spriteUrlString,
        in: self.privateContext)
      
      let sprite = try? self.sut.requestSprite(
        withUrlString: spriteUrlString,
        in: self.privateContext)
      expectedImageData = sprite?.imageData
      exp.fulfill()
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertEqual(expectedImageData, imageData)
  }
  
  func test_requestPokemonListItems_fetchesData() throws {
    // given
    try givenPokemonListItems()
    
    // when
    savePokemonListItems(context: context)
    let requestedItems = try sut.requestPokemonListItems(
      forPage: 1,
      limit: 0)
    
    // then
    XCTAssertEqual(requestedItems.count, pokemonListItems.count)
  }
  
  func test_requestPokemonListItems_fetchesWithCorrectLimit() throws {
    // given
    try givenPokemonListItems()
    let limit = 1
    
    // when
    savePokemonListItems(context: context)
    let requestedItems = try sut.requestPokemonListItems(
      forPage: 1,
      limit: limit)
    
    // then
    XCTAssertEqual(requestedItems.count, limit)
  }
  
  func test_requestPokemonListItems_fetchesWithCorrectOffset() throws {
    // given
    try givenPokemonListItems()
    let limit = 5
    let page = 2
    var expectedPositions: [Int16] = []
    let offset = (page - 1) * limit
    for i in offset..<offset + limit {
      expectedPositions.append(Int16(i))
    }
    
    // when
    savePokemonListItems(context: context)
    let requestedItems = try sut.requestPokemonListItems(
      forPage: page,
      limit: limit)
    
    // then
    let positions = requestedItems
      .map { $0.position }
      .sorted()
    XCTAssertEqual(requestedItems.count, limit)
    XCTAssertEqual(positions, expectedPositions)
  }
  
  func test_requestPokemonListItems_resultIsSorted() throws {
    // given
    try givenPokemonListItems()
    let limit = 0
    let page = 1
    
    // when
    savePokemonListItems(context: context)
    let requestedItems = try sut.requestPokemonListItems(
      forPage: page,
      limit: limit)
    let positions = requestedItems.map { $0.position }
    let sortedPosisions = positions.sorted()
    
    // then
    XCTAssertEqual(sortedPosisions, positions)
  }
  
  func test_requestPokemonListItems_givenIncorrectPage_throwsError() {
    // given
    let limit = 0
    let page = 0
    
    // when
    var expectedError: CoreDataClient.Error?
    do {
    _ = try sut.requestPokemonListItems(
      forPage: page,
      limit: limit)
    } catch {
      expectedError = error as? CoreDataClient.Error
    }
    
    // then
    XCTAssertEqual(expectedError, .incorrectPage)
  }
  
  func test_requestPokemonListItems_givenCorrectPage_throwsNoError() {
    // given
    let limit = 0
    let page = 1
    
    // when
    var expectedError: CoreDataClient.Error?
    do {
      _ = try sut.requestPokemonListItems(
        forPage: page,
        limit: limit)
    } catch {
      expectedError = error as? CoreDataClient.Error
    }
    
    // then
    XCTAssertNil(expectedError)
  }
  
  func test_requestPokemon_givenPokemons_fetchesCorrectPokemon() throws {
    // given
    try givenPokemons()
    
    // when
    let pokemon = try sut.requestPokemon(withUrlString: pokemonUrlString)
    
    // then
    XCTAssertEqual(pokemon.id, Int16(jsonPokemon.id))
    XCTAssertEqual(pokemon.urlString, pokemonUrlString)
  }
  
  func test_requestPokemon_givenNoPokemon_throwsError() throws {
    // given
    let urlString = "http://test.ee"
    var expectedError: CoreDataClient.Error?
    
    // when
    do {
      _ = try sut.requestPokemon(withUrlString: urlString)
    } catch {
      expectedError = error as? CoreDataClient.Error
    }
    
    // then
    XCTAssertEqual(expectedError, .noData)
  }
  
  func test_requestSprite_givenSprite_fetchesCorrectSprite() throws {
    // given
    try givenSprites()
    let spriteUrlString = jsonSprites.backDefault!
    
    // when
    let sprite = try sut.requestSprite(withUrlString: spriteUrlString)
    
    // then
    XCTAssertEqual(sprite.urlString, spriteUrlString)
  }
  
  func test_requestSprite_givenSprite_fetchesCorrectSpriteFromPrivateContext() throws {
    // given
    try givenSprites()
    let spriteUrlString = jsonSprites.backDefault!
    givenPrivateContext()
    let exp = expectation(description: "requested sprite")
    var expectedSpriteUrlString: String?
    
    // when
    privateContext.perform {
      let sprite = try? self.sut.requestSprite(
        withUrlString: spriteUrlString,
        in: self.privateContext)
      expectedSpriteUrlString = sprite?.urlString
      exp.fulfill()
    }
    
    // then
    wait(for: [exp], timeout: 1)
    XCTAssertEqual(expectedSpriteUrlString, spriteUrlString)
  }
  
  func test_requestSprite_givenNoSprite_throwsError() throws {
    // given
    var expectedError: CoreDataClient.Error?
    
    // when
    do {
      _ = try sut.requestSprite(withUrlString: "http://test.ee")
    } catch {
      expectedError = error as? CoreDataClient.Error
    }
      
    // then
    XCTAssertEqual(expectedError, .noData)
  }
}
