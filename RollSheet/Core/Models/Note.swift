//
//  Note.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftData
import Foundation

@Model
class Note {
    var title: String
    var content: String
    var createdAt: Date

    @Relationship var character: Character?

    init(title: String, content: String, createdAt: Date = .now) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
    }
}
