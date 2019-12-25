//
//  AppDelegate.swift
//  StanislavKobiletski
//
//  Created by Stanislav Kobiletski on 22.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - Properties
 
  var dataManager: DataManagerFacade!
  
  private var coreDataManager: CoreDataManager!
  private var networkingManager: NetworkingManager!
  
  // MARK: - UIApplicationDidFinishLaunchingWithOptions
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    coreDataManager = CoreDataManager()
    networkingManager = NetworkingManager()
    
    dataManager = DataManagerFacade(
      coreDataManager: coreDataManager,
      networkManager: networkingManager)
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role)
  }
  
}

extension AppDelegate {
  
  func saveContext() {
    coreDataManager.saveContext()
  }
}
