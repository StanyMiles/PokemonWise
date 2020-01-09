//
//  DataManagerFacade.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class DataManagerFacade {
  
  // MARK: - Properties
  
  static let shared = DataManagerFacade(
    coreDataClient: CoreDataClient(),
    networkingClient: .shared,
    imageClient: .shared)
  
  let coreDataClient: CoreDataClient
  let networkingClient: NetworkingClient
  let imageClient: ImageClient
  
  // MARK: - Initializer
  
  init(
    coreDataClient: CoreDataClient,
    networkingClient: NetworkingClient,
    imageClient: ImageClient
  ) {
    self.coreDataClient = coreDataClient
    self.networkingClient = networkingClient
    self.imageClient = imageClient
  }
  
  // MARK: - Funcs
  
  /// Requests data from Server, on failure or missing requests data locally.
  /// If data is loaded from Server, saves it locally with overwrite previously stored.
  /// - Parameters:
  ///   - page: Index of requesting page
  ///   - limit: Limit of items to return per page
  func requestPokemons(
    forPage page: Int,
    limit: Int = 20,
    completion: @escaping (Result<[PokemonListItem], Error>) -> Void
  ) throws -> URLSessionDataTask {

    let dataTask = try requestPokemonsFromServerAndSaveLocallyOnSuccess(
      forPage: page,
      limit: limit
    ) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
      case .success(let pokemonListItems):
        completion(.success(pokemonListItems))
        
      case .failure:
        self.requestPokemonsFromCoreData(
          forPage: page,
          limit: limit,
          completion: completion)
      }
    }
    
    return dataTask
  }
  
  /// Requests data from Server, on failure or missing requests data locally.
  /// If data is loaded from Server, saves it locally with overwrite previously stored.
  /// - Parameters:
  ///   - urlString: URL to download remotely.
  ///   Unique for each pokemon, and is used to request data locally
  func requestPokemon(
    withURL url: URL,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) -> URLSessionDataTask {

    let dataTask = requestPokemonFromServer(
      withUrl: url
    ) { [weak self] result in
      guard let self = self else { return }

      switch result {
        
      case .success(let pokemon):
        completion(.success(pokemon))
        
      case .failure:
        self.requestPokemonFromCoreData(
          withURLString: url.absoluteString,
          completion: completion)
      }
    }
    
    return dataTask
  }
  
  /// Requests data from Server, on failure or missing requests data locally.
  /// If data is loaded from Server, saves it locally with overwrite previously stored.
  /// - Parameters:
  ///   - urlString: URL to load data.
  ///   Unique for each image, is used to request single CDSprite object to store data locally.
//  func requestImageData(
//    forURL url: URL,
//    completion: @escaping (Result<UIImage, Error>) -> Void
//  ) -> URLSessionDataTask {
//
//    let dataTask = imageClient.downloadImage(
//      fromURL: url
//    ) { [weak self] result in
//
//      guard let self = self else { return }
//
//      switch result {
//      case .success(let image):
//        completion(.success(image))
//
//        self.saveLocally(
//          imageData: image.pngData()!,
//          forUrlString: url.absoluteString)
//
//      case .failure:
//        DispatchQueue.main.async {
//
//          self.requestSpriteDataFromCoreData(
//            withURLString: url.absoluteString,
//            completion: completion)
//        }
//      }
//    }
//  }
}

// MARK: - Private funcs

extension DataManagerFacade {
  
  private func requestPokemonsFromServerAndSaveLocallyOnSuccess(
    forPage page: Int,
    limit: Int,
    completion: @escaping (Result<[PokemonListItem], Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    let dataTask =  try networkingClient.requestPokemons(
      page: page,
      limit: limit
    ) { [weak self] result in
      
      guard let self = self else { return }
      
      switch result {
      case .success(let pokemonListItems):
        
        let pokemons = pokemonListItems.map { PokemonListItem($0) }
        completion(.success(pokemons))
        
        #warning("test for save locally")
        let startIndex = Int16((page - 1) * limit)
        self.saveLocally(
          pokemonListItems: pokemonListItems,
          startIndex: startIndex)
        
        #if DEBUG
        print("Received Pokemons for page \(page) from Server")
        #endif
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    return dataTask
  }

  private func requestPokemonFromServer(
    withUrl url: URL,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) -> URLSessionDataTask {
    
    let dataTask = networkingClient.requestSinglePokemon(with: url) { result in

      switch result {
      case .success(let jsonPokemon):

        let pokemon = Pokemon(jsonPokemon)
        completion(.success(pokemon))

        #if DEBUG
        print("Received '\(pokemon.name)' from Server")
        #endif

        self.saveLocally(
          jsonPokemon: jsonPokemon,
          urlString: url.absoluteString)

      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    return dataTask
  }

  private func requestPokemonsFromCoreData(
    forPage page: Int,
    limit: Int,
    completion: @escaping (Result<[PokemonListItem], Error>) -> Void
  ) {

    do {
      let pokemonListItems = try coreDataClient.requestPokemonListItems(
        forPage: page,
        limit: limit)
      
      let pokemons = pokemonListItems.map { PokemonListItem($0) }
      completion(.success(pokemons))
      
    } catch {
      completion(.failure(error))
    }
  }

  private func requestPokemonFromCoreData(
    withURLString urlString: String,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) {

    do {
      let cdPokemon = try coreDataClient.requestPokemon(withUrlString: urlString)
      let pokemon = Pokemon(cdPokemon)
      completion(.success(pokemon))

      #if DEBUG
      print("Received '\(pokemon.name)' from CoreData")
      #endif

    } catch {
      completion(.failure(error))
    }
  }

  private func requestSpriteImageDataFromCoreData(
    withURLString urlString: String,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    
    do {
      let sprite = try coreDataClient.requestSprite(withUrlString: urlString)

      guard let data = sprite.imageData else {
        completion(.failure(CoreDataClient.Error.noData))
        return
      }

      completion(.success(data))

    } catch {
      completion(.failure(error))
    }
  }

  private func saveLocally(
    pokemonListItems: [NamedAPIResource],
    startIndex: Int16
  ) {
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      
      let privateContext = self.coreDataClient.stack.makePrivateChildContext()
      privateContext.perform { [weak self] in
        guard let self = self else { return }
      
        self.coreDataClient.save(
          pokemonListItems,
          startIndex: startIndex,
          context: privateContext)
      }
    }
  }

  private func saveLocally(
    jsonPokemon: JSONPokemon,
    urlString: String
  ) {
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      
      let privateContext = self.coreDataClient.stack.makePrivateChildContext()
      privateContext.perform { [weak self] in
        guard let self = self else { return }
        
        self.coreDataClient.save(
          jsonPokemon,
          urlString: urlString,
          in: privateContext)
      }
    }
  }

  private func saveLocally(
    imageData: Data,
    forUrlString urlString: String
  ) {
    DispatchQueue.global().async { [weak self] in
      guard let self = self else { return }
      
      let privateContext = self.coreDataClient.stack.makePrivateChildContext()
      privateContext.perform { [weak self] in
        guard let self = self else { return }
        
        self.coreDataClient.save(
          imageData,
          fromUrlString: urlString,
          in: privateContext)
      }
    }
  }
  
}
