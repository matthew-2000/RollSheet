//
//  Enum.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//

enum ArmorType: String, Codable {
    case light
    case medium
    case heavy
    case shield
}

enum WeaponType: String, Codable {
    case simple
    case martial
    case ranged
    case melee
    case finesse
    case thrown
    // ... altri se necessario
}

enum ToolType: String, Codable {
    case gamingSet
    case artisanTools
    case musicalInstrument
    case thievesTools
    // ... estendibile
}
