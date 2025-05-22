//
//  FeatsCard.swift
//  RollSheet
//
//  Created by Matteo Ercolino on 22/05/25.
//


import SwiftUI

struct FeatsCard: View {
    let title: String
    @Binding var feats: [Feat]
    
    @State private var selectedFeat: Feat?
    @State private var showingAddSheet = false
    @State private var featToDelete: Feat?

    var body: some View {
        RSCard(title: title) {
            VStack(alignment: .leading, spacing: 10) {
                if feats.isEmpty {
                    Spacer()
                    ContentUnavailableView("Nessun talento", systemImage: "star.slash", description: Text("Aggiungi un talento per iniziare."))
                        .frame(maxWidth: .infinity, minHeight: 120)
                } else {
                    ForEach(feats) { feat in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(feat.name)
                                    .font(.headline)
                                    .onTapGesture {
                                        selectedFeat = feat
                                    }
                                Spacer()
                                Menu {
                                    Button("Modifica") {
                                        selectedFeat = feat
                                    }
                                    Button("Elimina", role: .destructive) {
                                        featToDelete = feat
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.secondary)
                                }
                                .menuStyle(.borderlessButton)
                                .menuIndicator(.hidden)
                                .frame(width: 28, alignment: .trailing)
                                .contentShape(Rectangle())
                            }
                            Text(feat.detail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(10)
                        }
                        .padding(.vertical, 6)
                        Divider()
                    }
                }

                Spacer()

                HStack {
                    Spacer()
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Aggiungi talento", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 6)
            }
        }
        .sheet(item: $selectedFeat) { feat in
            FeatDetailView(feat: feat)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddFeatView { newFeat in
                feats.append(newFeat)
            }
        }
        .confirmationDialog("Eliminare questo talento?",
                            isPresented: Binding(get: { featToDelete != nil },
                                                 set: { if !$0 { featToDelete = nil } }),
                            titleVisibility: .visible) {
            Button("Elimina", role: .destructive) {
                if let feat = featToDelete,
                   let index = feats.firstIndex(where: { $0.id == feat.id }) {
                    feats.remove(at: index)
                }
                featToDelete = nil
            }
            Button("Annulla", role: .cancel) {
                featToDelete = nil
            }
        }
    }
}
