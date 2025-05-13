//
//  CharacterListView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 12/05/25.
//


import SwiftUI
import SwiftData

struct CharacterListView: View {
    @Environment(\.modelContext) private var context
    @Binding var selectedCharacter: Character?
    @State private var viewModel: CharacterListViewModel

    init(selectedCharacter: Binding<Character?>) {
        self._selectedCharacter = selectedCharacter
        _viewModel = State(initialValue: CharacterListViewModel(context: PersistenceController.shared.container.mainContext))
    }

    var body: some View {
        List(selection: $selectedCharacter) {
            ForEach(viewModel.characters, id: \.id) { character in
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                    Text("\(character.race) \(character.characterClass) – Liv. \(character.level)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .tag(character)
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.deleteCharacter(viewModel.characters[$0]) }
            }
        }
        .navigationTitle("Personaggi")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.addSampleCharacter()
                } label: {
                    Label("Nuovo PG", systemImage: "plus")
                }
            }
        }
    }
}

/*
#Preview {
    CharacterListView(selectedCharacter: .constant(nil))
        .modelContainer(PreviewData.container)
}
*/
