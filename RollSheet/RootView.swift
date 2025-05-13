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
                CharacterDetailView(character: character)
            } else {
                ContentUnavailableView("Nessun personaggio selezionato", systemImage: "person.crop.circle", description: Text("Seleziona un personaggio dalla lista a sinistra."))
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(PreviewData.container)
}
