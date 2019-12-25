//
//  MockData.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import Foundation

class MockData {
  
  // MARK: - Properties
  
  var successResponse: HTTPURLResponse? {
    HTTPURLResponse(url: URL(string: "https://test-url.ee/")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil)
  }
  
  var failureResponse: HTTPURLResponse? {
    HTTPURLResponse(url: URL(string: "https://test-url.ee/")!,
                    statusCode: 501,
                    httpVersion: nil,
                    headerFields: nil)
  }
  
  // MARK: - Funcs
  
  func getPokemonsMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "pokemons_list", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getSinglePokemonMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "single_pokemon", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getAbilityMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "ability", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getMoveMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "move", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getSpritesMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "sprites", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getStatMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "stat", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getTypeMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "type", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getNamedAPIResourceMockData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "named_api_resource", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return data
  }
  
  func getImageData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let url = bundle.url(forResource: "pokemon", withExtension: "png")!
    let data = try! Data(contentsOf: url)
    return data
  }
}
