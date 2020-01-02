//
//  NetworkingClient.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 02.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct NetworkingClient {
  
  // MARK: - Properties
  
  let baseURL: URL
  let session: URLSession
  let responseQueue: DispatchQueue?
  
  // MARK: - Funcs
  
  func requestPokemons(
    page: Int,
    limit: Int,
    completion: @escaping (Result<[NamedAPIResource], Swift.Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    guard page > 0 else {
      throw Error.incorrectPage
    }
    
    let offset = (page - 1) * limit
    
    let queryItems = [
      URLQueryItem(name: Keys.offset, value: String(offset)),
      URLQueryItem(name: Keys.limit, value: String(limit)),
    ]
    
    var urlComponents = URLComponents(
      url: baseURL,
      resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = queryItems
    
    #warning("Test for broken URL")
    let getPokemonsURL = urlComponents!.url!
    
    let dataTask = session.dataTask(
      with: getPokemonsURL
    ) { data, response, error in
      
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          self.dispatchResult(
            .failure(Error.badResponse),
            completion: completion)
          return
      }
      
      if let error = error {
        self.dispatchResult(
          .failure(error),
          completion: completion)
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(Error.noData),
          completion: completion)
        return
      }
      
      let decoder = JSONDecoder()
      do {
        let apiResponse = try decoder.decode(
          NamedAPIResourceList.self,
          from: data)
        let pokemons = apiResponse.results

        self.dispatchResult(
          .success(pokemons),
          completion: completion)
        
      } catch {
        
        self.dispatchResult(
          .failure(error),
          completion: completion)
      }
    }
    
    dataTask.resume()
    
    return dataTask
  }
  
  func requestSinglePokemon(
    with url: URL,
    completion: @escaping (Result<JSONPokemon, Swift.Error>) -> Void
  ) -> URLSessionDataTask {
    
    let dataTask = session.dataTask(
      with: url
    ) { data, response, error in
      
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          self.dispatchResult(
            .failure(Error.badResponse),
            completion: completion)
          return
      }
      
      if let error = error {
        self.dispatchResult(
          .failure(error),
          completion: completion)
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(Error.noData),
          completion: completion)
        return
      }
      
      let decoder = JSONDecoder()
      do {
        let pokemon = try decoder.decode(
          JSONPokemon.self,
          from: data)
        self.dispatchResult(
          .success(pokemon),
          completion: completion)
        
      } catch {
        
        self.dispatchResult(
          .failure(error),
          completion: completion)
      }
    }
    
    dataTask.resume()
    
    return dataTask
  }
    
  // MARK: - Helpers
  
  private func dispatchResult<Type>(
    _ result: Result<Type, Swift.Error>,
    completion: @escaping (Result<Type, Swift.Error>) -> Void
  ) {

    guard let responseQueue = self.responseQueue else {
      completion(result)
      return
    }
    responseQueue.async {
      completion(result)
    }
  }
}

// MARK: - Keys

extension NetworkingClient {
  
  enum Keys {
    static let offset = "offset"
    static let limit = "limit"
  }
}

// MARK: - Error

extension NetworkingClient {

  enum Error: Swift.Error {
    case incorrectPage
    case badResponse
    case noData
  }
}
