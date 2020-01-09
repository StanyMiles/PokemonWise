//
//  NetworkRequestable.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 08.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

protocol NetworkRequestable {
  var baseURL: URL { get }
  var session: URLSession { get }
  var responseQueue: DispatchQueue? { get }
  
  func requestPokemons(
    page: Int,
    limit: Int,
    completion: @escaping (Result<[NamedAPIResource], Error>) -> Void
  ) throws -> URLSessionDataTask
  
//  func requestSinglePokemon(
//    with url: URL,
//    completion: @escaping (Result<JSONPokemon, Swift.Error>) -> Void
//  ) -> URLSessionDataTask
}
