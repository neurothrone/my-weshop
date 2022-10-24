//
//  ShoppingList.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import Foundation

struct ShoppingList: Identifiable {
  var id: String = UUID().uuidString
  let name: String
  
  let items: [ShoppingItem]
}
