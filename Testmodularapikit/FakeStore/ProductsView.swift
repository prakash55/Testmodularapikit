//
//  ProductsView.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List(viewModel.products) { product in
            HStack {
                AsyncImage(url: URL(string: product.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(product.title).font(.headline)
                    Text("$\(product.price, specifier: "%.2f")")
                        .foregroundColor(.secondary)
                }
            }
        }
        .task { await viewModel.fetchProducts() }
        .navigationTitle("Products")
    }
}
