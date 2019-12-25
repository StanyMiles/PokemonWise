//
//  PokemonMove.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension Pokemon {
  
  struct Move {
    let name: String
    
    init(_ move: JSONPokemonMove) {
      name = move.move.name
    }
    
    init(_ move: CDMove) {
      name = move.name
    }
  }
}
