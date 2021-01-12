//
//  jacksonApp.swift
//  jackson
//
//  Created by 林湘羚 on 2021/1/13.
//

import SwiftUI

@main
struct jacksonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
