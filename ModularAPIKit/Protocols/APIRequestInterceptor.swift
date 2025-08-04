//
//  APIRequestInterceptor.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

public protocol APIRequestInterceptor {
    func intercept(_ request: URLRequest, for endpoint: APIEndpoint) -> URLRequest
    func shouldRetry(_ error: APIError, attempt: Int, for endpoint: APIEndpoint) -> Bool
}
