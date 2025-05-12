//
//  Feat.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData

@Model
class Feat {
    var name: String
    var detail: String
    var levelAcquired: Int

    @Relationship var character: Character?

    init(name: String, detail: String, levelAcquired: Int) {
        self.name = name
        self.detail = detail
        self.levelAcquired = levelAcquired
    }
}
