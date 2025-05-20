//
//  AddAbilityView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 20/05/25.
//

import SwiftUI

struct AddAbilityView: View {
    var source: AbilitySource
    var onAdd: (Ability) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var detail = ""
    @State private var usage = ""

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !detail.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("Nuova Abilità")
                        .font(.largeTitle.bold())
                    Text(verbatim: sourceDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Nome")
                    .font(.headline)
                TextField("Nome dell’abilità", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Dettagli")
                    .font(.headline)
                TextEditor(text: $detail)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3))
                    )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Uso (opzionale)")
                    .font(.headline)
                TextField("Es. 1/giorno, o illimitato", text: $usage)
                    .textFieldStyle(.roundedBorder)
            }

            Spacer()

            HStack {
                Button("Annulla") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Aggiungi") {
                    let new = Ability(name: name,
                                      detail: detail,
                                      source: source,
                                      usage: usage.isEmpty ? nil : usage)
                    onAdd(new)
                    dismiss()
                }
                .disabled(!isFormValid)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(32)
        .frame(minWidth: 460, minHeight: 500)
    }

    private var sourceDescription: String {
        switch source {
        case .race: return "Abilità razziale"
        case .class: return "Abilità di classe"
        case .subclass: return "Abilità di sottoclasse"
        }
    }
}

#Preview {
    AddAbilityView(source: .race) { _ in }
}
