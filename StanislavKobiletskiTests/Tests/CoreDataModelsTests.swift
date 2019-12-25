//
//  CoreDataModelsTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class CoreDataModelsTests: XCTestCase {
  
  // MARK: - Properties
  
  var stack: CoreDataStack!
  
  // MARK: - Tests Lifecycle
  
  override func setUp() {
    super.setUp()
    stack = CoreDataStack(persistentStoreType: NSInMemoryStoreType)
  }
  
  override func tearDown() {
    stack = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func testPokemonInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSinglePokemonMockData()
    let urlString = "http://test-url.ee"
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    
    let pokemon = CDPokemon.initialize(with: jsonPokemon,
                                       urlString: urlString,
                                       in: context)
    
    XCTAssert(pokemon.id == 10, "Wrong id")
    XCTAssert(pokemon.name == "caterpie", "Wrong name")
    XCTAssert(pokemon.species == "caterpie", "Wrong species")
    XCTAssert(pokemon.weight == 29, "Wrong weight")
    XCTAssert(pokemon.height == 3, "Wrong height")
    XCTAssert(pokemon.baseExperience == 39, "Wrong baseExperience")
    XCTAssert(pokemon.formattedStats.count == 6, "Wrong stats count")
    XCTAssert(pokemon.formattedSprites.count == 4, "Wrong sprites count")
    XCTAssert(pokemon.formattedAbilities.count == 2, "Wrong abilities count")
    XCTAssert(pokemon.formattedMoves.count == 5, "Wrong moves count")
    XCTAssert(pokemon.formattedTypes.count == 1, "Wrong types count")
    XCTAssert(pokemon.urlString == urlString, "Wrong urlString")
  }
  
  func testAbilityInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getAbilityMockData()
    let jsonAbility = try! JSONDecoder().decode(JSONPokemonAbility.self, from: data)
    
    let ability = CDAbility.initialize(with: jsonAbility, in: context)
    
    XCTAssert(ability.name == "run-away", "Wrong ability name")
    XCTAssert(ability.isHidden == true, "Wrong ability isHidden parameter")
    XCTAssert(ability.slot == 3, "Wrong ability slot")
  }
  
  func testTypeInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getTypeMockData()
    let jsonType = try! JSONDecoder().decode(JSONPokemonType.self, from: data)
    
    let type = CDType.initialize(with: jsonType, in: context)
    
    XCTAssert(type.slot == 1, "Wrong type slot")
    XCTAssert(type.name == "bug", "Wrong type name")
  }
  
  func testMoveInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getMoveMockData()
    let jsonMove = try! JSONDecoder().decode(JSONPokemonMove.self, from: data)
    
    let move = CDMove.initialize(with: jsonMove, in: context)
    
    XCTAssert(move.name == "tackle", "Wrong type name")
  }
  
  func testStatInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getStatMockData()
    let jsonStat = try! JSONDecoder().decode(JSONPokemonStat.self, from: data)
    
    let stat = CDStat.initialize(with: jsonStat, in: context)
    
    XCTAssert(stat.name == "speed", "Wrong stat name")
    XCTAssert(stat.baseStat == 45, "Wrong stat baseStat")
    XCTAssert(stat.effort == 0, "Wrong stat effore")
  }
  
  func testSpritesInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSpritesMockData()
    let jsonSprites = try! JSONDecoder().decode(JSONPokemonSprites.self, from: data)
    
    let sprites = CDSprite.initialize(with: jsonSprites, in: context)
    
    let names = sprites.map { $0.name }
    let expectedNames: [Pokemon.Sprite.Name] = [.back, .backShiny, .front, .frontShiny]
    let rawNames = expectedNames.map { $0.rawValue }
    
    XCTAssert(names.sorted() == rawNames.sorted(), "Wrong sprite names")
  }
  
  func testListItemInitialized() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getNamedAPIResourceMockData()
    let position: Int16 = 1
    let apiResource = try! JSONDecoder().decode(NamedAPIResource.self, from: data)
    
    let listItem = CDListItem.initialize(with: apiResource, position: position, in: context)
    
    XCTAssert(listItem.name == "bulbasaur", "Wrong name")
    XCTAssert(listItem.urlString == "https://pokeapi.co/api/v2/pokemon/1/", "Wrong urlString")
    XCTAssert(listItem.position == position, "Wrong position")
  }
}
