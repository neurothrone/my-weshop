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
  
  @AppStorage("isShowingAddListToolToggled")
  private var isShowingAddListToolToggled = false
  
  private let userCollection = "users"
  private let listCollection = "lists"
  private var ref: DatabaseReference! = Database.database().reference()
  
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
          ToolbarItem(placement: .bottomBar) {
            Button(action: signOut) {
              Text("Sign Out")
            }
          }
          
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
    let newList = ShoppingList(name: listName)
    
    withAnimation(.linear) {
      lists.append(newList)
    }

    listName = ""
  }
  
  private func addListToFirebase() {
    guard let userID = Auth.auth().currentUser?.uid else { return }
    
    ref.child(userCollection)
      .child(userID)
      .child(listCollection)
      .childByAutoId()
      .setValue(listName)
    
    listName = ""
  }
  
  private func fetchLists() {
    guard let userID = Auth.auth().currentUser?.uid else { return }
    
    var lists: [String: [String: Any]] = .init()
    
    ref.child(userCollection)
      .child(userID)
      .child(listCollection)
      .getData { error, snapshot in
        if let error {
          assertionFailure("❌ -> Failed to fetch lists from Firebase. Error: \(error)")
        }
        
        if let snapshot {
          for list in snapshot.children {
            let listSnap = list as! DataSnapshot
            let listID = listSnap.key
            let listDict = listSnap.value as! [String: Any]
            
            lists[listID] = listDict
          }
        }
      }
  }
  
  private func fetchBy(listId: String) {
    guard let userID = Auth.auth().currentUser?.uid else { return }
    
    ref.child(userCollection)
      .child(userID)
      .child(listCollection)
      .child(listId)
      .getData { error, snapshot in
        if let error {
          assertionFailure("❌ -> Failed to fetch lists from Firebase. Error: \(error)")
        }
      }
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
