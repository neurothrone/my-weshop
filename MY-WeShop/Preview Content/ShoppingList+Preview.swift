//
//  ShoppingList+Preview.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import Foundation

extension ShoppingList {
  enum Preview {
    static var sample: ShoppingList {
      .init(name: "Groceries", items: [])
    }
    
    static var samples: [ShoppingList] {
      [
        .init(name: "Groceries", items: []),
        .init(name: "Travel Preparations", items: [])
      ]
    }
  }
}
