//
//  StanislavKobiletskiTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import PokemonWise

class NetworkManagerTests: XCTestCase {
  
  // MARK: - Tests
  
  func testDownloadPokemonsSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    session.testData = MockData().getPokemonsMockData()
    let sut = NetworkingManager(urlSession: session)
    let page = 1
    let limit = 20
    let expectation = XCTestExpectation(description: "Download requested pokemons")
    
    sut.requestPokemons(forPage: page, limit: limit) { result in
      switch result {
      case .success:
        expectation.fulfill()
      case .failure(let err):
        XCTFail("Pokemons are not loaded: \(err)")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadPokemonsFailureNoData() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    let sut = NetworkingManager(urlSession: session)
    let page = 1
    let limit = 20
    let expectation = XCTestExpectation(description: "No data for requested pokemons")
    
    sut.requestPokemons(forPage: page, limit: limit) { result in
      switch result {
      case .success:
        XCTFail("Pokemons should not be loaded")
      case .failure(let err):
        
        switch err {
        case .noData:
          expectation.fulfill()
        default:
          XCTFail("Wrong error on downloading pokemons")
        }
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadPokemonsFailureBadRequest() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    session.testData = MockData().getPokemonsMockData()
    let sut = NetworkingManager(urlSession: session)
    let page = 1
    let limit = 20
    let expectation = XCTestExpectation(description: "No data for requested pokemons")
    
    sut.requestPokemons(forPage: page, limit: limit) { result in
      switch result {
      case .success:
        XCTFail("Pokemons should not be loaded")
      case .failure(let err):
        
        switch err {
        case .badRequest:
          expectation.fulfill()
        default:
          XCTFail("Wrong error on downloading pokemons")
        }
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadPokemonsCallsResume() {
    let session = URLSessionMock()
    let sut = NetworkingManager(urlSession: session)
    let page = 1
    let limit = 20
    let expextation = XCTestExpectation(description: "Testing task triggers resume()")
    
    sut.requestPokemons(forPage: page, limit: limit) { result in
      XCTAssertTrue(session.dataTask?.resumeWasCalled ?? false)
      expextation.fulfill()
    }
    
    wait(for: [expextation], timeout: 5)
  }
  
  // MARK: - Downloading single Pokemon
  
  func testDownloadSinglePokemonSuccess() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    session.testData = MockData().getSinglePokemonMockData()
    let sut = NetworkingManager(urlSession: session)
    let urlString = "https://test-url.ee"
    let expectation = XCTestExpectation(description: "Download requested pokemons")
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success:
        expectation.fulfill()
      case .failure(let err):
        XCTFail("Pokemons are not loaded: \(err)")
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadSinglePokemonFailureNoData() {
    let session = URLSessionDataMock()
    session.response = MockData().successResponse
    let sut = NetworkingManager(urlSession: session)
    let urlString = "https://test-url.ee"
    let expectation = XCTestExpectation(description: "No data for requested pokemons")
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success:
        XCTFail("Pokemons should not be loaded")
      case .failure(let err):
        
        switch err {
        case .noData:
          expectation.fulfill()
        default:
          XCTFail("Wrong error on downloading pokemons")
        }
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadSinglePokemonFailureBadRequest() {
    let session = URLSessionDataMock()
    session.response = MockData().failureResponse
    session.testData = MockData().getSinglePokemonMockData()
    let sut = NetworkingManager(urlSession: session)
    let urlString = "https://test-url.ee"
    let expectation = XCTestExpectation(description: "No data for requested pokemons")
    
    sut.requestPokemon(withURLString: urlString) { result in
      switch result {
      case .success:
        XCTFail("Pokemons should not be loaded")
      case .failure(let err):
        
        switch err {
        case .badRequest:
          expectation.fulfill()
        default:
          XCTFail("Wrong error on downloading pokemons")
        }
      }
    }
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDownloadSinglePokemonCallsResume() {
    let session = URLSessionMock()
    let sut = NetworkingManager(urlSession: session)
    let urlString = "https://test-url.ee"
    let expextation = XCTestExpectation(description: "Testing task triggers resume()")
    
    sut.requestPokemon(withURLString: urlString) { result in
      XCTAssertTrue(session.dataTask?.resumeWasCalled ?? false)
      expextation.fulfill()
    }
    
    wait(for: [expextation], timeout: 5)
  }
  
}
