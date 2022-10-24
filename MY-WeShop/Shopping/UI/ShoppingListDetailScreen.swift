//
//  ShoppingListDetailScreen.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import SwiftUI

struct ShoppingListDetailScreen: View {
  @State private var itemName = ""
  @State private var itemAmount: Int = 1
  @State private var hasBought = false
  
  let shoppingList: ShoppingList
  
  var body: some View {
    content
      .navigationTitle(shoppingList.name)
      .navigationBarTitleDisplayMode(.inline)
  }
  
  var content: some View {
    VStack {
      TextField("Add Item", text: $itemName)
      TextField("Amount", value: $itemAmount, format: .number)
      
      Toggle("Bought?", isOn: $hasBought)
      
      Button(action: deleteList) {
        Text("Delete")
      }
      
      Spacer()
    }
    .padding()
  }
}

extension ShoppingListDetailScreen {
  private func deleteList() {
    
  }
}

struct ShoppingListDetailScreen_Previews: PreviewProvider {
  static var previews: some View {
    ShoppingListDetailScreen(shoppingList: ShoppingList.Preview.sample)
  }
}
