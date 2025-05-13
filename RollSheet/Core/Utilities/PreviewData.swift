//
//  PreviewData.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//

import SwiftData

@MainActor
struct PreviewData {
    static var container: ModelContainer = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.mainContext

        let character = Character(
            name: "Hendal",
            characterClass: "Paladino",
            race: "Aasimar",
            level: 12,
            strength: 20,
            dexterity: 10,
            constitution: 17,
            intelligence: 10,
            wisdom: 18,
            charisma: 17,
            maxHP: 144,
            currentHP: 144,
            tempHP: 0,
            armorClass: 20,
            initiative: 4,
            speed: 9,
            passivePerception: 17
        )

        context.insert(character)
        return controller.container
    }()
}
