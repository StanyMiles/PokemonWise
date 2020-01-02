//
//  JSONPokemon.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct JSONPokemon {
  let id: Int
  let name: String
  let baseExperience: Int
  let height: Int
  let weight: Int
  let abilities: [JSONPokemonAbility]
  let moves: [JSONPokemonMove]
  let sprites: JSONPokemonSprites
  let species: NamedAPIResource
  let stats: [JSONPokemonStat]
  let types: [JSONPokemonType]
}

// MARK: - Decodable

extension JSONPokemon: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case baseExperience = "base_experience"
    case height
    case weight
    case abilities
    case moves
    case sprites
    case species
    case stats
    case types
  }
}

// MARK: - Equatable

extension JSONPokemon: Equatable {
  
  static func == (lhs: JSONPokemon, rhs: JSONPokemon) -> Bool {
    lhs.id == rhs.id
  }
}
