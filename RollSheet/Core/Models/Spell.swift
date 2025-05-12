//
//  Spell.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData

@Model
class Spell {
    var name: String
    var level: Int
    var detail: String
    var prepared: Bool

    @Relationship var character: Character?

    init(name: String, level: Int, detail: String, prepared: Bool = false) {
        self.name = name
        self.level = level
        self.detail = detail
        self.prepared = prepared
    }
}
