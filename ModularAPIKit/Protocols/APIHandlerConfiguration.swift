//
//  APIHandlerConfiguration.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

protocol APIHandlerConfiguration {
 
}
protocol URLHandlerConfigurationProtocal   {
    func configure(urlSession : URLSession)
}
class URLHandlerConfiguration: APIHandlerConfiguration , URLHandlerConfigurationProtocal {
    func configure(urlSession: URLSession) {
        
    }
    
    let urlSession: URLSession
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
   
}

extension URLHandlerConfiguration {
    override func configure(urlSession: URLSession) {
        
    }
}
