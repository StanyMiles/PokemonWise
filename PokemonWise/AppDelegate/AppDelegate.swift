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
  
  private var coreDataClient: CoreDataClient!
  private var networkingClient: NetworkingClient!
  private var imageClient: ImageClient!
  
  // MARK: - UIApplication Lifecycle
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    coreDataClient = CoreDataClient()
    networkingClient = NetworkingClient.shared
    imageClient = ImageClient.shared
    
    dataManager = DataManagerFacade(
      coreDataClient: coreDataClient,
      networkingClient: networkingClient,
      imageClient: imageClient)
    
    return true
  }
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    saveContext()
  }
}

extension AppDelegate {
  
  func saveContext() {
    coreDataClient.stack.saveChanges()
  }
}
