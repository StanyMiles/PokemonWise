//
//  URLSessionDataMock.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import PokemonWise

class URLSessionDataMock: URLSessionProtocol {
  
  var testData: Data?
  var response: HTTPURLResponse?
  
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    defer {
      completionHandler(testData, response, nil)
    }
    return DataTaskDataMock()
  }
}
