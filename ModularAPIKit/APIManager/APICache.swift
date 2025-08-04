//
//  APICache.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

class APICache {
    static let shared = APICache()
    private var cache: [String: Data] = [:]
    
    func get(for key: String) -> Data? {
        return cache[key]
    }
    
    func set(_ data: Data, for key: String) {
        cache[key] = data
    }
}


public protocol CacheHandler {
    func get(for key: String) -> Data?
    func set(_ data: Data, for key: String)
    func remove(for key: String)
    func clear()
}
