//
//  Enum.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//

enum ArmorType: String, Codable, CaseIterable {
    case light
    case medium
    case heavy
    case shield
}

enum WeaponType: String, Codable, CaseIterable {
    case simple
    case martial
    case ranged
}

enum ToolType: String, Codable, CaseIterable {
    case gamingSet
    case artisanTools
    case musicalInstrument
    case thievesTools
}

extension ArmorType: Identifiable, CustomStringConvertible {
    var id: Self { self }
    var description: String {
        switch self {
        case .light: return "Armatura Leggera"
        case .medium: return "Armatura Media"
        case .heavy: return "Armatura Pesante"
        case .shield: return "Scudo"
        }
    }
}

extension WeaponType: Identifiable, CustomStringConvertible {
    var id: Self { self }
    var description: String {
        switch self {
        case .simple: return "Arma Semplice"
        case .martial: return "Arma da Guerra"
        case .ranged: return "Arma a Distanza"
        }
    }
}

extension ToolType: Identifiable, CustomStringConvertible {
    var id: Self { self }
    var description: String {
        switch self {
        case .gamingSet: return "Set da Gioco"
        case .artisanTools: return "Strumenti da Artigiano"
        case .musicalInstrument: return "Strumento Musicale"
        case .thievesTools: return "Strumenti da Ladro"
        }
    }
}
