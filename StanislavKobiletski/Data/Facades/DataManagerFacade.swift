//
//  DataManagerFacade.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

class DataManagerFacade {
  
  // MARK: - Properties
  
  private let coreDataManager: CoreDataManager
  private let networkManager: NetworkingManager
  
  // MARK: - Initializer
  
  init(
    coreDataManager: CoreDataManager = CoreDataManager(),
    networkManager: NetworkingManager = NetworkingManager()
  ) {
    self.coreDataManager = coreDataManager
    self.networkManager = networkManager
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
  ) {
    assert(page > 0, "Pages must start with 1")
    
    requestPokemonsFromServer(
      forPage: page,
      limit: limit
    ) { [weak self] result in

      guard let self = self else { return }

      DispatchQueue.main.async {

        switch result {
        case .success(let pokemonListItems):
          completion(.success(pokemonListItems))

        case .failure:
          self.requestPokemonsFromCoreData(forPage: page, completion: completion)
        }
      }
    }
  }
  
  /// Requests data from Server, on failure or missing requests data locally.
  /// If data is loaded from Server, saves it locally with overwrite previously stored.
  /// - Parameters:
  ///   - urlString: URL to download remotely.
  ///   Unique for each pokemon, and is used to request data locally
  func requestPokemon(
    withURLString urlString: String,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) {
    
    requestPokemonFromServer(
      withUrlString: urlString
    ) { [weak self] result in

      guard let self = self else { return }

      DispatchQueue.main.async {

        switch result {

        case .success(let pokemon):
          completion(.success(pokemon))

        case .failure:
          self.requestPokemonFromCoreData(
            withURLString: urlString,
            completion: completion)
        }
      }
    }
  }
  
  /// Requests data from Server, on failure or missing requests data locally.
  /// If data is loaded from Server, saves it locally with overwrite previously stored.
  /// - Parameters:
  ///   - urlString: URL to load data.
  ///   Unique for each image, is used to request single CDSprite object to store data locally.
  func requestImageData(
    forURLString urlString: String,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    
    networkManager.requestData(forImageUrl: urlString) { [weak self] result in
      guard let self = self else {
        print("Object deallocated")
        return }
      
      switch result {
      case .success(let data):
        
        DispatchQueue.main.async {
          completion(.success(data))
        }
        
        self.saveLocally(imageData: data, forURLString: urlString)
        
      case .failure:
        DispatchQueue.main.async {
          
          self.requestSpriteDataFromCoreData(
            withURLString: urlString,
            completion: completion)
        }
      }
    }
  }
}

// MARK: - Private funcs

extension DataManagerFacade {
  
  private func requestPokemonsFromServer(
    forPage page: Int,
    limit: Int,
    completion: @escaping (Result<[PokemonListItem], Error>) -> Void
  ) {
    assert(page > 0, "Pages must start with 1")
    
    networkManager.requestPokemons(
      forPage: page,
      limit: limit
    ) { result in
        
      switch result {
      case .success(let namedResourceList):
        
        let pokemonListItems = namedResourceList.results.map { PokemonListItem($0) }
        completion(.success(pokemonListItems))
        
        #if DEBUG
        print("Received Pokemons for page \(page) from Server")
        #endif
        
        let startIndex = (page - 1) * limit
        
        self.saveLocally(
          pokemonListItems: namedResourceList.results,
          startIndex: startIndex)
          
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func requestPokemonFromServer(
    withUrlString urlString: String,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) {
    networkManager.requestPokemon(withURLString: urlString) { result in
      
      switch result {
      case .success(let jsonPokemon):
        
        let pokemon = Pokemon(jsonPokemon)
        completion(.success(pokemon))
        
        #if DEBUG
        print("Received '\(pokemon.name)' from Server")
        #endif
        
        self.saveLocally(
          jsonPokemon: jsonPokemon,
          urlString: urlString)
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func requestPokemonsFromCoreData(
    forPage page: Int,
    limit: Int = 20,
    completion: @escaping (Result<[PokemonListItem], Error>) -> Void
  ) {
    
    do {
      let cdListItems = try coreDataManager.requestPokemonListItems(forPage: page,
                                                                    limit: limit)
      
      let pokemonListItems = cdListItems.map { PokemonListItem($0) }
      completion(.success(pokemonListItems))
      
      #if DEBUG
      print("Received Pokemons for page \(page) from CoreData")
      #endif
      
    } catch {
      completion(.failure(error))
    }
  }
  
  private func requestPokemonFromCoreData(
    withURLString urlString: String,
    completion: @escaping (Result<Pokemon, Error>) -> Void
  ) {
    
    do {
      let cdPokemon = try coreDataManager.requestPokemon(withURLString: urlString)
      let pokemon = Pokemon(cdPokemon)
      completion(.success(pokemon))
      
      #if DEBUG
      print("Received '\(pokemon.name)' from CoreData")
      #endif
      
    } catch {
      completion(.failure(error))
    }
  }
  
  private func requestSpriteDataFromCoreData(
    withURLString urlString: String,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    do {
      let sprite = try coreDataManager.requestCDSprite(withUrlString: urlString)
      
      guard let data = sprite.imageData else {
        completion(.failure(CoreDataManager.CoreDataError.noData))
        return
      }
      
      completion(.success(data))
      
    } catch {
      completion(.failure(error))
    }
  }
  
  private func saveLocally(
    pokemonListItems: [NamedAPIResource],
    startIndex: Int
  ) {
    let privateContext = coreDataManager.makePrivateChildContext()
    privateContext.perform { [weak self] in
      guard let self = self else { return }
      self.coreDataManager.save(
        pokemonListItems: pokemonListItems,
        startIndex: startIndex,
        in: privateContext)
    }
  }
  
  private func saveLocally(
    jsonPokemon: JSONPokemon,
    urlString: String
  ) {
    let privateContext = coreDataManager.makePrivateChildContext()
    privateContext.perform { [weak self] in
      guard let self = self else { return }
      self.coreDataManager.save(
        jsonPokemon: jsonPokemon,
        urlString: urlString,
        in: privateContext)
    }
  }
  
  private func saveLocally(imageData: Data, forURLString urlString: String) {
    let privateContext = coreDataManager.makePrivateChildContext()
    privateContext.perform { [weak self] in
      guard let self = self else { return }
      self.coreDataManager.save(
        imageData: imageData,
        forURLString: urlString,
        in: privateContext)
    }
  }
  
}
