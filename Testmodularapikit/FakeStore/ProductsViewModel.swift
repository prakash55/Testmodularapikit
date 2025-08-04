//
//  ProductsView.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import Foundation

@MainActor
class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    
    func fetchProducts() async {
    
    }
}
