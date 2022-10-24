//
//  ContentView.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
  @State private var isAuthenticated = true
  
  @State private var shoppingLists: [ShoppingList] = []
  
  var body: some View {
    Group {
      if isAuthenticated {
        AllShoppingListsScreen(
          lists: shoppingLists,
          isAuthenticated: $isAuthenticated
        )
      } else {
        AuthScreen(isAuthenticated: $isAuthenticated)
      }
    }
    .onAppear() {
      var handle = Auth.auth().addStateDidChangeListener { auth, user in
        isAuthenticated = Auth.auth().currentUser != nil
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
