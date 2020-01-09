//
//  MockNetworkingClient.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
//@testable import PokemonWise
//
//class MockNetworkingClient {
//  let baseURL: URL
//  let session: URLSession
//  let responseQueue: DispatchQueue?
//
//  init(
//    baseURL: URL,
//    session: URLSession,
//    responseQueue: DispatchQueue?
//  ) {
//    self.baseURL = baseURL
//    self.session = session
//    self.responseQueue = responseQueue
//  }
//
//  var data: Data?
//  var error: Error?
//}
//
//extension MockNetworkingClient: NetworkRequestable {
//
//  func requestPokemons(
//    page: Int,
//    limit: Int,
//    completion: @escaping (Result<[NamedAPIResource], Error>) -> Void
//  ) throws -> URLSessionDataTask {
//
//    if let data = data {
//      let decoder = JSONDecoder()
//      do {
//        let resourceList = try decoder.decode(
//          NamedAPIResourceList.self,
//          from: data)
//        let pokemons = resourceList.results
//        completion(.success(pokemons))
//
//      } catch {
//        completion(.failure(error))
//      }
//
//    } else if let error = error {
//      completion(.failure(error))
//
//    } else {
//
//      completion(.failure(NSError()))
//    }
//
//    let mockTask = session.dataTask(
//      with: baseURL
//    ) { _, _, _ in
//
//    } as! MockURLSessionDataTask
//
//    return mockTask
//  }
  
//  func whenRequestPokemonsFromServer(
//    data: Data? = nil,
//    statusCode: Int = 200,
//    error: Error? = nil
//  ) throws -> (calledCompletion: Bool, pokemons: [NamedAPIResource]?, error: Error?) {
//
//    let response = HTTPURLResponse(
//      url: baseURL,
//      statusCode: statusCode,
//      httpVersion: nil,
//      headerFields: nil)
//
//    var calledCompletion = false
//    var receivedPokemons: [NamedAPIResource]?
//    var receivedError: Error?
//
//    let mockTask = try networkingClient.requestPokemons(
//      page: firstPage,
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
  
//}
