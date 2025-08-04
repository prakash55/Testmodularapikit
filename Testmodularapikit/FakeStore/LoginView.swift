//
//  LoginView.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    Task { await viewModel.login() }
                }
                .buttonStyle(.borderedProminent)
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                
                NavigationLink(
                    destination: ProductsView(),
                    isActive: $viewModel.isLoggedIn
                ) { EmptyView() }
            }
            .padding()
            .navigationTitle("Login")
        }
    }
}


