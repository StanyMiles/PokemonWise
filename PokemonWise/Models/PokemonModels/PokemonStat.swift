//
//  PokemonStat.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension Pokemon {
  
  struct Stat {
    let name: String
    let effort: Int
    let baseStat: Int
    
    init(_ stat: JSONPokemonStat) {
      name      = stat.stat.name
      effort    = stat.effort
      baseStat  = stat.baseStat
    }
    
    init(_ stat: CDStat) {
      name      = stat.name
      effort    = Int(stat.effort)
      baseStat  = Int(stat.baseStat)
    }
  }
}
