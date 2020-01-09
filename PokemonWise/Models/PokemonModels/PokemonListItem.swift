//
//  PokemonListItem.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct PokemonListItem {
  let name: String
  let urlString: String
  
  init(_ namedAPIResource: NamedAPIResource) {
    name      = namedAPIResource.name
    urlString = namedAPIResource.url
  }
  
  init(_ listItem: CDListItem) {
    name      = listItem.name
    urlString = listItem.urlString
  }
}
