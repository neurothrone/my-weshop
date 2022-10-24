//
//  AllShoppingListsScreen.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import Firebase
import SwiftUI

struct AllShoppingListsScreen: View {
  @Binding var isAuthenticated: Bool
  
  @State private var listName = ""
  @State private var lists: [ShoppingList]
  
  @State private var isShowingAddListToolToggled = false
  
  init(lists: [ShoppingList], isAuthenticated: Binding<Bool>) {
    _lists = State(initialValue: lists)
    _isAuthenticated = isAuthenticated
  }
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Lists")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { isShowingAddListToolToggled.toggle() }) {
              Image(systemName: "folder.badge.plus")
                .font(.title)
                .foregroundColor(
                  isShowingAddListToolToggled
                  ? .purple
                  : .secondary
                )
            }
          }
        }
    }
  }
  
  private var content: some View {
    ZStack(alignment: .top) {
      Color(UIColor.secondarySystemBackground)
        .ignoresSafeArea()
      
      VStack {
        Group {
          HStack {
            TextField("Name of your list", text: $listName)
            
            Button(action: addList) {
              Label("Add List", systemImage: "plus.square.fill")
            }
            .disabled(listName.isEmpty)
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(.purple.opacity(0.25))
          .background(.ultraThinMaterial)
          .offset(y: isShowingAddListToolToggled
                  ? 0
                  : -200
          )
          
          List {
            ForEach(lists) { list in
              NavigationLink {
                ShoppingListDetailScreen(shoppingList: list)
              } label: {
                Text(list.name)
              }
            }
          }
          .scrollContentBackground(.hidden)
          .offset(y: isShowingAddListToolToggled
                  ? 0
                  : -75
          )
        }
        .animation(.linear, value: isShowingAddListToolToggled)
      }
    }
  }
}

extension AllShoppingListsScreen {
  private func addList() {
    let newList = ShoppingList(name: listName, items: [])
    
    withAnimation(.linear) {
      lists.append(newList)
    }
    
    listName = ""
  }
  
  private func signOut() {
    try? Auth.auth().signOut()
    isAuthenticated = false
  }
}

struct AllShoppingListsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AllShoppingListsScreen(
        lists: ShoppingList.Preview.samples,
        isAuthenticated: .constant(true)
      )
    }
  }
}
