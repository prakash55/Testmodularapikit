//
//  APIError.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//
import Foundation
import SwiftUI

public enum APIError: Error, LocalizedError, Equatable {
   
    case invalidURL
    case requestFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case decodingFailed(Error)
    case encodingFailed(Error)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case noInternet
    case cancelled
    case unknown
    
        // Optional: Custom error descriptions
     public var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .requestFailed(let error):
                return "Request failed: \(error.localizedDescription)"
            case .serverError(let code, _):
                return "Server returned status code \(code)."
            case .decodingFailed(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .encodingFailed(let error):
                return "Failed to encode request: \(error.localizedDescription)"
            case .unauthorized:
                return "Unauthorized access. Please login again."
            case .forbidden:
                return "Access forbidden."
            case .notFound:
                return "Requested resource not found."
            case .timeout:
                return "The request timed out."
            case .noInternet:
                return "No internet connection."
            case .cancelled:
                return "The request was cancelled."
            case .unknown:
                return "An unknown error occurred."
        }
    }
    
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

