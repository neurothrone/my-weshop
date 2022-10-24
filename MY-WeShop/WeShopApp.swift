//
//  WeShopApp.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import Firebase
import SwiftUI

@main
struct WeShopApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
