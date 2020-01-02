//
//  NetworkingClientTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 02.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import PokemonWise

class NetworkingClientTests: XCTestCase {
  
  // MARK: - Properties
  
  var baseURL: URL!
  var mockSession: MockURLSession!
  var sut: NetworkingClient!
  
  let firstPage = 1
  let standardLimit = 20
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    baseURL = URL(string: "https://example.com/api/v1/")!
    mockSession = MockURLSession()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: nil)
  }
  
  override func tearDown() {
    baseURL = nil
    mockSession = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  var getPokemonsURL: URL {
    let offset = (firstPage - 1) * standardLimit
    let queryItems = [
      URLQueryItem(name: NetworkingClient.Keys.offset, value: String(offset)),
      URLQueryItem(name: NetworkingClient.Keys.limit, value: String(standardLimit)),
    ]
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = queryItems
    return urlComponents.url!
  }
  
  let singlePokemonURL = URL(string: "https://example.com/api/v1/pokemon/1/")!
  
  // MARK: - When
  
  @discardableResult
  func whenRequestPokemons(
    page: Int,
    limit: Int
  ) throws -> MockURLSessionDataTask {
    
    let mockTask = try sut.requestPokemons(
      page: page,
      limit: limit
    ) { _ in } as! MockURLSessionDataTask
    return mockTask
  }
  
  @discardableResult
  func whenRequestPokemons() throws -> MockURLSessionDataTask {
    try whenRequestPokemons(
      page: firstPage,
      limit: standardLimit)
  }
  
  func whenRequestPokemons(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) throws -> (calledCompletion: Bool, pokemons: [NamedAPIResource]?, error: Error?) {

    let response = HTTPURLResponse(
      url: getPokemonsURL,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)

    var calledCompletion = false
    var receivedPokemons: [NamedAPIResource]?
    var receivedError: Error?

    let mockTask = try sut.requestPokemons(
      page: firstPage,
      limit: standardLimit
    ) { result in
      
      calledCompletion = true
      
      switch result {
      case .success(let pokemons):
        receivedPokemons = pokemons
      case .failure(let error):
        receivedError = error as NSError?
      }

    } as! MockURLSessionDataTask

    mockTask.completionHandler(data, response, error)
    
    return (calledCompletion, receivedPokemons, receivedError)
  }
  
  func verifyRequestPokemonsDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line
  ) throws {
    
    mockSession.givenDispatchQueue()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main)
    
    let exp = expectation(description: "Completion wasn't called")
    
    // when
    var thread: Thread!
    let mockTask = try sut.requestPokemons(
      page: firstPage,
      limit: standardLimit
    ) { _ in
      
      thread = Thread.current
      exp.fulfill()
      
    } as! MockURLSessionDataTask
    
    let response = HTTPURLResponse(
      url: getPokemonsURL,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)
    
    mockTask.completionHandler(data, response, error)
    
    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  func whenRequestSinglePokemon() -> MockURLSessionDataTask {
    let mockTask = sut.requestSinglePokemon(
      with: singlePokemonURL
    ) { _ in } as! MockURLSessionDataTask
    return mockTask
  }
  
  func whenRequestSinglePokemon(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) -> (calledCompletion: Bool, pokemon: JSONPokemon?, error: Error?) {
    
    let response = HTTPURLResponse(
      url: getPokemonsURL,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)
    
    var calledCompletion = false
    var receivedPokemons: JSONPokemon?
    var receivedError: Error?
    
    let mockTask = sut.requestSinglePokemon(
      with: singlePokemonURL
    ) { result in
      
      calledCompletion = true
      
      switch result {
      case .success(let pokemons):
        receivedPokemons = pokemons
      case .failure(let error):
        receivedError = error as NSError?
      }
      
      } as! MockURLSessionDataTask
    
    mockTask.completionHandler(data, response, error)
    
    return (calledCompletion, receivedPokemons, receivedError)
  }
  
  func verifyRequestSinglePokemonDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line
  ) throws {
    
    mockSession.givenDispatchQueue()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main)
    
    let exp = expectation(description: "Completion wasn't called")
    
    // when
    var thread: Thread!
    let mockTask = sut.requestSinglePokemon(
      with: singlePokemonURL
    ) { _ in
      
      thread = Thread.current
      exp.fulfill()
      
      } as! MockURLSessionDataTask
    
    let response = HTTPURLResponse(
      url: getPokemonsURL,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)
    
    mockTask.completionHandler(data, response, error)
    
    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  // MARK: - Tests
  
  func test_init_sets_baseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_sets_session() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_init_sets_responseQueue() {
    // given
    let responseQueue = DispatchQueue.main
    
    // when
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: responseQueue)
    
    // then
    XCTAssertEqual(responseQueue, sut.responseQueue)
  }
  
  func test_requestPokemons_callsResumeOnTask() throws {
    // when
    let mockTask = try whenRequestPokemons()
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
  
  func test_requestPokemons_callsExpectedURL() throws {
    // when
    let mockTask = try whenRequestPokemons()
    
    // then
    XCTAssertEqual(mockTask.url, getPokemonsURL)
  }
  
  func test_requestPokemons_pageLowerThanOne_ThrowsError() {
    // given
    let incorrectPage = 0
    let expectedError = NetworkingClient.Error.incorrectPage

    // when
    var actualError: NetworkingClient.Error?
    
    do {
      try whenRequestPokemons(
        page: incorrectPage,
        limit: standardLimit)
    } catch {
      actualError = error as? NetworkingClient.Error
    }
    
    // then
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_requestPokemons_correctPage_ThrowsNoError() {
    // when
    var actualError: Error?
    
    do {
      try whenRequestPokemons()
    } catch {
      actualError = error
    }
    
    // then
    XCTAssertNil(actualError)
  }
  
  func test_requestPokemons_givenResponseStatusCode500_callsCompletion() throws {
    // given
    let expectedError = NetworkingClient.Error.badResponse

    // when
    let result = try whenRequestPokemons(statusCode: 500)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemons)
    
    let actualError = try XCTUnwrap(result.error as? NetworkingClient.Error?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_requestPokemons_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.PokemonWise", code: 42)
    
    // when
    let result = try whenRequestPokemons(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemons)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_requestPokemons_givenValidJSON_callsCompletionWithPokemons() throws {
    // given
    let data = try Data.fromJSON(fileName: "Pokemons_Response")
    
    let decoder = JSONDecoder()
    let resourceList = try decoder.decode(
      NamedAPIResourceList.self,
      from: data)
    
    // when
    let result = try whenRequestPokemons(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.error)
    XCTAssertEqual(result.pokemons, resourceList.results)
  }
  
  func test_requestPokemons_givenInvalidJSON_callsCompletionWithError() throws {
    // given
    let data = try Data.fromJSON(fileName: "Pokemons_MissingProperties_Response")
    
    var expectedError: NSError!
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(NamedAPIResourceList.self, from: data)
    } catch {
      expectedError = error as NSError
    }
    
    // when
    let result = try whenRequestPokemons(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemons)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }
  
  func test_requestPokemons_givenNoData_callsCompletionWithError() throws {
    // given
    let expectedError = NetworkingClient.Error.noData
    
    // when
    let result = try whenRequestPokemons(statusCode: 200)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemons)
    
    let actualError = try XCTUnwrap(result.error as? NetworkingClient.Error?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_requestPokemons_givenHTTPStatusError_dispatchesToResponseQueue() throws {
    try verifyRequestPokemonsDispatchedToMain(statusCode: 500)
  }
  
  func test_requestPokemons_givenError_dispatchesToResponseQueue() throws {
    // given
    let error = NSError(domain: "com.PokemonWise", code: 42)
    
    // then
    try verifyRequestPokemonsDispatchedToMain(error: error)
  }
  
  func test_requestPokemons_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "Pokemons_Response")
    
    // then
    try verifyRequestPokemonsDispatchedToMain(data: data)
  }
  
  func test_requestPokemons_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "Pokemons_MissingProperties_Response")
    
    // then
    try verifyRequestPokemonsDispatchedToMain(data: data)
  }
  
  func test_requestPokemons_givenNoData_dispatchesToResponseQueue() throws {
    try verifyRequestPokemonsDispatchedToMain(statusCode: 200)
  }
  
  func test_requestSinglePokemon_callsResumeOnTask() {
    // when
    let mockTask = whenRequestSinglePokemon()
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }

  func test_requestSinglePokemon_callsExpectedURL() {
    // when
    let mockTask = whenRequestSinglePokemon()

    // then
    XCTAssertEqual(mockTask.url, singlePokemonURL)
  }

  func test_requestSinglePokemon_givenResponseStatusCode500_callsCompletion() throws {
    // given
    let expectedError = NetworkingClient.Error.badResponse

    // when
    let result = whenRequestSinglePokemon(statusCode: 500)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemon)

    let actualError = try XCTUnwrap(result.error as? NetworkingClient.Error?)
    XCTAssertEqual(actualError, expectedError)
  }

  func test_requestSinglePokemon_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.PokemonWise", code: 42)

    // when
    let result = whenRequestSinglePokemon(error: expectedError)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemon)

    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }

  func test_requestSinglePokemon_givenValidJSON_callsCompletionWithPokemon() throws {
    // given
    let data = try Data.fromJSON(fileName: "SinglePokemon_Response")

    let decoder = JSONDecoder()
    let pokemon = try decoder.decode(
      JSONPokemon.self,
      from: data)

    // when
    let result = whenRequestSinglePokemon(data: data)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.error)
    XCTAssertEqual(result.pokemon, pokemon)
  }

  func test_requestSinglePokemon_givenInvalidJSON_callsCompletionWithError() throws {
    // given
    let data = try Data.fromJSON(fileName: "SinglePokemon_MissingProperties_Response")

    var expectedError: NSError!
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(JSONPokemon.self, from: data)
    } catch {
      expectedError = error as NSError
    }

    // when
    let result = whenRequestSinglePokemon(data: data)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemon)

    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }

  func test_requestSinglePokemon_givenNoData_callsCompletionWithError() throws {
    // given
    let expectedError = NetworkingClient.Error.noData

    // when
    let result = whenRequestSinglePokemon(statusCode: 200)

    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.pokemon)

    let actualError = try XCTUnwrap(result.error as? NetworkingClient.Error?)
    XCTAssertEqual(actualError, expectedError)
  }

  func test_requestSinglePokemon_givenHTTPStatusError_dispatchesToResponseQueue() throws {
    try verifyRequestSinglePokemonDispatchedToMain(statusCode: 500)
  }

  func test_requestSinglePokemon_givenError_dispatchesToResponseQueue() throws {
    // given
    let error = NSError(domain: "com.PokemonWise", code: 42)

    // then
    try verifyRequestSinglePokemonDispatchedToMain(error: error)
  }

  func test_requestSinglePokemon_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "SinglePokemon_Response")

    // then
    try verifyRequestSinglePokemonDispatchedToMain(data: data)
  }

  func test_requestSinglePokemon_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "SinglePokemon_MissingProperties_Response")

    // then
    try verifyRequestSinglePokemonDispatchedToMain(data: data)
  }

  func test_requestSinglePokemon_givenNoData_dispatchesToResponseQueue() throws {
    try verifyRequestSinglePokemonDispatchedToMain(statusCode: 200)
  }
}
