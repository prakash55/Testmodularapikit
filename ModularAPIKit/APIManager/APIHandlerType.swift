//
//  APIHandlerType.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//


public enum APIHandlerType {
    case urlSession(
        config: URLSession = .shared,
        requestInterceptors: [APIRequestInterceptor]?,
        responseInterceptors: [APIResponseInterceptor]?,
        cacheHandler: CacheHandler? = nil
    )
    
    case firebase
    
    case supabase
}
