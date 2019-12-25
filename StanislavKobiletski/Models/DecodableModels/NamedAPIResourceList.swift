//
//  NamedAPIResourceList.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct NamedAPIResourceList {
  let count: Int
  let next: String?
  let previous: String?
  let results: [NamedAPIResource]
}

extension NamedAPIResourceList: Decodable { }
