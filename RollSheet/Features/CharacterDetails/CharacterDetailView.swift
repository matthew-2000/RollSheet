//
//  CharacterDetailView.swift
//  RollSheet
//
//  Two-column redesign – 15 May 2025
//

import SwiftUI
import SwiftData

// MARK: - Design tokens
private enum RS {
    static let gap: CGFloat     = 28
    static let cardGap: CGFloat = 24
    static let corner: CGFloat  = 16
    static let avatar: CGFloat  = 120
}

// MARK: - Root
struct CharacterDetailView: View {
    @Bindable var character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: RS.gap) {
                
                headerCard
                
                // ─────────────── MAIN GRID (stats left • other right) ───────────────
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: RS.gap) {
                        statsColumn.frame(maxWidth: 260)
                        rightColumn
                    }
                    VStack(spacing: RS.gap) {
                        statsColumn
                        rightColumn
                    }
                }
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

// MARK: - Header
private extension CharacterDetailView {
    var headerCard: some View {
        RSCard {
            HStack(spacing: 22) {
                
                Circle()
                    .fill(.orange.opacity(0.25))
                    .frame(width: RS.avatar, height: RS.avatar)
                    .overlay {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange.opacity(0.75))
                    }
                
                VStack(alignment: .leading) {
                    // Nome
                    RSEditInlineText(text: $character.name,
                                     font: .system(size: 34, weight: .bold, design: .rounded))
                    
                    // Razza • Classe
                    VStack {
                        RSEditInlineText(text: $character.race,
                                         font: .title3)
                        RSEditInlineText(text: $character.characterClass,
                                         font: .title3)
                    }
                    
                    // Livello
                    RSEditInlineNumber(value: $character.level,
                                       font: .headline,
                                       prefix: "Livello ")
                }
                Spacer()
            }
        }
    }
}

// MARK: - Left column (stats)
private extension CharacterDetailView {
    var statsColumn: some View {
        VStack(spacing: RS.cardGap) {
            RSStat("FOR", value: $character.strength)
            RSStat("DES", value: $character.dexterity)
            RSStat("COS", value: $character.constitution)
            RSStat("INT", value: $character.intelligence)
            RSStat("SAG", value: $character.wisdom)
            RSStat("CAR", value: $character.charisma)
        }
    }
}

// MARK: - Right column
private extension CharacterDetailView {
    var rightColumn: some View {
        VStack(spacing: RS.cardGap) {
            statCard
            combatCard
            infoCard
            RSCard(title: "Altro 1") { EmptyView() }   // placeholder
            RSCard(title: "Altro 2") { EmptyView() }   // placeholder
        }
        .frame(maxWidth: .infinity)
    }
    
    // ── Info ──
    var infoCard: some View {
        RSCard(title: "Informazioni") {
            VStack(spacing: 18) {
                RSEditText(label: "Background",
                           text: Binding(get: { character.background ?? "" },
                                         set: { character.background = $0 }))
                RSEditText(label: "Allineamento",
                           text: Binding(get: { character.alignment ?? "" },
                                         set: { character.alignment = $0 }))
            }
        }
    }
    
    // ── Statistiche ──
    var statCard: some View {
        RSCard(title: "Statistiche") {
            VStack(spacing: 24) {
                RSEditNumber(label: "Competenza", value: $character.proficiencyBonus)
                RSEditNumber(label: "Percezione Passiva", value: $character.passivePerception)
            }
        }
    }
    
    // ── Combattimento ──
    var combatCard: some View {
        RSCard(title: "Combattimento") {
            VStack(spacing: 24) {
                RSEditNumber(label: "CA", value: $character.armorClass)
                RSEditNumber(label: "Iniziativa", value: $character.initiative)
                RSEditNumber(label: "Velocità", value: $character.speed, suffix: " m")
                RSEditNumber(label: "Percezione Passiva", value: $character.passivePerception)
            }
        }
    }
}

