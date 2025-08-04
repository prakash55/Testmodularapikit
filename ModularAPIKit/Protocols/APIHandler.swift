//
//  APIHandlerProtocol.swift
//  ModularAPIKit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import Foundation
import Combine

public protocol APIHandler {
    
    // 1. Async/Await
    func request<U: APIResponse>(
        endpoint: any APIEndpoint
    ) async throws -> U
    
    // 2. Delegate-based
    func request<U: APIResponse, D: APIResponseDelegate> (
        endpoint: APIEndpoint,
        delegate: D
    ) where D.ResponseType == U
    
    // 3. Callback/Closure
    func request<U: APIResponse>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<U, APIError>) -> Void)
    
    // 4. Combine Publisher
    func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) async  -> AnyPublisher<U, APIError>
    
    // 5. Result-only (sync wrapper)
    func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) -> Result<U, APIError>
}
