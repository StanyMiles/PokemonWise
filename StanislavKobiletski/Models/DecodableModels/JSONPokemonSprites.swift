//
//  JSONPokemonSprites.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct JSONPokemonSprites {
  let frontDefault: String?
  let frontShiny: String?
  let frontFemale: String?
  let frontShinyFemale: String?
  let backDefault: String?
  let backShiny: String?
  let backFemale: String?
  let backShinyFemale: String?
}

extension JSONPokemonSprites: Decodable {
  enum CodingKeys: String, CodingKey {
    case frontDefault     = "front_default"
    case frontShiny       = "front_shiny"
    case frontFemale      = "front_female"
    case frontShinyFemale = "front_shiny_female"
    case backDefault      = "back_default"
    case backShiny        = "back_shiny"
    case backFemale       = "back_female"
    case backShinyFemale  = "back_shiny_female"
  }
}
