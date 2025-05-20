//
//  RacialAbilitiesCard.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 20/05/25.
//

import SwiftUI

struct AbilitiesCard: View {
    let title: String
    let source: AbilitySource
    @Binding var abilities: [Ability]
    
    @State private var selectedAbility: Ability?
    @State private var showingAddSheet = false
    @State private var abilityToDelete: Ability?

    var body: some View {
        RSCard(title: title) {
            VStack(alignment: .leading, spacing: 10) {
                if abilities.isEmpty {
                    ContentUnavailableView("Nessuna abilità", systemImage: "questionmark.circle", description: Text("Aggiungi un'abilità per iniziare."))
                        .frame(maxWidth: .infinity, minHeight: 120)
                } else {
                    ForEach(abilities) { ability in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(ability.name)
                                    .font(.headline)
                                    .onTapGesture {
                                        selectedAbility = ability
                                    }
                                Spacer()
                                Menu {
                                    Button("Modifica") {
                                        selectedAbility = ability
                                    }
                                    Button("Elimina", role: .destructive) {
                                        abilityToDelete = ability
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.secondary)
                                }
                                .menuStyle(.borderlessButton)
                                .menuIndicator(.hidden)
                                .frame(width: 28, alignment: .trailing) // forza larghezza minima precisa
                                .contentShape(Rectangle()) // limita area di tappo
                            }
                            Text(ability.detail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(10)
                        }
                        .padding(.vertical, 6)
                        Divider()
                    }
                }

                HStack {
                    Spacer()
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Aggiungi abilità", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 6)
            }
        }
        .sheet(item: $selectedAbility) { ability in
            AbilityDetailView(ability: ability)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddAbilityView(source: source) { newAbility in
                abilities.append(newAbility)
            }
        }
        .confirmationDialog("Eliminare questa abilità?",
                            isPresented: Binding(get: { abilityToDelete != nil },
                                                 set: { if !$0 { abilityToDelete = nil } }),
                            titleVisibility: .visible) {
            Button("Elimina", role: .destructive) {
                if let ability = abilityToDelete,
                   let index = abilities.firstIndex(where: { $0.id == ability.id }) {
                    abilities.remove(at: index)
                }
                abilityToDelete = nil
            }
            Button("Annulla", role: .cancel) {
                abilityToDelete = nil
            }
        }
    }
}


#Preview {
    @Previewable @State var abilities: [Ability] = [
        Ability(name: "Resistenza al veleno", detail: "Hai vantaggio ai tiri salvezza contro veleni.", source: .race)
    ]

    AbilitiesCard(title: "Aasimar – Abilità", source: .race, abilities: $abilities)
        .modelContainer(PreviewData.container)
        .padding()
}
