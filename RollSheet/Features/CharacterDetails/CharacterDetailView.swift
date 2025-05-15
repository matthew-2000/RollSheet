//
//  CharacterDetailView.swift
//  RollSheet
//
//  UI tuned – 15 May 2025
//

import SwiftUI
import SwiftData

// MARK: - Design tokens
private enum RS {
    static let gap: CGFloat        = 20
    static let cardGap: CGFloat    = 16
    static let corner: CGFloat     = 16
    static let avatar: CGFloat     = 110
    static let cardHeight: CGFloat = 220   // altezza uniforme
}

// MARK: - Root
struct CharacterDetailView: View {
    @Bindable var character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: RS.gap) {
                
                headerRow                        // ── Header + HP + Death Saves
                
                // ─────────── Main layout: stats col. sinistra + griglia destra ───────────
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: RS.gap) {
                        statsColumn.frame(maxWidth: 260)
                        rightGrid
                    }
                    VStack(spacing: RS.gap) {
                        statsColumn
                        rightGrid
                    }
                }
            }
            .padding(RS.gap)
        }
        .navigationTitle(character.name)
        .navigationSubtitle("\(character.race) • \(character.characterClass) • Livello \(character.level)")
        .accentColor(.orange)
    }
}

// MARK: - Header row (Info + HP + Death Saves)
private extension CharacterDetailView {
    var headerRow: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: RS.gap) {
                headerInfoCard
                hpMiniCard
                deathSaveMiniCard
            }
            VStack(spacing: RS.gap) {
                headerInfoCard
                HStack(spacing: RS.cardGap) {
                    hpMiniCard
                    deathSaveMiniCard
                }
            }
        }
    }
    
    // ── Card avatar + anagrafica
    var headerInfoCard: some View {
        RSCard {
            HStack(spacing: 18) {
                Circle()
                    .fill(.orange.opacity(0.25))
                    .frame(width: RS.avatar, height: RS.avatar)
                    .overlay {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.orange.opacity(0.75))
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    RSEditInlineText(text: $character.name,
                                     font: .system(size: 36, weight: .bold, design: .rounded))
                    
                    RSEditInlineNumber(value: $character.level,
                                       font: .title3.bold(),
                                       prefix: "Livello ")
                    
                    HStack(spacing: 4) { Text("Razza:").font(.headline);   RSEditInlineText(text: $character.race, font: .title3) }
                    HStack(spacing: 4) { Text("Classe:").font(.headline);  RSEditInlineText(text: $character.characterClass, font: .title3) }
                    HStack(spacing: 4) {
                        Text("Background:").font(.headline)
                        RSEditInlineText(text: Binding(get: { character.background ?? "" },
                                                       set: { character.background = $0 }),
                                         font: .title3)
                    }
                    HStack(spacing: 4) {
                        Text("Allineamento:").font(.headline)
                        RSEditInlineText(text: Binding(get: { character.alignment ?? "" },
                                                       set: { character.alignment = $0 }),
                                         font: .title3)
                    }
                    Spacer()
                    Button {
                        character.inspiration.toggle()
                    } label: {
                        Label("Ispirazione", systemImage: character.inspiration ? "sun.max.fill" : "sun.max")
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    // ── Mini-card Punti Ferita
    var hpMiniCard: some View {
        RSCard(title: "Punti Ferita", fixedHeight: false) {
            VStack(spacing: 14) {
                RSEditNumber(label: "Massimi",    value: $character.maxHP)
                RSEditNumber(label: "Correnti",   value: $character.currentHP)
                RSEditNumber(label: "Temporanei", value: $character.tempHP)
            }
        }
        .frame(width: 190)
    }
    
    // ── Mini-card Death Saves
    var deathSaveMiniCard: some View {
        RSCard(title: "Tiri Salvezza", fixedHeight: false) {
            RSDeathSaveDots(successes: $character.deathSavesSuccess,
                            failures:  $character.deathSavesFailure)
        }
        .frame(width: 190)
    }
}

// MARK: - Colonna sinistra (6 caratteristiche)
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

// MARK: - Grid destra
private extension CharacterDetailView {
    var rightGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: RS.cardGap)],
                  spacing: RS.cardGap) {
            statCard
            combatCard
            weaponsCard
            classFeaturesCard
            featsCard
            speciesTraitsCard
            equipmentCard
        }
        .frame(maxWidth: .infinity)
    }
    
    var statCard: some View {
        RSCard(title: "Statistiche") {    // altezza fissa come le altre
            RSEditNumber(label: "Bonus Competenza", value: $character.proficiencyBonus)
        }
    }
    
    var combatCard: some View {
        RSCard(title: "Combattimento") {
            VStack(spacing: 18) {
                RSEditNumber(label: "CA", value: $character.armorClass)
                RSEditNumber(label: "Iniziativa", value: $character.initiative)
                RSEditNumber(label: "Velocità", value: $character.speed, suffix: " m")
                RSEditNumber(label: "Percezione Passiva", value: $character.passivePerception)
            }
        }
    }
    
    // ── Card vuote in traduzione
    var weaponsCard: some View { RSCard(title: "Armi e Danni") { EmptyView() } }
    var classFeaturesCard: some View { RSCard(title: "Abilità di Classe") { EmptyView() } }
    var featsCard: some View { RSCard(title: "Talenti") { EmptyView() } }
    var speciesTraitsCard: some View { RSCard(title: "Abilità di Specie") { EmptyView() } }
    var equipmentCard: some View { RSCard(title: "Addestramento e Competenze") { EmptyView() } }
}

