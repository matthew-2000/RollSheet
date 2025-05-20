//
//  AbilityDetailView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 20/05/25.
//

import SwiftUI

struct AbilityDetailView: View {
    @ObservedObject var ability: Ability
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("Modifica Abilità")
                        .font(.largeTitle.bold())
                    Text(sourceDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Nome")
                    .font(.headline)
                TextField("Nome dell’abilità", text: $ability.name)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Dettagli")
                    .font(.headline)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3))
                    TextEditor(text: $ability.detail)
                        .padding(4)
                        .background(Color.clear)
                }
                .frame(minHeight: 140)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Uso (opzionale)")
                    .font(.headline)
                TextField("Es. '3/giorno'", text: Binding(
                    get: { ability.usage ?? "" },
                    set: { ability.usage = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(.roundedBorder)
            }

            Spacer()

            HStack {
                Spacer()
                Button("Chiudi") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }
        }
        .padding(32)
        .frame(minWidth: 460, minHeight: 480)
    }

    private var sourceDescription: String {
        switch ability.source {
        case .race: return "Abilità razziale"
        case .class: return "Abilità di classe"
        case .subclass: return "Abilità di sottoclasse"
        }
    }
}


#Preview {
    AbilityDetailView(ability: .init(name: "Scurovisione", detail: "Puoi vedere al buio fino a 18 metri.", source: .race))
}
