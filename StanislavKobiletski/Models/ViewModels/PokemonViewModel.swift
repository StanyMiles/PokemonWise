//
//  PokemonViewModel.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 24.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct PokemonViewModel {
  
  // MARK: - Properties
  
  let pokemon: Pokemon
  let pokemonView: PokemonView
  let dataManagerFacade: DataManagerFacade
  
  private let infoAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.systemFont(ofSize: 15, weight: .regular)
  ]
  
  private let listAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.italicSystemFont(ofSize: 15),
    .foregroundColor: UIColor.systemGray
  ]
  
  // MARK: - Func
  
  func setupViews() {
    setupHeightLabel()
    setupWeightLabel()
    setupExperienceLabel()
    setupAbilities()
    setupMoves()
    setupStats()
    setupTypes()
    setupImages()
    presentPokemonView()
  }
  
  // MARK: - Private Funcs
  
  private func presentPokemonView() {
    UIView.animate(withDuration: 0.3) {
      self.pokemonView.subviews.forEach { $0.alpha = 1 }
    }
  }
  
  private func setupHeightLabel() {
    let text = NSMutableAttributedString(
      string: "Height: ",
      attributes: infoAttributes)
    
    let height = NSMutableAttributedString(
      string: "\(pokemon.height) dm",
      attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    text.append(height)
    pokemonView.heightLabel.attributedText = text
  }
  
  private func setupWeightLabel() {
    let text = NSMutableAttributedString(
      string: "Weight: ",
      attributes: infoAttributes)
    
    let weight = NSMutableAttributedString(
      string: "\(pokemon.weight) hg",
      attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    text.append(weight)
    pokemonView.weightLabel.attributedText = text
  }
  
  private func setupExperienceLabel() {
    let text = "You can gain \(pokemon.baseExperience) exp for defeating this pokemon."
    pokemonView.experienceLabel.text = text
  }
  
  private func setupAbilities() {
    let abilities = pokemon.abilities
      .map { $0.name }
      .joined(separator: ", ")
    
    let text = NSMutableAttributedString(
      string: "Abilities: ",
      attributes: infoAttributes)
    
    let abilitiesString = NSMutableAttributedString(
      string: abilities,
      attributes: listAttributes)
    
    text.append(abilitiesString)
    pokemonView.abilitiesLabel.attributedText = text
  }
  
  private func setupMoves() {
    let moves = pokemon.moves
      .map { $0.name }
      .joined(separator: ", ")
    
    let text = NSMutableAttributedString(
      string: "Moves: ",
      attributes: infoAttributes)
    
    let movesString = NSMutableAttributedString(
      string: moves,
      attributes: listAttributes)
    
    text.append(movesString)
    pokemonView.movesLabel.attributedText = text
  }
  
  private func setupStats() {
    let stats = pokemon.stats
      .map { $0.name }
      .joined(separator: ", ")
    
    let text = NSMutableAttributedString(
      string: "Stats: ",
      attributes: infoAttributes)
    
    let statsString = NSMutableAttributedString(
      string: stats,
      attributes: listAttributes)
    
    text.append(statsString)
    pokemonView.statsLabel.attributedText = text
  }
  
  private func setupTypes() {
    let types = pokemon.types
      .map { $0.name }
      .joined(separator: ", ")
    
    let text = NSMutableAttributedString(
      string: "Types: ",
      attributes: infoAttributes)
    
    let typesString = NSMutableAttributedString(
      string: types,
      attributes: listAttributes)
    
    text.append(typesString)
    pokemonView.typesLabel.attributedText = text
  }
  
  private func setupImages() {
    typealias Name = Pokemon.Sprite.Name
    
    hideImageViews()
    
    for sprite in pokemon.sprites {
      
      let imageView: UIImageView
      
      switch sprite.name {
      case Name.front.rawValue:
        imageView = sprite.isFemale ?
          pokemonView.frontFemaleImageView :
          pokemonView.frontImageView
        
      case Name.back.rawValue:
        imageView = sprite.isFemale ?
          pokemonView.backFemaleImageView :
          pokemonView.backImageView
        
      case Name.frontShiny.rawValue:
        imageView = sprite.isFemale ?
          pokemonView.frontShinyFemaleImageView :
          pokemonView.frontShinyImageView
        
      case Name.backShiny.rawValue:
        imageView = sprite.isFemale ?
          pokemonView.backShinyFemaleImageView :
          pokemonView.backShinyImageView
        
      default: continue
      }
      
      setup(imageView, withSprite: sprite)
    }
  }
  
  private func hideImageViews() {
    let imageViews = [
      pokemonView.frontImageView,
      pokemonView.backImageView,
      pokemonView.frontShinyImageView,
      pokemonView.frontShinyImageView,
      pokemonView.frontFemaleImageView,
      pokemonView.frontShinyFemaleImageView,
      pokemonView.backFemaleImageView,
      pokemonView.backShinyFemaleImageView,
    ]
    imageViews.forEach { $0?.alpha = 0 }
  }
  
  private func setup(
    _ imageView: UIImageView,
    withSprite sprite: Pokemon.Sprite
  ) {
    
    guard let data = sprite.imageData else {
      loadImageData(for: sprite, imageView: imageView)
      return
    }
    
    let image = UIImage(data: data)
    imageView.image = image
    
    present(imageView: imageView)
  }
  
  private func present(imageView: UIImageView) {
    UIView.animate(withDuration: 0.3) {
      imageView.alpha = 1
    }
  }
  
  private func loadImageData(for sprite: Pokemon.Sprite, imageView: UIImageView) {
    
//    dataManagerFacade.requestImageData(
//      forURLString: sprite.urlString
//    ) { result in
//      
//      switch result {
//        
//      case .success(let data):
//        let image = UIImage(data: data)
//        imageView.image = image
//        
//        self.present(imageView: imageView)
//        
//      case .failure(let error):
//        #if DEBUG
//        print("Failed to load data for image:", error)
//        #endif
//      }
//    }
  }
  
}
