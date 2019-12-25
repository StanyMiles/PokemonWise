//
//  PokemonSprite.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

extension Pokemon {
  
  struct Sprite {
    let name: String
    let urlString: String
    let isFemale: Bool
    var imageData: Data?
    
    init(name: Name,
         urlString: String,
         isFemale: Bool) {
      
      self.name       = name.rawValue
      self.urlString  = urlString
      self.isFemale   = isFemale
    }
    
    init(_ sprite: CDSprite) {
      name      = sprite.name
      urlString = sprite.urlString
      isFemale  = sprite.isFemale
      imageData = sprite.imageData
    }
    
    static func initialize(with sprites: JSONPokemonSprites) -> [Sprite] {
      
      var newSprites: [Sprite] = []
      
      if let frontDefault = sprites.frontDefault {
        let newSprite = Sprite(name: .front,
                               urlString: frontDefault,
                               isFemale: false)
        newSprites.append(newSprite)
      }
      
      if let frontShiny = sprites.frontShiny {
        let newSprite = Sprite(name: .frontShiny,
                               urlString: frontShiny,
                               isFemale: false)
        newSprites.append(newSprite)
      }
      
      if let frontFemale = sprites.frontFemale {
        let newSprite = Sprite(name: .front,
                               urlString: frontFemale,
                               isFemale: true)
        newSprites.append(newSprite)
      }
      
      if let frontShinyFemale = sprites.frontShinyFemale {
        let newSprite = Sprite(name: .frontShiny,
                               urlString: frontShinyFemale,
                               isFemale: true)
        newSprites.append(newSprite)
      }
      
      if let backDefault = sprites.backDefault {
        let newSprite = Sprite(name: .back,
                               urlString: backDefault,
                               isFemale: false)
        newSprites.append(newSprite)
      }
      
      if let backShiny = sprites.backShiny {
        let newSprite = Sprite(name: .backShiny,
                               urlString: backShiny,
                               isFemale: false)
        newSprites.append(newSprite)
      }
      
      if let backFemale = sprites.backFemale {
        let newSprite = Sprite(name: .back,
                               urlString: backFemale,
                               isFemale: true)
        newSprites.append(newSprite)
      }
      
      if let backShinyFemale = sprites.backShinyFemale {
        let newSprite = Sprite(name: .backShiny,
                               urlString: backShinyFemale,
                               isFemale: true)
        newSprites.append(newSprite)
      }
      
      return newSprites
    }
    
  }
}

// MARK: - Sprite Names

extension Pokemon.Sprite {
  
  enum Name: String {
    case front      = "Front"
    case frontShiny = "Front Shiny"
    case back       = "Back"
    case backShiny  = "Back Shiny"
  }
}
