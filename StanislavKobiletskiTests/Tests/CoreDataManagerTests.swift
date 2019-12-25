//
//  CoreDataManagerTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class CoreDataManagerTests: XCTestCase {
 
  // MARK: - Properties
  
  var stack: CoreDataStack!
  var sut: CoreDataManager!
  
  // MARK: - Tests Lyfecycle
  
  override func setUp() {
    super.setUp()
    stack = CoreDataStack(persistentStoreType: NSInMemoryStoreType)
    sut = CoreDataManager(stack: stack)
  }
  
  override func tearDown() {
    sut = nil
    stack = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func testCDListItemsSavingAndRequesting() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getPokemonsMockData()
    let list = try! JSONDecoder().decode(NamedAPIResourceList.self, from: data)
    let items = list.results
    
    sut.save(
      pokemonListItems: items,
      startIndex: 0,
      in: context)
    
    do {
      let cdPokemons = try sut.requestPokemonListItems(forPage: 1, limit: 20)
      XCTAssert(cdPokemons.count == 20, "Wrong number of CDListItems saved")
    } catch {
      XCTFail("Failed to fetch CDListItems from CoreData")
    }
  }
  
  func testCDPokemonSavingAndRequesting() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSinglePokemonMockData()
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    let urlString = "http://test-url.ee"
    
    sut.save(
      jsonPokemon: jsonPokemon,
      urlString: urlString,
      in: context)
    
    do {
      let cdPokemon = try sut.requestPokemon(withURLString: urlString)
      XCTAssert(cdPokemon.urlString == urlString, "Wrong CDPokemon requested from CoreData")
    } catch {
      XCTFail("Failed to fetch CDPokemon from CoreData")
    }
  }
  
  func testCDSpriteRequesting() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSpritesMockData()
    let jsonSprites = try! JSONDecoder().decode(JSONPokemonSprites.self, from: data)
    
    let sprites = CDSprite.initialize(with: jsonSprites, in: context)
    let sprite = sprites.first!
    
    do {
      let cdSprite = try sut.requestCDSprite(withUrlString: sprite.urlString)
      XCTAssert(cdSprite.urlString == sprite.urlString, "Wrong CDSprite requested from CoreData")
    } catch {
      XCTFail("Failed to fetch CDSprite from CoreData")
    }
  }
  
  func testCDSpriteImageDataSaving() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSpritesMockData()
    let jsonSprites = try! JSONDecoder().decode(JSONPokemonSprites.self, from: data)
    let imageData = MockData().getImageData()
    
    let sprites = CDSprite.initialize(with: jsonSprites, in: context)
    let sprite = sprites.first!
    sut.save(imageData: imageData, forURLString: sprite.urlString, in: context)
    
    do {
      let cdSprite = try sut.requestCDSprite(withUrlString: sprite.urlString)
      XCTAssert(cdSprite.imageData == imageData, "Wrong CDSprite imageData in CoreData")
    } catch {
      XCTFail("Failed to fetch CDSprite from CoreData")
    }
  }
}
