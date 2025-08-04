//
//  APIEndPoint.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

public protocol APIEndpoint {
    var requestObject : APIRequest? { get }
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requiresAuth: Bool { get }
    var queryItems : [String : String]? { get }
    var body: APIRequest? { get }
}

extension APIEndpoint {
    public func apiUrl(baseURL: String) -> URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems?.asQueryItems
        return components?.url
    }
}


public extension Dictionary where Key == String, Value == String {
    var asQueryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
