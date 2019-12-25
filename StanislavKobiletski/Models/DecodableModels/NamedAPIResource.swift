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

extension NamedAPIResource: Decodable { }