// MARK: - Generic Card
private struct RSCard<Content: View>: View {
    var title: String?
    @ViewBuilder var content: Content
    
    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title; self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: RS.cardGap) {
            if let title {
                Text(title).font(.title2.weight(.semibold))
            }
            content
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial,
                    in: RoundedRectangle(cornerRadius: RS.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - “Ghost” TextField (String)
private struct RSEditText: View {
    var label: String
    @Binding var text: String
    @FocusState private var foc: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.subheadline.weight(.semibold))
            ZStack(alignment: .leading) {
                // testo statico
                if !foc { Text(text.isEmpty ? "—" : text) }
                // textfield
                TextField("", text: $text)
                    .opacity(foc ? 1 : 0)
                    .focused($foc)
            }
            .font(.title3)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.orange.opacity(foc ? 0.6 : 0), lineWidth: 2)
            )
            .onTapGesture { foc = true }
        }
    }
}

// MARK: - “Ghost” TextField (Int)
private struct RSEditNumber: View {
    var label: String
    @Binding var value: Int
    var suffix: String = ""
    @FocusState private var foc: Bool
    
    private static let nf: NumberFormatter = { let f = NumberFormatter(); f.allowsFloats = false; return f }()
    
    var body: some View {
        HStack {
            Text(label).font(.headline)
            Spacer()
            ZStack {
                if !foc { Text("\(value)").monospacedDigit() }
                TextField("", value: $value, formatter: RSEditNumber.nf)
                    .frame(width: 70, alignment: .trailing)
                    .opacity(foc ? 1 : 0)
                    .multilineTextAlignment(.trailing)
                    .focused($foc)
            }
            .font(.title3.monospacedDigit())
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.orange.opacity(foc ? 0.6 : 0), lineWidth: 2)
            )
            .onTapGesture { foc = true }
            if !suffix.isEmpty { Text(suffix).foregroundColor(.secondary) }
        }
    }
}

// MARK: - Inline editors for header
private struct RSEditInlineText: View {
    @Binding var text: String
    var font: Font = .title3
    @FocusState private var foc: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            if !foc { Text(text.isEmpty ? "—" : text).font(font) }
            TextField("", text: $text)
                .font(font)
                .opacity(foc ? 1 : 0)
                .focused($foc)
        }
        .onTapGesture { foc = true }
    }
}

private struct RSEditInlineNumber: View {
    @Binding var value: Int
    var font: Font = .body
    var prefix: String = ""
    @FocusState private var foc: Bool
    private static let nf: NumberFormatter = { let f = NumberFormatter(); f.allowsFloats = false; return f }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            if !foc {
                Text("\(prefix)\(value)")
                    .font(font)
            }
            HStack(spacing: 0) {
                Text(prefix)
                TextField("", value: $value, formatter: RSEditInlineNumber.nf)
                    .frame(width: 40)
                    .multilineTextAlignment(.trailing)
            }
            .font(font)
            .opacity(foc ? 1 : 0)
            .focused($foc)
        }
        .onTapGesture { foc = true }
    }
}

// MARK: - Plus/minus control
private struct RSIncDec: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: 10) {
            Button { if value > range.lowerBound { value -= 1 } }
                   label: { Image(systemName: "minus.circle.fill") }
            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(minWidth: 48)
                .monospacedDigit()
            Button { if value < range.upperBound { value += 1 } }
                   label: { Image(systemName: "plus.circle.fill") }
        }
        .buttonStyle(.plain)
        .foregroundColor(.orange)
        .font(.system(size: 24, weight: .semibold))
    }
}

// MARK: - Stat card (modificatore)
private struct RSStat: View {
    let title: String
    @Binding var value: Int
    
    init(_ t: String, value: Binding<Int>) {
        self.title = t; self._value = value
    }
    
    var modifier: Int { (value - 10) / 2 }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(Color.orange))
            
            Text(String(format: "%+d", modifier))
                .font(.system(size: 34, weight: .bold, design: .rounded))
            
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
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}
