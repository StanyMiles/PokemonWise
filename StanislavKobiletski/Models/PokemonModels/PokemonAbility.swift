//
//  PokemonAbility.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension Pokemon {
  
  struct Ability {
    let name: String
    let isHidden: Bool
    let slot: Int
    
    init(_ ability: JSONPokemonAbility) {
      name      = ability.ability.name
      isHidden  = ability.isHidden
      slot      = ability.slot
    }
    
    init(_ ability: CDAbility) {
      name      = ability.name
      isHidden  = ability.isHidden
      slot      = Int(ability.slot)
    }
  }
}