// MARK: - Generic Card
private struct RSCard<Content: View>: View {
    var title: String?
    var fixedHeight: Bool = true
    @ViewBuilder var content: Content
    
    init(title: String? = nil,
         fixedHeight: Bool = true,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.fixedHeight = fixedHeight
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: RS.cardGap) {
            if let title { Text(title).font(.title2.weight(.semibold)) }
            content
            if fixedHeight { Spacer(minLength: 0) }
        }
        .padding(24)
        .frame(maxWidth: .infinity,
               minHeight: fixedHeight ? RS.cardHeight : nil,
               alignment: .topLeading)
        .background(.regularMaterial,
                    in: RoundedRectangle(cornerRadius: RS.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 0)
                .allowsHitTesting(false)   // non blocca i tap interni
        )
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// MARK: - “Ghost” editable Text (String)
private struct RSEditText: View {
    var label: String
    @Binding var text: String
    @FocusState private var foc: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.subheadline.weight(.semibold))
            RSEditInlineText(text: $text, font: .title3)
        }
    }
}

// MARK: - “Ghost” editable Number
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
            RSEditInlineNumber(value: $value, font: .title3.monospacedDigit())
            if !suffix.isEmpty { Text(suffix).foregroundColor(.secondary) }
        }
    }
}

// MARK: - Inline editable (String)
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
        .contentShape(Rectangle())
        .onTapGesture { foc = true }
    }
}

// MARK: - Inline editable (Number)
private struct RSEditInlineNumber: View {
    @Binding var value: Int
    var font: Font = .body
    var prefix: String = ""
    @FocusState private var foc: Bool
    
    private static let nf: NumberFormatter = { let f = NumberFormatter(); f.allowsFloats = false; return f }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            if !foc { Text("\(prefix)\(value)").font(font) }
            HStack(spacing: 0) {
                Text(prefix)
                TextField("", value: $value, formatter: Self.nf)
                    .frame(width: 50)
                    .multilineTextAlignment(.trailing)
            }
            .font(font)
            .opacity(foc ? 1 : 0)
            .focused($foc)
        }
        .contentShape(Rectangle())
        .onTapGesture { foc = true }
    }
}

// MARK: - Inc/Dec control
private struct RSIncDec: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: 8) {
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

// MARK: - Stat card
private struct RSStat: View {
    let title: String
    @Binding var value: Int
    
    init(_ t: String, value: Binding<Int>) {
        self.title = t; self._value = value
    }
    
    var modifier: Int { (value - 10) / 2 }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(Color.orange))
            
            Text(String(format: "%+d", modifier))
                .font(.system(size: 36, weight: .bold, design: .rounded))
            
            RSIncDec(value: $value, range: 1...30)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial,
                    in: RoundedRectangle(cornerRadius: RS.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 0)
                .allowsHitTesting(false)
        )
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Death Save dots control
private struct RSDeathSaveDots: View {
    @Binding var successes: Int   // 0…3
    @Binding var failures:  Int   // 0…3
    
    private func dot(index: Int, bound: Binding<Int>, color: Color) -> some View {
        let filled = index < bound.wrappedValue
        
        return Circle()
            .fill(filled ? color : .clear)
            .overlay(Circle().stroke(color, lineWidth: 2))
            .frame(width: 20, height: 20)
            .contentShape(Circle()) // Assicura che il tap sia catturato
            .onTapGesture {
                if index < bound.wrappedValue {
                    bound.wrappedValue = index
                } else {
                    bound.wrappedValue = index + 1
                }
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Successi").font(.headline)
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    dot(index: i, bound: $successes, color: .green)
                }
            }
            Text("Fallimenti").font(.headline)
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    dot(index: i, bound: $failures, color: .red)
                }
            }
        }
    }

}
