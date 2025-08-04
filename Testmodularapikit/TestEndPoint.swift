//
//  TestEndPoint.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//
import ModularAPIKit

enum TestEndpoint: APIEndpoint {
    var requestObject: APIRequest? {
        switch self {
            case .fetchUsers
                : return nil
            case .login(let loginRequest):
                return loginRequest
        }
    }
    
    
    
    var body: APIRequest? {
        return requestObject
    }
    
    
    var requiresAuth: Bool {
        switch self {
            case .fetchUsers
                : return true
            case .login:
                return false
        }
    }
    
    var queryItems: [String : String]? {
        return nil
    }
    
    case login(loginRequest : LoginRequest)
    case fetchUsers(page: Int)
    
    var baseUrl: String {
        return "https://dummyjson.com"
    }
    
    var path: String {
        switch self {
            case .login:
                return "/auth/login"
            case .fetchUsers(let page):
                return "/users?page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login:
                return .POST
            case .fetchUsers:
                return .GET
        }
    }
    
    var headers: [String: String] {
        switch self {
            case .login:
                return ["Content-Type": "application/json"]
            case .fetchUsers:
                return [:]
        }
    }

}
