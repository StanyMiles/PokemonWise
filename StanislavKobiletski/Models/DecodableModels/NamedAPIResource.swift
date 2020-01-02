//
//  NamedAPIResource.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct NamedAPIResource {
  let name: String
  let url: String
}

// MARK: - Decodable

extension NamedAPIResource: Decodable { }

// MARK: - Equatable

extension NamedAPIResource: Equatable {
  
  static func == (lhs: NamedAPIResource, rhs: NamedAPIResource) -> Bool {
    lhs.name == rhs.name && lhs.url == rhs.url
  }
}
