//
//  Condition.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData

@Model
class Condition {
    var name: String
    var detail: String
    var active: Bool

    @Relationship var character: Character?

    init(name: String, detail: String, active: Bool = true) {
        self.name = name
        self.detail = detail
        self.active = active
    }
}
