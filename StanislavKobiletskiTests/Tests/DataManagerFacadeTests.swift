//
//  DataManagerFacadeTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 25.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import CoreData
@testable import PokemonWise

class DataManagerFacadeTests: XCTestCase {
  
  // MARK: - System Under Testing
  
  var sut: DataManagerFacade!
  var stack: CoreDataStack!
  var coreDataManager: CoreDataManager!
  
  // MARK: - Tests Lifecycle
  
  override func setUp() {
    super.setUp()
    stack = CoreDataStack(persistentStoreType: NSInMemoryStoreType)
    coreDataManager = CoreDataManager(stack: stack)
  }
  
  override func tearDown() {
    sut = nil
    coreDataManager = nil
    stack = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func testRequestingPokemonsWithInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    session.testData = MockData().getPokemonsMockData()
    let networkingManager = NetworkingManager(urlSession: session)
    let page = 1
    let expectation = XCTestExpectation(description: "Download requested pokemons")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestPokemons(forPage: page) { result in
      switch result {
      case .success(let pokemonItems):
        
        if pokemonItems.count == 20 {
          expectation.fulfill()
        } else {
          XCTFail("Wrong number of pokemons downloaded")
        }
        
      case .failure:
        XCTFail("Failed to download pokemons with network")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestingPokemonsWithoutInternetFail() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let page = 1
    let expectation = XCTestExpectation(description: "Download requested pokemons fails")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestPokemons(forPage: page) { result in
      switch result {
      case .success(let pokemonItems):
        
        if pokemonItems.count == 0 {
          expectation.fulfill()
        } else {
          XCTFail("Wrong number of pokemons downloaded")
        }
        
      case .failure:
        XCTFail("Failed to download pokemons with network")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestingPokemonsWithoutInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let page = 1
    let expectation = XCTestExpectation(description: "Download requested pokemons")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    let context = stack.mainManagedObjectContext
    let data = MockData().getPokemonsMockData()
    let list = try! JSONDecoder().decode(NamedAPIResourceList.self, from: data)
    let items = list.results
    coreDataManager.save(
      pokemonListItems: items,
      startIndex: 0,
      in: context)
    
    sut.requestPokemons(forPage: page) { result in
      switch result {
      case .success(let pokemonItems):
        
        if pokemonItems.count == 20 {
          expectation.fulfill()
        } else {
          XCTFail("Wrong number of pokemons downloaded")
        }
        
      case .failure:
        XCTFail("Failed to load pokemons")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestSinglePokemonWithInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    let data = MockData().getSinglePokemonMockData()
    session.testData = data
    let networkingManager = NetworkingManager(urlSession: session)
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested pokemon")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success(let pokemon):
        
        if pokemon.id == jsonPokemon.id {
          expectation.fulfill()
        } else {
          XCTFail("Wrong pokemon downloaded")
        }
        
      case .failure:
        XCTFail("Failed to download pokemons with network")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestSinglePokemonWithoutInternetFail() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested pokemon fails")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success:
        XCTFail("Pokemon should not be downloaded")
        
      case .failure:
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestSinglePokemonWithoutInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested pokemon")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    let data = MockData().getSinglePokemonMockData()
    let jsonPokemon = try! JSONDecoder().decode(JSONPokemon.self, from: data)
    let context = stack.mainManagedObjectContext
    coreDataManager.save(
      jsonPokemon: jsonPokemon,
      urlString: urlString,
      in: context)
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success(let pokemon):
        
        if pokemon.id == jsonPokemon.id {
          expectation.fulfill()
        } else {
          XCTFail("Wrong pokemon downloaded")
        }
        
      case .failure:
        XCTFail("Failed to load pokemons")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestImageDataWithInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    session.testData = MockData().getImageData()
    let networkingManager = NetworkingManager(urlSession: session)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested image data")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestImageData(forURLString: urlString) { result in
      switch result {
      case .success:
        expectation.fulfill()
        
      case .failure:
        XCTFail("Failed to download image data with network")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestImageDataWithoutInternetFail() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested image data fails")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    
    sut.requestImageData(forURLString: urlString) { result in
      switch result {
      case .success:
        XCTFail("Image data should not be downloaded")
        
      case .failure:
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testRequestImageDataWithoutInternetSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    let networkingManager = NetworkingManager(urlSession: session)
    let urlString = "http://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested image data")
    sut = DataManagerFacade(coreDataManager: coreDataManager, networkManager: networkingManager)
    let context = stack.mainManagedObjectContext
    let imageData = MockData().getImageData()
    let sprite = CDSprite(context: context)
    sprite.imageData = imageData
    sprite.name = "Name"
    sprite.urlString = urlString
    
    sut.requestImageData(forURLString: urlString) { result in
      switch result {
      case .success:
        expectation.fulfill()
        
      case .failure:
        XCTFail("Failed to download image data")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
}
