//
//  DataTaskDataMock.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import PokemonWise

class DataTaskDataMock: URLSessionDataTask {
  
  override init() { }
  
  override func resume() {
    // NOP
  }
}
