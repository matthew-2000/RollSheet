//
//  RootView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftUI
import SwiftData

struct RootView: View {
    @State private var selectedCharacter: Character?

    var body: some View {
        NavigationSplitView {
            CharacterListView(selectedCharacter: $selectedCharacter)
        } detail: {
            if let character = selectedCharacter {
                Text("Dettagli di \(character.name)") // placeholder
            } else {
                Text("Seleziona un personaggio")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(PreviewData.container)
}
