//
//  AuthScreen.swift
//  MY-WeShop
//
//  Created by Zaid Neurothrone on 2022-10-24.
//

import FirebaseAuth
import SwiftUI

struct AuthScreen: View {
  private enum Field {
    case emailAddress
    case password
  }
  
  @Binding var isAuthenticated: Bool
  
  @FocusState private var focusedField: Field?
  
  @State private var email = ""
  @State private var password = ""
  @State private var isErrorAlertPresented = false
  
  private var isInputValid: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.purple, .indigo],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      content
        .alert("Invalid credentials", isPresented: $isErrorAlertPresented) {
          Button(role: .cancel, action: {}) {
            Text("OK")
          }
        }
        .onSubmit {
          focusedField = focusedField == .emailAddress ? .password : nil
        }
    }
  }
  
  private var content: some View {
    VStack {
      Text("Register or Log in")
        .font(.title)
        .padding(.bottom)
      
      TextField("Email", text: $email)
        .focused($focusedField, equals: .emailAddress)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
        .submitLabel(.next)
        .textFieldStyle(.roundedBorder)
      
      SecureField("Password", text: $password)
        .focused($focusedField, equals: .password)
        .submitLabel(.done)
        .textFieldStyle(.roundedBorder)
      
      HStack(spacing: 25) {
        Button(action: signUp) {
          Text("Register")
            .foregroundColor(isInputValid ? .black : .white.opacity(0.5))
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)
        .cornerRadius(20)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(isInputValid ? .black : .white.opacity(0.5), lineWidth: 1)
        )
        
        Button(action: signIn) {
          Text("Log in")
            .foregroundColor(isInputValid ? .black : .white.opacity(0.5))
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.mint)
        .cornerRadius(20)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(isInputValid ? .black : .white.opacity(0.5), lineWidth: 1)
        )
      }
      .padding()
      .disabled(!isInputValid)
      .animation(.linear, value: isInputValid)
    }
    .font(.title3)
    .padding()
  }
}

extension AuthScreen {
  private func signUp() {
    Auth.auth().createUser(
      withEmail: email,
      password: password
    ) { authResult, error in
      if let error {
        print("❌ -> Failed to Register. Error: \(error)")
        isErrorAlertPresented.toggle()
        return
      }
      
      isAuthenticated = true
    }
  }
  
  private func signIn() {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error {
        print("❌ -> Failed to Log in. Error: \(error)")
        isErrorAlertPresented.toggle()
        return
      }
      
      isAuthenticated = true
    }
  }
}

struct AuthScreen_Previews: PreviewProvider {
  static var previews: some View {
    AuthScreen(isAuthenticated: .constant(false))
  }
}
