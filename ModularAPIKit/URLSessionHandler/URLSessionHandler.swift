//
//  URLSessionHandler.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import Combine
import Foundation


final class URLSessionAPIHandler: APIHandler {
  
    private var session: URLSession = URLSession(configuration: URLSessionConfiguration.default,delegate: SSLBypassDelegate(), delegateQueue: nil)
    private var requestInterceptors: [APIRequestInterceptor]?
    private var responseInterceptors: [APIResponseInterceptor]?
    private var cache: CacheHandler?
    
    init(
        session: URLSession = .shared,
        requestInterceptors: [APIRequestInterceptor]? = nil,
        responseInterceptors: [APIResponseInterceptor]? = nil,
        cache: CacheHandler? = nil
    ) {
        self.session = session
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.cache = cache
    }

    
    
    
    func request<U: APIResponse>(
        endpoint: any APIEndpoint
    ) async throws -> U {
        do {
            var request = try buildRequest(endpoint: endpoint, body: endpoint.body)
            request = applyRequestInterceptors(request, for: endpoint)
            
            let cacheKey = request.url?.absoluteString ?? ""
            
            if let cache, let cachedData = cache.get(for: cacheKey) {
                return try decodeResponse(cachedData, as: U.self)
            }
            
            let (data, response) = try await session.data(for: request)
            
            try applyResponseInterceptors(response: response, data: data, for: endpoint)
            
            if let cache {
                cache.set(data, for: cacheKey)
            }
            
            return try decodeResponse(data, as: U.self)
        }catch {
            print(error)
            throw error
        }
    }
    
    func request<U: APIResponse, D: APIResponseDelegate> (
        endpoint: APIEndpoint,
        delegate: D
    ) where D.ResponseType == U {
        Task {
            do {
                let response: U = try await request(
                    endpoint: endpoint
                )
                delegate.didReceive(response: response)
            } catch let error as APIError {
                delegate.didReceiveError(error: error)
            } catch {
                delegate.didReceiveError(error: .unknown)
            }
        }
    }
    
    func request<U: APIResponse>(
        endpoint: APIEndpoint,
        completion: @escaping (Result<U, APIError>) -> Void)
    {
        Task {
            do {
                let result: U = try await request(
                    endpoint: endpoint
                )
                completion(.success(result))
            } catch let error as APIError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }
    }
    
    func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) -> AnyPublisher<U, APIError>{
        Future<U, APIError> { promise in
            self.request(
                endpoint: endpoint
            ) { result in
                promise(result)
            }
        }.eraseToAnyPublisher()
    }
    
    func request<U: APIResponse>(
        endpoint: APIEndpoint
    ) -> Result<U, APIError> {
        do {
            let value : U = try awaitResult {
                try await self.request(
                    endpoint: endpoint
                )
            }
            return .success(value)
        } catch let error as APIError {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func buildRequest(endpoint: APIEndpoint, body: APIRequest?) throws -> URLRequest {
        guard var components = URLComponents(string: endpoint.baseUrl + endpoint.path) else {
            throw APIError.invalidURL
        }
        components.queryItems = endpoint.queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            if let jsonData = try? JSONEncoder().encode(body),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Body: \(jsonString)")
            }

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func applyRequestInterceptors(_ request: URLRequest, for endpoint: APIEndpoint) -> URLRequest {
        requestInterceptors?.reduce(request) { current, interceptor in
            interceptor.intercept(current, for: endpoint)
        } ?? request
    }
    
    private func applyResponseInterceptors(response: URLResponse?, data: Data?, for endpoint: APIEndpoint) throws {
        guard let responseInterceptors = responseInterceptors else { return }
        for interceptor in responseInterceptors {
            switch interceptor.intercept(response: response, data: data, for: endpoint) {
                case .success: continue
                case .failure(let error): throw error
            }
        }
    }
    
    private func decodeResponse<U : Codable>(_ data: Data, as type: U.Type) throws -> U where U: Decodable {
        do {
            return try JSONDecoder().decode(U.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    private func awaitResult<T>(_ work: @escaping () async throws -> T) throws -> T {
        var result: Result<T, Error>?
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                let value = try await work()
                result = .success(value)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        switch result {
            case .success(let value): return value
            case .failure(let error): throw error
            case .none: throw APIError.unknown
        }
    }
}


class SSLBypassDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential,
                          URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
