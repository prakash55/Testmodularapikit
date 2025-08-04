//
//  LoginViewModel.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import Foundation
import ModularAPIKit

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = "emilys"
    @Published var password = "emilyspass"
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    func login() async {
        
        let loginRequest = LoginRequest(username: username, password: password)
        do {
            let loginResponse : LoginResponse = try await APIManager.default.request(endpoint: TestEndpoint.login(loginRequest: loginRequest))
            print(loginResponse.accessToken)
        } catch {
            print(error)
        }
    
    }
}

