//
//  Product.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//
import Foundation
import ModularAPIKit

struct Product: Codable, Identifiable, APIResponse {
    let id: Int
    let title: String
    let price: Double
    var image: String
}

struct LoginResponse: APIResponse {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let accessToken: String
    let refreshToken: String
}

struct LoginRequest: APIRequest {
    let username: String
    let password: String
}
