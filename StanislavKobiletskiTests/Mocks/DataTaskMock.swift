//
//  DataTaskMock.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import PokemonWise

class DataTaskMock: URLSessionDataTask {
  
  var completionHandler: (Data?, URLResponse?, Error?) -> Void
  var resumeWasCalled = false
  
  init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    self.completionHandler = completionHandler
  }
  
  override func resume() {
    resumeWasCalled = true
    completionHandler(nil, nil, nil)
  }
}
