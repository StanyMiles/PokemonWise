//
//  PokemonType.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension Pokemon {
  
  struct PokeType {
    let name: String
    let slot: Int
    
    init(_ type: JSONPokemonType) {
      name = type.type.name
      slot = type.slot
    }
    
    init(_ type: CDType) {
      name = type.name
      slot = Int(type.slot)
    }
  }
}
