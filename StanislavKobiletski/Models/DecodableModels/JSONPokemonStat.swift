//
//  JSONPokemonStat.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct JSONPokemonStat {
  let stat: NamedAPIResource
  let effort: Int
  let baseStat: Int
}

extension JSONPokemonStat: Decodable {
  enum CodingKeys: String, CodingKey {
    case stat
    case effort
    case baseStat = "base_stat"
  }
}
