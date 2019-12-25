//
//  ModelsTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class ModelsTests: XCTestCase {
  
  var stack: CoreDataStack!
  
  override func setUp() {
    super.setUp()
    stack = CoreDataStack(persistentStoreType: NSInMemoryStoreType)
  }
  
  override func tearDown() {
    stack = nil
    super.tearDown()
  }
  
  // MARK: - Initialization with CoreDataModels
  
  func testPokemonInitializedWithCDPokemon() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSinglePokemonMockData()
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    let cdPokemon = CDPokemon.initialize(with: jsonPokemon,
                                         urlString: "",
                                         in: context)
    
    let pokemon = Pokemon(cdPokemon)
    
    XCTAssert(pokemon.id == 10, "Wrong id")
    XCTAssert(pokemon.name == "caterpie", "Wrong name")
    XCTAssert(pokemon.species == "caterpie", "Wrong species")
    XCTAssert(pokemon.weight == 29, "Wrong weight")
    XCTAssert(pokemon.height == 3, "Wrong height")
    XCTAssert(pokemon.baseExperience == 39, "Wrong baseExperience")
    XCTAssert(pokemon.stats.count == 6, "Wrong stats count")
    XCTAssert(pokemon.sprites.count == 4, "Wrong sprites count")
    XCTAssert(pokemon.abilities.count == 2, "Wrong abilities count")
    XCTAssert(pokemon.moves.count == 5, "Wrong moves count")
    XCTAssert(pokemon.types.count == 1, "Wrong types count")
  }
  
  func testAbilityInitializedWithCDAbility() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getAbilityMockData()
    let jsonAbility = try! JSONDecoder().decode(JSONPokemonAbility.self, from: data)
    let cdAbility = CDAbility.initialize(with: jsonAbility, in: context)
    
    let ability = Pokemon.Ability(cdAbility)
    
    XCTAssert(ability.name == "run-away", "Wrong ability name")
    XCTAssert(ability.isHidden == true, "Wrong ability isHidden parameter")
    XCTAssert(ability.slot == 3, "Wrong ability slot")
  }
  
  func testTypeInitializedWithCDType() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getTypeMockData()
    let jsonType = try! JSONDecoder().decode(JSONPokemonType.self, from: data)
    let cdType = CDType.initialize(with: jsonType, in: context)
    
    let type = Pokemon.PokeType(cdType)
    
    XCTAssert(type.slot == 1, "Wrong type slot")
    XCTAssert(type.name == "bug", "Wrong type name")
  }
  
  func testMoveInitializedWithCDMove() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getMoveMockData()
    let jsonMove = try! JSONDecoder().decode(JSONPokemonMove.self, from: data)
    let cdMove = CDMove.initialize(with: jsonMove, in: context)
    
    let move = Pokemon.Move(cdMove)
    
    XCTAssert(move.name == "tackle", "Wrong type name")
  }
  
  func testStatInitializedWithCDStat() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getStatMockData()
    let jsonStat = try! JSONDecoder().decode(JSONPokemonStat.self, from: data)
    let cdStat = CDStat.initialize(with: jsonStat, in: context)
    
    let stat = Pokemon.Stat(cdStat)
    
    XCTAssert(stat.name == "speed", "Wrong stat name")
    XCTAssert(stat.baseStat == 45, "Wrong stat baseStat")
    XCTAssert(stat.effort == 0, "Wrong stat effore")
  }
  
  func testSpritesInitializedWithCDSprites() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getSpritesMockData()
    let jsonSprites = try! JSONDecoder().decode(JSONPokemonSprites.self, from: data)
    let cdSprites = CDSprite.initialize(with: jsonSprites, in: context)
    
    let sprites = cdSprites.map { Pokemon.Sprite($0) }
    
    let names = sprites.map { $0.name }
    let expectedNames: [Pokemon.Sprite.Name] = [.back, .backShiny, .front, .frontShiny]
    let rawNames = expectedNames.map { $0.rawValue }
    
    XCTAssert(names.sorted() == rawNames.sorted(), "Wrong sprite names")
  }
  
  func testPokemonListItemInitializedWithCDListItem() {
    let context = stack.mainManagedObjectContext
    let data = MockData().getNamedAPIResourceMockData()
    let position: Int16 = 1
    let apiResource = try! JSONDecoder().decode(NamedAPIResource.self, from: data)
    let cdListItem = CDListItem.initialize(with: apiResource, position: position, in: context)
    
    let listItem = PokemonListItem(cdListItem)
    
    XCTAssert(listItem.name == "bulbasaur", "Wrong name")
    XCTAssert(listItem.urlString == "https://pokeapi.co/api/v2/pokemon/1/", "Wrong urlString")
  }
  
  // MARK: - Initialization with JSONModels
  
  func testPokemonInitializedWithJSONPokemon() {
    let data = MockData().getSinglePokemonMockData()
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    
    let pokemon = Pokemon(jsonPokemon)
    
    XCTAssert(pokemon.id == 10, "Wrong id")
    XCTAssert(pokemon.name == "caterpie", "Wrong name")
    XCTAssert(pokemon.species == "caterpie", "Wrong species")
    XCTAssert(pokemon.weight == 29, "Wrong weight")
    XCTAssert(pokemon.height == 3, "Wrong height")
    XCTAssert(pokemon.baseExperience == 39, "Wrong baseExperience")
    XCTAssert(pokemon.stats.count == 6, "Wrong stats count")
    XCTAssert(pokemon.sprites.count == 4, "Wrong sprites count")
    XCTAssert(pokemon.abilities.count == 2, "Wrong abilities count")
    XCTAssert(pokemon.moves.count == 5, "Wrong moves count")
    XCTAssert(pokemon.types.count == 1, "Wrong types count")
  }
  
  func testAbilityInitializedWithJSONAbility() {
    let data = MockData().getAbilityMockData()
    let jsonAbility = try! JSONDecoder().decode(JSONPokemonAbility.self, from: data)
    
    let ability = Pokemon.Ability(jsonAbility)
    
    XCTAssert(ability.name == "run-away", "Wrong ability name")
    XCTAssert(ability.isHidden == true, "Wrong ability isHidden parameter")
    XCTAssert(ability.slot == 3, "Wrong ability slot")
  }
  
  func testTypeInitializedWithJSONType() {
    let data = MockData().getTypeMockData()
    let jsonType = try! JSONDecoder().decode(JSONPokemonType.self, from: data)
    
    let type = Pokemon.PokeType(jsonType)
    
    XCTAssert(type.slot == 1, "Wrong type slot")
    XCTAssert(type.name == "bug", "Wrong type name")
  }
  
  func testMoveInitializedWithJSONMove() {
    let data = MockData().getMoveMockData()
    let jsonMove = try! JSONDecoder().decode(JSONPokemonMove.self, from: data)
    
    let move = Pokemon.Move(jsonMove)
    
    XCTAssert(move.name == "tackle", "Wrong type name")
  }
  
  func testStatInitializedWithJSONStat() {
    let data = MockData().getStatMockData()
    let jsonStat = try! JSONDecoder().decode(JSONPokemonStat.self, from: data)
    
    let stat = Pokemon.Stat(jsonStat)
    
    XCTAssert(stat.name == "speed", "Wrong stat name")
    XCTAssert(stat.baseStat == 45, "Wrong stat baseStat")
    XCTAssert(stat.effort == 0, "Wrong stat effore")
  }
  
  func testSpritesInitializedWithJSONSprites() {
    let data = MockData().getSpritesMockData()
    let jsonSprites = try! JSONDecoder().decode(JSONPokemonSprites.self, from: data)
    
    let sprites = Pokemon.Sprite.initialize(with: jsonSprites)
    
    let names = sprites.map { $0.name }
    let expectedNames: [Pokemon.Sprite.Name] = [.back, .backShiny, .front, .frontShiny]
    let rawNames = expectedNames.map { $0.rawValue }
    
    XCTAssert(names.sorted() == rawNames.sorted(), "Wrong sprite names")
  }
  
  func testPokemonListItemInitializedWithNamedAPIResource() {
    let data = MockData().getNamedAPIResourceMockData()
    let apiResource = try! JSONDecoder().decode(NamedAPIResource.self, from: data)
    
    let listItem = PokemonListItem(apiResource)
    
    XCTAssert(listItem.name == "bulbasaur", "Wrong name")
    XCTAssert(listItem.urlString == "https://pokeapi.co/api/v2/pokemon/1/", "Wrong urlString")
  }
}
