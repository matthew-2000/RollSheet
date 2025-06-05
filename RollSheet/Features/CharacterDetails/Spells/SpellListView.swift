//
//  CharacterDetailView.swift
//  RollSheet
//
//  Created – 5 June 2025
//

import SwiftUI
import SwiftData

private enum RS {
    static let gap: CGFloat = 20
    static let cardGap: CGFloat = 16
    static let corner: CGFloat = 16
}

struct SpellListView: View {
    @Query var spells: [Spell]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var searchText = ""
    @State private var filterLevel: Int? = nil
    @State private var showingNewSpellSheet = false

    var filteredSpells: [Spell] {
        spells.filter { spell in
            (searchText.isEmpty || spell.name.localizedCaseInsensitiveContains(searchText)) &&
            (filterLevel == nil || spell.level == filterLevel)
        }
        .sorted { $0.level < $1.level || ($0.level == $1.level && $0.name < $1.name) }
    }

    var body: some View {
        VStack(spacing: RS.gap) {
            HStack {
                Button(action: { dismiss() }) {
                    Label("Indietro", systemImage: "chevron.left")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.plain)

                Spacer()
                Text("Incantesimi")
                    .font(.largeTitle.bold())
                Spacer()

                Button(action: { showingNewSpellSheet = true }) {
                    Label("Aggiungi", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            SearchBar(text: $searchText)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    filterButton("Tutti", active: filterLevel == nil) { filterLevel = nil }
                    ForEach(0..<10, id: \ .self) { lvl in
                        filterButton("Liv \(lvl)", active: filterLevel == lvl) { filterLevel = lvl }
                    }
                }
                .padding(.horizontal)
            }

            RSCard(fixedHeight: false) {
                if filteredSpells.isEmpty {
                    ContentUnavailableView("Nessun incantesimo", systemImage: "book", description: Text("Prova ad aggiungerne uno nuovo o modifica i filtri."))
                } else {
                    ForEach(filteredSpells) { spell in
                        NavigationLink(destination: SpellDetailView(spell: spell)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(spell.name).font(.headline)
                                    Text("Livello \(spell.level)").font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                if spell.prepared {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                modelContext.delete(spell)
                            } label: {
                                Label("Elimina", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .sheet(isPresented: $showingNewSpellSheet) {
            NavigationStack {
                NewSpellView()
            }
        }
    }

    private func filterButton(_ label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(active ? Color.accentColor.opacity(0.2) : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .foregroundColor(active ? .accentColor : .primary)
    }
}

struct SpellDetailView: View {
    @Bindable var spell: Spell

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: RS.gap) {
                RSCard(fixedHeight: false) {
                    VStack(alignment: .leading, spacing: RS.cardGap) {
                        RSEditText(label: "Nome", text: $spell.name)
                        RSEditNumber(label: "Livello", value: $spell.level)
                        Toggle("Preparato", isOn: $spell.prepared)
                            .toggleStyle(.switch)
                    }
                }

                RSCard(fixedHeight: false) {
                    VStack(alignment: .leading, spacing: RS.cardGap) {
                        Text("Descrizione")
                            .font(.headline)
                        TextEditor(text: $spell.detail)
                            .frame(minHeight: 200)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.2))
                            )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(spell.name)
    }
}

struct NewSpellView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var level = 0
    @State private var prepared = false
    @State private var detail = ""

    var body: some View {
        VStack(alignment: .leading, spacing: RS.gap) {
            Text("Nuovo Incantesimo")
                .font(.largeTitle.bold())

            RSCard(fixedHeight: false) {
                VStack(alignment: .leading, spacing: RS.cardGap) {
                    RSEditText(label: "Nome", text: $name)
                    RSEditNumber(label: "Livello", value: $level)
                    Toggle("Preparato", isOn: $prepared)
                        .toggleStyle(.switch)
                }
            }

            RSCard(fixedHeight: false) {
                VStack(alignment: .leading, spacing: RS.cardGap) {
                    Text("Descrizione")
                        .font(.headline)
                    TextEditor(text: $detail)
                        .frame(minHeight: 200)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2))
                        )
                }
            }

            Spacer()

            HStack {
                Button("Annulla") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Salva") {
                    let new = Spell(name: name, level: level, detail: detail, prepared: prepared)
                    modelContext.insert(new)
                    dismiss()
                }
                .disabled(name.isEmpty)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(minWidth: 480)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Cerca incantesimo", text: $text)
                .textFieldStyle(.plain)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background.opacity(0.4))
        )
    }
}
