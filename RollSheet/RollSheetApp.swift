//
//  RollSheetApp.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 28/04/25.
//

import SwiftUI
import SwiftData

@main
struct RollSheetApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(PersistenceController.shared.container)
    }
}
