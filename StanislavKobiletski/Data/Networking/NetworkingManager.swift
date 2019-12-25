//
//  NetworkingManager.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

class NetworkingManager {
  
  private typealias NetworkResponse = (data: Data?, response: URLResponse?, error: Swift.Error?)
  
  // MARK: - Properties
  
  private let urlSession: URLSessionProtocol
  
  private let baseUrlString = "https://pokeapi.co/api/v2/pokemon/"
  private var task: URLSessionTask?
  
  // MARK: - Initializer
  
  init(urlSession: URLSessionProtocol = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  // MARK: - Funcs
  
  func requestPokemons(
    forPage page: Int,
    limit: Int,
    completion: @escaping (Result<NamedAPIResourceList, Error>) -> Void
  ) {
    assert(page > 0, "Pages must start with 1")
    
    let offset = (page - 1) * limit
    
    let queryItems = [
      URLQueryItem(name: "offset", value: String(offset)),
      URLQueryItem(name: "limit", value: String(limit)),
    ]
    
    var urlComponents = URLComponents(string: baseUrlString)
    urlComponents?.queryItems = queryItems
    
    guard let url = urlComponents?.url else {
      completion(.failure(.damagedURL))
      return
    }
    
    task = urlSession.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        
        do {
          let pokemon = try JSONDecoder().decode(NamedAPIResourceList.self,
                                                 from: data)
          completion(.success(pokemon))
        } catch {
          completion(.failure(.unableToDecode))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    task?.resume()
  }
  
  func requestPokemon(
    withURLString urlString: String,
    completion: @escaping (Result<JSONPokemon, Error>) -> Void
  ) {
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.damagedURL))
      return
    }
    
    task = urlSession.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
        
        do {
          let pokemon = try JSONDecoder().decode(JSONPokemon.self,
                                                 from: data)
          completion(.success(pokemon))
        } catch {
          completion(.failure(.unableToDecode))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    task?.resume()
  }
  
  func requestData(
    forImageUrl urlString: String,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.damagedURL))
      return
    }
    
    task = urlSession.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }
      
      let result = self.getData(from: (data, response, error))
      
      switch result {
      case .success(let data):
          completion(.success(data))
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    task?.resume()
  }
  
  func cancel() {
    task?.cancel()
  }
}

// MARK: - Helpers

extension NetworkingManager {

  private func handleNetworkResponse(_ response: HTTPURLResponse) -> Error? {
    switch response.statusCode {
    case 200...299: return nil
    case 401...500: return .authenticationError
    case 501...599: return .badRequest
    case 600:       return .outdated
    default:        return .failed
    }
  }
  
  private func getData(from response: NetworkResponse) -> Result<Data, Error> {
    
    let (d, r, e) = response
    
    if let error = e {
      return .failure(.internalError(error))
    }
    
    guard let response = r as? HTTPURLResponse else {
      return .failure(.failed)
    }
    
    if let error = self.handleNetworkResponse(response) {
      return .failure(error)
    }
    
    guard let data = d else {
      return .failure(.noData)
    }
    
    return .success(data)
  }
}

// MARK: - Errors

extension NetworkingManager {
  
  enum Error: Swift.Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case internalError(Swift.Error)
    case damagedURL
  }
}
