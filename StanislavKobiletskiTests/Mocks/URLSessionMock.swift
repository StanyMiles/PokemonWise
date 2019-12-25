//
//  URLSessionMock.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import PokemonWise

class URLSessionMock: URLSessionProtocol {
  
  var dataTask: DataTaskMock?
  
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    
    let newDataTask = DataTaskMock(completionHandler: completionHandler)
    dataTask = newDataTask
    return newDataTask
  }
}
