//
//  PersistenceController.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        let schema = Schema([
            Character.self,
            Ability.self,
            Feat.self,
            Spell.self,
            Item.self,
            Condition.self,
            Note.self
        ])

        let config = ModelConfiguration(
            "RollSheetStore",
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("❌ Errore nella configurazione SwiftData: \(error)")
        }
    }
}
