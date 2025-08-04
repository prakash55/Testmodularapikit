//
//  APIManager.swift
//  ModularAPIKit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import Foundation
import Combine

public struct APIManager {
    public static let `default` = APIManager(apiHander: URLSessionAPIHandler(session: URLSession(configuration: .default),
                                                                             requestInterceptors: nil,
                                                                             responseInterceptors: nil))
    private var requestInterceptors: [APIRequestInterceptor]?
    private var responseInterceptors: [APIResponseInterceptor]?
    

    public init(apiHander: APIHandler,
                  requestInterceptors: [APIRequestInterceptor]? = nil,
                  responseInterceptors: [APIResponseInterceptor]? = nil,
                  cache: CacheHandler? = nil) {
        self.apiHander = apiHander
    }
    
    init (apiHander: APIHandlerType,
          requestInterceptors: [APIRequestInterceptor]? = nil,
          responseInterceptors: [APIResponseInterceptor]? = nil,
          cache: CacheHandler? = nil) {
       
    }
    
    
    
    internal var apiHander : APIHandler
    
    
    public  func request<U: APIResponse>(
        endpoint: any APIEndpoint
    ) async throws -> U {
        do {
            let  response : U = try await apiHander.request(endpoint: endpoint)
            return response
        }
        catch {
            throw error
        }
    }
    
        // 2. Delegate-based
    public func request<U: APIResponse, D: APIResponseDelegate> (
        endpoint: APIEndpoint,
        delegate: D
    ) where D.ResponseType == U {
        
    }
    
        // 3. Callback/Closure
    public func request<U: APIResponse>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<U, APIError>) -> Void) {
            
        apiHander.request(endpoint: endpoint, completion: completion)
    }

      //   4. Combine Publisher
    public func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) async -> AnyPublisher<U, APIError> {
        await apiHander.request(endpoint: endpoint)
    }
    
     //    5. Result-only (sync wrapper)
    public func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) -> Result<U, APIError> {
        apiHander.request(endpoint: endpoint)
    }
}

class AuthRequestInterceptor: APIRequestInterceptor {
    private let maxRetryCount = 3
    
    func intercept(_ request: URLRequest, for endpoint: APIEndpoint) -> URLRequest {
        var request = request
            // Example: Add token if available
            //        if let token = TokenStorage.shared.token {
            //            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            //        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request.debugDescription)
        return request
    }
    
    func shouldRetry(_ error: APIError, attempt: Int, for endpoint: APIEndpoint) -> Bool {
        switch error {
            case .unknown:
                return attempt < maxRetryCount
            default:
                return false
        }
    }
}


class DefaultResponseInterceptor: APIResponseInterceptor {
    func intercept(
        response: URLResponse?,
        data: Data?,
        for endpoint: APIEndpoint
    ) -> Result<(URLResponse, Data), APIError> {
        guard let httpResponse = response as? HTTPURLResponse, let data = data else {
            return .failure(.unknown)
        }
        switch httpResponse.statusCode {
            case 200..<300:
                return .success((httpResponse, data))
            default:
                return .failure(.unknown)
        }
    }
}

