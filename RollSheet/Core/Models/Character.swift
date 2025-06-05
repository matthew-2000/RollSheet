//
//  Character.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData
import Foundation

@Model
class Character {
    // MARK: - Identità Base
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var characterClass: String
    var subclass: String?
    var race: String
    var background: String?
    var alignment: String?
    var level: Int
    var inspiration: Bool
    var proficiencyBonus: Int

    // MARK: - Caratteristiche Base
    var strength: Int
    var dexterity: Int
    var constitution: Int
    var intelligence: Int
    var wisdom: Int
    var charisma: Int

    // MARK: - Punti Ferita e Salvezza contro la morte
    var maxHP: Int
    var currentHP: Int
    var tempHP: Int
    var deathSavesSuccess: Int
    var deathSavesFailure: Int

    // MARK: - Combattimento
    var armorClass: Int
    var initiative: Int
    var speed: Int
    var passivePerception: Int
    var attunedItemSlots: Int

    // MARK: - Competenze e Abilità
    var savingThrows: [String]
    var skillProficiencies: [String]
    static let skillMap: [String: [String]] = [
        "FOR": ["Atletica"],
        "DES": ["Acrobazia", "Furtività", "Rapidità di mano"],
        "COS": [],
        "INT": ["Arcano", "Indagare", "Storia", "Natura", "Religione"],
        "SAG": ["Intuizione", "Percezione", "Medicina", "Sopravvivenza", "Addestrare animali"],
        "CAR": ["Persuasione", "Inganno", "Intrattenere", "Intimidire"]
    ]

    var languages: [String]

    var armorProficiencies: [ArmorType]
    var weaponProficiencies: [WeaponType]
    var toolProficiencies: [ToolType]

    // MARK: - Abilità e Talenti
    @Relationship(deleteRule: .cascade) var racialAbilities: [Ability]
    @Relationship(deleteRule: .cascade) var classAbilities: [Ability]
    @Relationship(deleteRule: .cascade) var subclassAbilities: [Ability]
    @Relationship(deleteRule: .cascade) var feats: [Feat]

    // MARK: - Magia
    var spellcastingClass: String?           // Es. "Mago", "Chierico", ecc.
    var spellcastingAbility: String?         // Es. "INT", "SAG", "CAR"
    var spellSaveDC: Int?                    // CD salvezza contro incantesimi
    var spellAttackBonus: Int?               // Bonus all'attacco con incantesimi
    var spellSlots: [Int]
    @Relationship(deleteRule: .cascade) var knownSpells: [Spell]

    // MARK: - Inventario e Stato
    @Relationship(deleteRule: .cascade) var items: [Item]
    @Relationship(deleteRule: .cascade) var conditions: [Condition]

    // MARK: - Monete
    var platinumPieces: Int
    var goldPieces: Int
    var electrumPieces: Int
    var silverPieces: Int
    var copperPieces: Int

    // MARK: - Altro
    @Relationship(deleteRule: .cascade) var notes: [Note]
    var createdAt: Date
    var portraitImageName: String?

    init(
        name: String,
        characterClass: String,
        race: String,
        level: Int,
        strength: Int,
        dexterity: Int,
        constitution: Int,
        intelligence: Int,
        wisdom: Int,
        charisma: Int,
        maxHP: Int,
        currentHP: Int,
        tempHP: Int,
        armorClass: Int,
        initiative: Int,
        speed: Int,
        passivePerception: Int,
        inspiration: Bool = false
    ) {
        self.name = name
        self.characterClass = characterClass
        self.race = race
        self.level = level
        self.strength = strength
        self.dexterity = dexterity
        self.constitution = constitution
        self.intelligence = intelligence
        self.wisdom = wisdom
        self.charisma = charisma
        self.maxHP = maxHP
        self.currentHP = currentHP
        self.tempHP = tempHP
        self.armorClass = armorClass
        self.initiative = initiative
        self.speed = speed
        self.passivePerception = passivePerception

        self.background = nil
        self.subclass = nil
        self.alignment = nil
        self.inspiration = inspiration
        self.proficiencyBonus = (2 + (level - 1) / 4) // D&D 5e logic

        self.deathSavesSuccess = 0
        self.deathSavesFailure = 0
        self.attunedItemSlots = 0

        self.savingThrows = []
        self.skillProficiencies = []
        self.languages = []

        self.armorProficiencies = []
        self.weaponProficiencies = []
        self.toolProficiencies = []

        self.spellSlots = []
        self.createdAt = Date()

        self.platinumPieces = 0
        self.goldPieces = 0
        self.electrumPieces = 0
        self.silverPieces = 0
        self.copperPieces = 0
        
        self.racialAbilities = []
        self.classAbilities = []
        self.subclassAbilities = []
        self.feats = []
        self.knownSpells = []
        self.items = []
        self.conditions = []
        self.notes = []

    }
    
}
