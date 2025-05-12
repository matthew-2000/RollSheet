//
//  Ability.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//

import SwiftData

@Model
class Ability {
    var name: String
    var detail: String
    var source: AbilitySource
    var usage: String?

    @Relationship var character: Character?

    init(name: String, detail: String, source: AbilitySource, usage: String? = nil) {
        self.name = name
        self.detail = detail
        self.source = source
        self.usage = usage
    }
}

enum AbilitySource: String, Codable {
    case race
    case `class`
    case subclass
}
