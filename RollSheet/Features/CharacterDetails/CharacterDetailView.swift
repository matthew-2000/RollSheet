//
//  CharacterDetailView.swift
//  RollSheet
//
//  Scrub & redesign – 13 May 2025
//

import SwiftUI
import SwiftData

// MARK: - Design Tokens
private enum RS {
    static let gap: CGFloat       = 28          // spaziatura esterna
    static let cardGap: CGFloat   = 24          // gap fra card / fra elementi interni
    static let corner: CGFloat    = 16
    static let avatar: CGFloat    = 120
}

struct CharacterDetailView: View {
    @Bindable var character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: RS.gap) {
                
                headerCard
                
                infoCombatSection      // responsive: HStack → VStack
                
                statsSection           // griglia adattiva
            }
            .padding(RS.gap)
        }
        .navigationTitle(character.name)
        .navigationSubtitle("\(character.race) • \(character.characterClass) • Livello \(character.level)")
        .toolbar {
            ToolbarItem {
                Button {
                    character.inspiration.toggle()
                } label: {
                    Label("Ispirazione",
                          systemImage: character.inspiration
                          ? "sparkles.circle.fill" : "sparkles.circle")
                }
            }
        }
        .accentColor(.orange)
    }
}

// MARK: Header
private extension CharacterDetailView {
    var headerCard: some View {
        RSCard {
            HStack(spacing: 20) {
                Circle()
                    .fill(.orange.opacity(0.25))
                    .frame(width: RS.avatar, height: RS.avatar)
                    .overlay {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 46))
                            .foregroundColor(.orange.opacity(0.7))
                    }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(character.name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("\(character.race) • \(character.characterClass)")
                        .foregroundColor(.secondary)
                    Text("Livello \(character.level)")
                        .font(.headline)
                }
                Spacer()
            }
        }
    }
}

// MARK: Info + Combat (ViewThatFits fa da responsive switch)
private extension CharacterDetailView {
    
    var infoCombatSection: some View {
        ViewThatFits(in: .horizontal) {
            // layout “wide” (affiancato)
            HStack(alignment: .top, spacing: RS.cardGap) {
                infoCard
                combatCard
            }
            // layout “narrow” (impilato) – usato se il primo HStack non entra
            VStack(spacing: RS.cardGap) {
                infoCard
                combatCard
            }
        }
    }
    
    var infoCard: some View {
        RSCard(title: "Informazioni") {
            VStack(spacing: 14) {
                RSField(label: "Background",
                        binding: Binding(
                            get: { character.background ?? "" },
                            set: { character.background = $0 }))
                RSField(label: "Allineamento",
                        binding: Binding(
                            get: { character.alignment ?? "" },
                            set: { character.alignment = $0 }))
            }
        }
        .frame(maxWidth: 380)
    }
    
    var combatCard: some View {
        RSCard(title: "Combattimento") {
            VStack(spacing: 18) {
                RSNumber("CA", value: $character.armorClass, range: 1...30)
                RSNumber("Iniziativa", value: $character.initiative, range: -10...10)
                RSNumber("Velocità", value: $character.speed, range: 0...60, suffix: " m")
                RSNumber("Percezione Passiva",
                         value: $character.passivePerception, range: 0...30)
            }
        }
        .frame(maxWidth: 380)
    }
}

// MARK: Statistiche
private extension CharacterDetailView {
    var statsSection: some View {
        RSCard(title: "Statistiche") {
            // .adaptive crea quante colonne entrano, minimo 220 pt
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 220),
                                         spacing: RS.cardGap)],
                      spacing: RS.cardGap) {
                RSStat("FOR", value: $character.strength)
                RSStat("DES", value: $character.dexterity)
                RSStat("COS", value: $character.constitution)
                RSStat("INT", value: $character.intelligence)
                RSStat("SAG", value: $character.wisdom)
                RSStat("CAR", value: $character.charisma)
            }
        }
    }
}

// MARK: - Reusable Components

/// Contenitore “card” con materiali macOS + bordo
private struct RSCard<Content: View>: View {
    var title: String?
    @ViewBuilder var content: Content
    
    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title; self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: RS.cardGap) {
            if let title {
                Text(title)
                    .font(.title2.weight(.semibold))
            }
            content
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in:
                        RoundedRectangle(cornerRadius: RS.corner,
                                         style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

/// TextField con label sopra
private struct RSField: View {
    var label: String
    @Binding var value: String
    
    init(label: String, binding: Binding<String>) {
        self.label = label; self._value = binding
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.subheadline.weight(.semibold))
            TextField(label, text: $value)
                .textFieldStyle(.roundedBorder)
        }
    }
}

/// Numero + etichetta e controllo oversize
private struct RSNumber: View {
    var label: String
    @Binding var value: Int
    var range: ClosedRange<Int>
    var suffix: String = ""
    
    init(_ label: String, value: Binding<Int>,
         range: ClosedRange<Int>, suffix: String = "") {
        self.label = label; self._value = value
        self.range = range; self.suffix = suffix
    }
    
    var body: some View {
        HStack {
            Text(label).font(.headline)
            Spacer()
            RSIncDec(value: $value, range: range)
            if !suffix.isEmpty {
                Text(suffix).foregroundColor(.secondary)
            }
        }
    }
}

/// Plus / minus da 24 pt
private struct RSIncDec: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                if value > range.lowerBound { value -= 1 }
            } label: { Image(systemName: "minus.circle.fill") }
            .buttonStyle(.plain)
            
            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(minWidth: 48)
                .monospacedDigit()
            
            Button {
                if value < range.upperBound { value += 1 }
            } label: { Image(systemName: "plus.circle.fill") }
            .buttonStyle(.plain)
        }
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(.orange)
    }
}

/// Mini-card per ogni statistica
private struct RSStat: View {
    let title: String
    @Binding var value: Int
    
    init(_ title: String, value: Binding<Int>) {
        self.title = title; self._value = value
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(Color.orange))
            
            Text("\(value)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            
            RSIncDec(value: $value, range: 1...30)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.windowBackgroundColor).opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.045), radius: 2, x: 0, y: 1)
    }
}
