//
//  AddFeatView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 22/05/25.
//


import SwiftUI

struct AddFeatView: View {
    var onAdd: (Feat) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var detail = ""
    @State private var levelAcquired = 1

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !detail.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("Nuovo Talento")
                        .font(.largeTitle.bold())
                    Text("Aggiungi un talento")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Nome")
                    .font(.headline)
                TextField("Nome del talento", text: $name)
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
                Text("Livello acquisito")
                    .font(.headline)
                Stepper(value: $levelAcquired, in: 1...20) {
                    Text("Livello \(levelAcquired)")
                }
            }

            Spacer()

            HStack {
                Button("Annulla") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Aggiungi") {
                    let newFeat = Feat(name: name, detail: detail, levelAcquired: levelAcquired)
                    onAdd(newFeat)
                    dismiss()
                }
                .disabled(!isFormValid)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(32)
        .frame(minWidth: 460, minHeight: 500)
    }
}
