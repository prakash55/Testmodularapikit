//
//  TestmodularapikitApp.swift
//  Testmodularapikit
//
//  Created by Prakash Eppala(UST,IN) on 02/08/25.
//

import SwiftUI

@main
struct TestmodularapikitApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
