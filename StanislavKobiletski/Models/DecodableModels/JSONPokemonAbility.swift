//
//  JSONPokemonAbility.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct JSONPokemonAbility {
  let isHidden: Bool
  let slot: Int
  let ability: NamedAPIResource
}

extension JSONPokemonAbility: Decodable {
  enum CodingKeys: String, CodingKey {
    case isHidden = "is_hidden"
    case slot
    case ability
  }
}
