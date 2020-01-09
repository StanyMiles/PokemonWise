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
  
  // MARK: - Properties
  
//  var sut: DataManagerFacade!
//  var stack: CoreDataStack!
//  var coreDataClient: CoreDataClient!
//  var baseURL: URL!
//  var mockSession: MockURLSession!
//  var mockNetworkingClient: NetworkingClient!
//  var expectedPokemons: [PokemonListItem]!
//  var expectedError: Error!
//  var pokemonsExpectation: XCTestExpectation!
//
//  // MARK: - Lifecycle
//
//  override func setUp() {
//    super.setUp()
//    stack = CoreDataStack(persistentStoreType: NSInMemoryStoreType)
//    coreDataClient = CoreDataClient(stack: stack)
//    baseURL = URL(string: "https://example.com/api/v1/")!
//    mockSession = MockURLSession()
//    mockNetworkingClient = NetworkingClient(
//      baseURL: baseURL,
//      session: mockSession,
//      responseQueue: .main)
//    sut = DataManagerFacade(
//      coreDataClient: coreDataClient,
//      networkingClient: mockNetworkingClient)
//  }
//
//  override func tearDown() {
//    sut = nil
//    coreDataClient = nil
//    stack = nil
//    mockNetworkingClient = nil
//    baseURL = nil
//    mockSession = nil
//    expectedPokemons = nil
//    expectedError = nil
//    pokemonsExpectation = nil
//    super.tearDown()
//  }
//
//  // MARK: - Given
//
//  let firstPage = 1
//  let standardLimit = 20
//
//  func givenPokemonListItemsInCoreData() throws {
//    let data = try Data.fromJSON(fileName: "Pokemons_Response")
//
//    let decoder = JSONDecoder()
//    let resourceList = try decoder.decode(
//      NamedAPIResourceList.self,
//      from: data)
//    let pokemonListItems = resourceList.results
//
//    coreDataClient.save(
//      pokemonListItems,
//      startIndex: 0,
//      context: stack.mainManagedObjectContext)
//  }
//
//  // MARK: - Given
//
//  func givenPokemonsExpectation() {
//    pokemonsExpectation = expectation(description: "requested pokemons")
//  }
//
//  // MARK: - When
//
//  func whenRequestPokemons(
//    forPage page: Int = 1,
//    limit: Int = 20
//  ) throws {
//    _ = try sut.requestPokemons(
//      forPage: page,
//      limit: limit
//    ) { result in
//      switch result {
//      case .success(let pokemons):
//        self.expectedPokemons = pokemons
//      case .failure(let error):
//        self.expectedError = error
//      }
//
//      self.pokemonsExpectation.fulfill()
//    }
//  }
//
//  func whenRequestPokemons(
//    data: Data? = nil,
//    statusCode: Int = 200,
//    error: Error? = nil
//  ) throws -> (calledCompletion: Bool, pokemons: [PokemonListItem]?, error: Error?) {
//
//    let response = HTTPURLResponse(
//      url: baseURL,
//      statusCode: statusCode,
//      httpVersion: nil,
//      headerFields: nil)
//
//    var calledCompletion = false
//    var receivedPokemons: [PokemonListItem]?
//    var receivedError: Error?
//
//    let mockTask = try sut.requestPokemons(
//      forPage: firstPage,
//      limit: standardLimit
//    ) { result in
//
//      calledCompletion = true
//
//      switch result {
//      case .success(let pokemons):
//        receivedPokemons = pokemons
//      case .failure(let error):
//        receivedError = error as NSError?
//      }
//
//      } as! MockURLSessionDataTask
//
//    mockTask.completionHandler(data, response, error)
//
//    return (calledCompletion, receivedPokemons, receivedError)
//  }
//
//  // MARK: - Tests
//
//  func test_shared_setsSharedNetworkingClient() {
//    // given
//    sut = DataManagerFacade.shared
//
//    // then
//    XCTAssertEqual(sut.networkingClient.responseQueue, .main)
//    XCTAssertEqual(sut.networkingClient.session, .shared)
//  }
//
//  func test_shared_setsDefaultCoreDataClient() {
//    // given
//    sut = DataManagerFacade.shared
//
//    // then
//    XCTAssertEqual(sut.coreDataClient.stack.persistentStoreType, NSSQLiteStoreType)
//  }
//
//  func test_init_setsCoreDataClient() {
//    XCTAssertEqual(sut.coreDataClient.stack.modelName, stack.modelName)
//  }
//
//  func test_init_setsNetworkingClient() {
//    XCTAssertEqual(sut.networkingClient.baseURL, baseURL)
//  }
//
//  // - request pokemons
//  // with connection and pokemons returns
//  // without connection with pokemons in coredata returns
//
//
//  func test_requestPokemons_givenNoPokemons_throwsError() throws {
//    // given
//    givenPokemonsExpectation()
//
//    // when
//    try whenRequestPokemons()
//
//    // then
//    wait(for: [pokemonsExpectation], timeout: 1)
//    XCTAssertNotNil(expectedError)
//  }
//
//  func test_requestPokemons_givenPokemonsInCoreData_returnsPokemons() throws {
//    // given
//    try givenPokemonListItemsInCoreData()
//    givenPokemonsExpectation()
//    let expectedCount = 20
//
//    // when
//    try whenRequestPokemons()
//
//    // then
//    wait(for: [pokemonsExpectation], timeout: 1)
//    XCTAssertEqual(expectedPokemons.count, expectedCount)
//  }
//
//  func test_requestPokemons_givenIncorrectPage_throwsError() throws {
//    // given
//    givenPokemonsExpectation()
//    let incorrectPage = 0
//
//    // when
//    try whenRequestPokemons(forPage: incorrectPage)
//
//    // then
//    wait(for: [pokemonsExpectation], timeout: 1)
//    XCTAssertEqual(expectedError as? CoreDataClient.Error, .incorrectPage)
//  }
//
//  func test_requestPokemons_returnsCorrectLimit() throws {
//    // given
//    try givenPokemonListItemsInCoreData()
//    givenPokemonsExpectation()
//    let limit = 2
//
//    // when
//    try whenRequestPokemons(limit: limit)
//
//    // then
//    wait(for: [pokemonsExpectation], timeout: 1)
//    XCTAssertEqual(expectedPokemons.count, limit)
//  }
//
//  func test_resuestPokemons_givenDataFromServer_returnsPokemons() throws {
//    // given
//    let data = try Data.fromJSON(fileName: "Pokemons_Response")
////    givenPokemonsExpectation()
//    let expectedCount = 20
//
//    // when
//    let result = try whenRequestPokemons(data: data)
//
//    // then
////    wait(for: [pokemonsExpectation], timeout: 1)
//    XCTAssertEqual(result.pokemons?.count, expectedCount)
//  }
//
//  func test_resuestPokemons_givenErrorAtRequestingFromServer_throwsError() throws {
//    // given
//    let error = NSError(domain: "com.test", code: 42)
//
//    // when
//    let result = try whenRequestPokemons(error: error)
//
//    // then
//    XCTAssertNotNil(result.error)
//  }
}
