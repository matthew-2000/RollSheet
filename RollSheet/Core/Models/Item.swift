//
//  Item.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData

@Model
class Item {
    var name: String
    var detail: String
    var weight: Double
    var equipped: Bool

    var bonusAC: Int?
    var damage: String?
    var properties: [String]
    var isWeapon: Bool
    var isArmor: Bool

    @Relationship var character: Character?

    init(
        name: String,
        detail: String,
        weight: Double,
        equipped: Bool = false,
        bonusAC: Int? = nil,
        damage: String? = nil,
        properties: [String] = [],
        isWeapon: Bool = false,
        isArmor: Bool = false
    ) {
        self.name = name
        self.detail = detail
        self.weight = weight
        self.equipped = equipped
        self.bonusAC = bonusAC
        self.damage = damage
        self.properties = properties
        self.isWeapon = isWeapon
        self.isArmor = isArmor
    }
}
