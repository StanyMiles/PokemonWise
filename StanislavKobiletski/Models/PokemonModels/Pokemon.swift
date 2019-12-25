//
//  Pokemon.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Pokemon {
  let id: Int
  let name: String
  let baseExperience: Int
  let height: Int
  let weight: Int
  let species: String
  let abilities: [Ability]
  let moves: [Move]
  let sprites: [Sprite]
  let stats: [Stat]
  let types: [PokeType]
  
  init(_ pokemon: JSONPokemon) {
    id              = pokemon.id
    name            = pokemon.name
    baseExperience  = pokemon.baseExperience
    height          = pokemon.height
    weight          = pokemon.weight
    species         = pokemon.species.name
    abilities       = pokemon.abilities.map { Ability($0) }
    moves           = pokemon.moves.map { Move($0) }
    sprites         = Sprite.initialize(with: pokemon.sprites)
    stats           = pokemon.stats.map { Stat($0) }
    types           = pokemon.types.map { PokeType($0) }
  }
  
  init(_ pokemon: CDPokemon) {
    id              = Int(pokemon.id)
    name            = pokemon.name
    baseExperience  = Int(pokemon.baseExperience)
    height          = Int(pokemon.height)
    weight          = Int(pokemon.weight)
    species         = pokemon.species
    abilities       = pokemon.formattedAbilities.map { Ability($0) }
    moves           = pokemon.formattedMoves.map { Move($0) }
    sprites         = pokemon.formattedSprites.map { Sprite($0) }
    stats           = pokemon.formattedStats.map { Stat($0) }
    types           = pokemon.formattedTypes.map { PokeType($0) }
  }
}
