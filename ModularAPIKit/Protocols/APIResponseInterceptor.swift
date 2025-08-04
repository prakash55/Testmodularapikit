//
//  ResponseInterceptor.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

public protocol APIResponseInterceptor {
    /// Intercept successful or failed responses
    func intercept(
        response: URLResponse?,
        data: Data?,
        for endpoint: APIEndpoint
    ) -> Result<(URLResponse, Data), APIError>
}

