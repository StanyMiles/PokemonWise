//
//  CDSprite+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDSprite: NSManagedObject {
  
  // MARK: - Proprteies
  
  var name: String {
    get { cdName ?? "no name" }
    set { cdName = newValue }
  }
  
  var urlString: String {
    get { cdUrlString ?? "no url" }
    set { cdUrlString = newValue }
  }
  
  // MARK: - Funcs
  
  static func initialize(
    with sprites: JSONPokemonSprites,
    in context: NSManagedObjectContext
  ) -> [CDSprite] {
    
    var newSprites: [CDSprite] = []
    
    if let frontDefault = sprites.frontDefault {
      
      let newSprite = createSprite(
        withName: .front,
        urlString: frontDefault,
        isFemale: false,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let frontShiny = sprites.frontShiny {
      
      let newSprite = createSprite(
        withName: .frontShiny,
        urlString: frontShiny,
        isFemale: false,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let frontFemale = sprites.frontFemale {
      
      let newSprite = createSprite(
        withName: .front,
        urlString: frontFemale,
        isFemale: true,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let frontShinyFemale = sprites.frontShinyFemale {
      
      let newSprite = createSprite(
        withName: .frontShiny,
        urlString: frontShinyFemale,
        isFemale: true,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let backDefault = sprites.backDefault {
      
      let newSprite = createSprite(
        withName: .back,
        urlString: backDefault,
        isFemale: false,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let backShiny = sprites.backShiny {
      
      let newSprite = createSprite(
        withName: .backShiny,
        urlString: backShiny,
        isFemale: false,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let backFemale = sprites.backFemale {
      
      let newSprite = createSprite(
        withName: .back,
        urlString: backFemale,
        isFemale: true,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    if let backShinyFemale = sprites.backShinyFemale {
      
      let newSprite = createSprite(
        withName: .backShiny,
        urlString: backShinyFemale,
        isFemale: true,
        in: context)
      
      newSprites.append(newSprite)
    }
    
    return newSprites
  }
  
  private static func createSprite(
    withName name: Pokemon.Sprite.Name,
    urlString: String,
    isFemale: Bool,
    in context: NSManagedObjectContext
  ) -> CDSprite {
    
    let newSprite       = CDSprite(context: context)
    newSprite.name      = name.rawValue
    newSprite.urlString = urlString
    newSprite.isFemale  = isFemale
    return newSprite
  }
}

// MARK: - Comparable

extension CDSprite: Comparable {
  
  public static func < (lhs: CDSprite, rhs: CDSprite) -> Bool {
    if lhs.isFemale == rhs.isFemale {
      return lhs.name > rhs.name
    }
    
    return rhs.isFemale
  }
}
