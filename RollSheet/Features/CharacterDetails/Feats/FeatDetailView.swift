//
//  FeatDetailView.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 22/05/25.
//


import SwiftUI

struct FeatDetailView: View {
    @ObservedObject var feat: Feat
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Label("Modifica Talento", systemImage: "star.circle.fill")
                .font(.largeTitle.bold())
                .labelStyle(.iconOnly)
                .foregroundStyle(.yellow)

            VStack(alignment: .leading, spacing: 12) {
                Text("Nome")
                    .font(.headline)
                TextField("Nome del talento", text: $feat.name)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Dettagli")
                    .font(.headline)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.3))
                    TextEditor(text: $feat.detail)
                        .padding(4)
                        .background(Color.clear)
                }
                .frame(minHeight: 140)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Livello acquisito")
                    .font(.headline)
                Stepper(value: $feat.levelAcquired, in: 1...20) {
                    Text("Livello \(feat.levelAcquired)")
                }
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
        .frame(minWidth: 460, minHeight: 500)
    }
}
