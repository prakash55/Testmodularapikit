//
//  APIResponseDelegate.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

public protocol APIResponseDelegate {
    associatedtype ResponseType: APIResponse
    func didReceive(response: ResponseType)
    func didReceiveError(error: APIError)
}
