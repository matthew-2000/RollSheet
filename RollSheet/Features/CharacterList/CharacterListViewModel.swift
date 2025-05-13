//
//  CharacterListViewModel.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import Foundation
import SwiftData

@Observable
class CharacterListViewModel {
    var characters: [Character] = []
    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadCharacters()
    }

    func loadCharacters() {
        let descriptor = FetchDescriptor<Character>(sortBy: [.init(\.name)])
        do {
            characters = try context.fetch(descriptor)
        } catch {
            print("Errore nel fetch dei personaggi: \(error)")
        }
    }

    func deleteCharacter(_ character: Character) {
        context.delete(character)
        try? context.save()
        loadCharacters()
    }

    func addSampleCharacter() {
        let newCharacter = Character(
            name: "Nuovo PG",
            characterClass: "No class",
            race: "No race",
            level: 1,
            strength: 15,
            dexterity: 14,
            constitution: 13,
            intelligence: 10,
            wisdom: 12,
            charisma: 8,
            maxHP: 10,
            currentHP: 10,
            tempHP: 0,
            armorClass: 16,
            initiative: 2,
            speed: 9,
            passivePerception: 11
        )
        context.insert(newCharacter)
        try? context.save()
        loadCharacters()
    }
}
