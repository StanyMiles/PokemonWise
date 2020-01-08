//
//  CDListItem+CoreDataClass.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 23.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//
//

import Foundation
import CoreData

public class CDListItem: NSManagedObject {

  // MARK: - Proprteies
  
  var name: String {
    get { cdName ?? "no name" }
    set { cdName = newValue }
  }
  
  var urlString: String {
    get { cdUrlString ?? "no url" }
    set { cdUrlString = newValue }
  }
  
  // MARK: - Funcs
  
  @discardableResult
  static func initialize(
    with resource: NamedAPIResource,
    position: Int16,
    in context: NSManagedObjectContext
  ) -> CDListItem {
    
    let newItem       = CDListItem(context: context)
    newItem.name      = resource.name
    newItem.urlString = resource.url
    newItem.position  = position
    return newItem
  }
}
