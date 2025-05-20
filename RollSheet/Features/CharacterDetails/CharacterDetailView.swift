//
//  CharacterDetailView.swift
//  RollSheet
//
//  UI tuned – 15 May 2025 (perf-granular)
//

import SwiftUI
import SwiftData

// MARK: - Design tokens
private enum RS {
    static let gap: CGFloat        = 20
    static let cardGap: CGFloat    = 16
    static let corner: CGFloat     = 16
    static let avatar: CGFloat     = 150
    static let cardHeight: CGFloat = 220       // altezza uniforme
}

// MARK: - Root
struct CharacterDetailView: View {
    @Bindable var character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: RS.gap) {
                
                HeaderRowView(character: character)      // avatar + HP + death saves
                
                // ─────────── Main layout: stats col. sinistra + griglia destra ───────────
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .top, spacing: RS.gap) {
                        StatsColumnView(
                            strength:     $character.strength,
                            dexterity:    $character.dexterity,
                            constitution: $character.constitution,
                            intelligence: $character.intelligence,
                            wisdom:       $character.wisdom,
                            charisma:     $character.charisma,
                            proficiencies: $character.skillProficiencies,
                            savingThrows: $character.savingThrows,
                            proficiencyBonus: character.proficiencyBonus
                        )
                        .frame(minWidth: 160, maxWidth: 400)
                        
                        RightGridView(character: character)
                    }
                    VStack(spacing: RS.gap) {
                        StatsColumnView(
                            strength:     $character.strength,
                            dexterity:    $character.dexterity,
                            constitution: $character.constitution,
                            intelligence: $character.intelligence,
                            wisdom:       $character.wisdom,
                            charisma:     $character.charisma,
                            proficiencies: $character.skillProficiencies,
                            savingThrows: $character.savingThrows,
                            proficiencyBonus: character.proficiencyBonus
                        )
                        RightGridView(character: character)
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

// MARK: - HEADER ROW
private struct HeaderRowView: View {
    @Bindable var character: Character
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: RS.gap) {
                HeaderInfoCard(character: character)
                HPMiniCard(maxHP:     $character.maxHP,
                           currentHP: $character.currentHP,
                           tempHP:    $character.tempHP)
                DeathSaveMiniCard(successes: $character.deathSavesSuccess,
                                  failures:  $character.deathSavesFailure)
            }
            VStack(spacing: RS.gap) {
                HeaderInfoCard(character: character)
                HStack(spacing: RS.cardGap) {
                    HPMiniCard(maxHP:     $character.maxHP,
                               currentHP: $character.currentHP,
                               tempHP:    $character.tempHP)
                    DeathSaveMiniCard(successes: $character.deathSavesSuccess,
                                      failures:  $character.deathSavesFailure)
                }
            }
        }
    }
}

// ── 1. Avatar + anagrafica
private struct HeaderInfoCard: View {
    @Bindable var character: Character
    
    var body: some View {
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
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 2) {
                    RSEditInlineText(text: $character.name,
                                     font: .system(size: 36, weight: .bold, design: .rounded))
                    
                    RSEditInlineNumber(value: $character.level,
                                       font: .title3.bold(),
                                       prefix: "Livello ")
                    
                    HStack(spacing: 4) { Text("Razza:").font(.headline);   RSEditInlineText(text: $character.race,            font: .title2) }
                    HStack(spacing: 4) { Text("Classe:").font(.headline);  RSEditInlineText(text: $character.characterClass, font: .title2) }
                    HStack(spacing: 4) { Text("Sottoclasse:").font(.headline);  RSEditInlineText(text: Binding(
                        get: { character.subclass ?? "" },
                        set: { character.subclass = $0 }), font: .title2)
                    }
                    HStack(spacing: 4) {
                        Text("Background:").font(.headline)
                        RSEditInlineText(text: Binding(get: { character.background ?? "" },
                                                       set: { character.background = $0 }),
                                         font: .title2)
                    }
                    HStack(spacing: 4) {
                        Text("Allineamento:").font(.headline)
                        RSEditInlineText(text: Binding(get: { character.alignment ?? "" },
                                                       set: { character.alignment = $0 }),
                                         font: .title2)
                    }
                    Spacer()
                    Button {
                        character.inspiration.toggle()
                    } label: {
                        Label("Ispirazione", systemImage: character.inspiration ? "sun.max.fill" : "sun.max")
                            .foregroundColor(character.inspiration ? .orange : .secondary)
                    }
                    .padding(.top)
                }
                Spacer(minLength: 0)
            }
        }
        .frame(minWidth: 650)
    }
}

// ── 2. HP card
private struct HPMiniCard: View {
    @Binding var maxHP:     Int
    @Binding var currentHP: Int
    @Binding var tempHP:    Int
    
    var body: some View {
        RSCard(title: "Punti Ferita") {
            VStack(spacing: 14) {
                RSEditNumber(label: "Massimi",    value: $maxHP)
                RSEditNumber(label: "Correnti",   value: $currentHP)
                RSEditNumber(label: "Temporanei", value: $tempHP)
            }
        }
    }
}

// ── 3. Death Save card
private struct DeathSaveMiniCard: View {
    @Binding var successes: Int
    @Binding var failures:  Int
    
    var body: some View {
        RSCard(title: "Tiri Salvezza") {
            RSDeathSaveDots(successes: $successes,
                            failures:  $failures)
        }
    }
}

// MARK: - STATS COLUMN
private struct StatsColumnView: View {
    @Binding var strength:     Int
    @Binding var dexterity:    Int
    @Binding var constitution: Int
    @Binding var intelligence: Int
    @Binding var wisdom:       Int
    @Binding var charisma:     Int
    @Binding var proficiencies: [String]
    @Binding var savingThrows: [String]
    var proficiencyBonus: Int

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: RS.cardGap) {
                VStack(spacing: RS.cardGap) {
                    RSStat("FOR", value: $strength, skills: Character.skillMap["FOR"]!, proficiencies: $proficiencies, proficiencyBonus: 4, savingThrows: $savingThrows)
                    RSStat("DES", value: $dexterity, skills: Character.skillMap["DES"]!, proficiencies: $proficiencies, proficiencyBonus: 4, savingThrows: $savingThrows)
                    RSStat("COS", value: $constitution, skills: [], proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                }
                VStack(spacing: RS.cardGap) {
                    RSStat("INT", value: $intelligence, skills: Character.skillMap["INT"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                    RSStat("SAG", value: $wisdom, skills: Character.skillMap["SAG"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                    RSStat("CAR", value: $charisma, skills: Character.skillMap["CAR"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                }
            }
            VStack(spacing: RS.cardGap) {
                RSStat("FOR", value: $strength, skills: Character.skillMap["FOR"]!, proficiencies: $proficiencies, proficiencyBonus: 4, savingThrows: $savingThrows)
                RSStat("DES", value: $dexterity, skills: Character.skillMap["DES"]!, proficiencies: $proficiencies, proficiencyBonus: 4, savingThrows: $savingThrows)
                RSStat("COS", value: $constitution, skills: [], proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                RSStat("INT", value: $intelligence, skills: Character.skillMap["INT"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                RSStat("SAG", value: $wisdom, skills: Character.skillMap["SAG"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
                RSStat("CAR", value: $charisma, skills: Character.skillMap["CAR"]!, proficiencies: $proficiencies, proficiencyBonus: 4,  savingThrows: $savingThrows)
            }
        }
        .frame(maxWidth: 400)
    }
}

// MARK: - RIGHT GRID
private struct RightGridView: View {
    @Bindable var character: Character
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: RS.cardGap)],
                  spacing: RS.cardGap) {
            
            StatCardView(proficiencyBonus: $character.proficiencyBonus,
                         passivePerception: $character.passivePerception)
            
            CombatCardView(armorClass: $character.armorClass,
                           initiative: $character.initiative,
                           speed:      $character.speed)
            
            EmptyCard(title: "Addestramento e Competenze")
            AbilitiesCard(title: "\(character.race) – Abilità",
                          source: .race,
                          abilities: $character.racialAbilities)

            AbilitiesCard(title: "\(character.characterClass) – Abilità",
                          source: .class,
                          abilities: $character.classAbilities)

            AbilitiesCard(title: "\(character.subclass ?? "No subclass") – Abilità",
                          source: .subclass,
                          abilities: $character.subclassAbilities)

            EmptyCard(title: "Talenti")
            EmptyCard(title: "Incantesimi")
        }
        .frame(maxWidth: .infinity)
    }
}

// ── 1. Stat card
private struct StatCardView: View {
    @Binding var proficiencyBonus:  Int
    @Binding var passivePerception: Int
    
    var body: some View {
        RSCard(title: "Statistiche") {
            RSEditNumber(label: "Bonus Competenza",   value: $proficiencyBonus)
            RSEditNumber(label: "Percezione Passiva", value: $passivePerception)
        }
    }
}

// ── 2. Combat card
private struct CombatCardView: View {
    @Binding var armorClass: Int
    @Binding var initiative: Int
    @Binding var speed:      Int
    
    var body: some View {
        RSCard(title: "Combattimento") {
            VStack(spacing: 18) {
                RSEditNumber(label: "CA",          value: $armorClass)
                RSEditNumber(label: "Iniziativa",  value: $initiative)
                RSEditNumber(label: "Velocità (m)", value: $speed)
            }
        }
    }
}

// ── 3. Placeholder card
private struct EmptyCard: View {
    let title: String
    var body: some View { RSCard(title: title) { EmptyView() } }
}

// MARK: - GENERIC CARD (lightweight bg + no shadow)
struct RSCard<Content: View>: View {
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
            if let title { Text(title).font(.title2.weight(.semibold))}
            content
            if fixedHeight { Spacer(minLength: 0) }
        }
        .padding(24)
        .frame(maxWidth: .infinity,
               minHeight: fixedHeight ? RS.cardHeight : nil,
               alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: RS.corner, style: .continuous)
                .fill(.background.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 0)
                .allowsHitTesting(false)
        )
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
            RSEditInlineText(text: $text, font: .title)
                .bold()
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
            RSEditInlineNumber(value: $value, font: .title.monospacedDigit())
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
            TextField("", text: $text, onCommit: { foc = false })
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

    @State private var text: String = ""

    var body: some View {
        ZStack(alignment: .leading) {
            if !foc {
                Text("\(prefix)\(value)").font(font).bold()
            }
            HStack(spacing: 0) {
                Text(prefix)
                TextField("", text: $text, onCommit: {
                    foc = false
                })
                .frame(width: 60)
                .multilineTextAlignment(.trailing)
                .onChange(of: foc) {
                    if foc {
                        // Mostra sempre il valore corrente quando entri in edit
                        text = String(value)
                    } else {
                        applyChange()
                    }
                }
            }
            .font(font)
            .opacity(foc ? 1 : 0)
            .focused($foc)
        }
        .contentShape(Rectangle())
        .onTapGesture { foc = true }
    }

    private func applyChange() {
        guard !text.isEmpty else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasPrefix("+") || trimmed.hasPrefix("-") {
            // Somma o sottrazione rispetto al valore attuale
            if let delta = Int(trimmed) {
                value += delta
            }
        } else if let n = Int(trimmed) {
            value = n
        }
        // Dopo il commit, resetta il campo col valore attuale
        text = String(value)
    }
}

// MARK: - Inc/Dec control
private struct RSIncDec: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack(spacing: 8) {
            Button { if value > range.lowerBound { value -= 1 } }
                   label: { Image(systemName: "minus.circle") }
            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(minWidth: 48)
                .monospacedDigit()
            Button { if value < range.upperBound { value += 1 } }
                   label: { Image(systemName: "plus.circle") }
        }
        .buttonStyle(.plain)
        .foregroundColor(.orange)
        .font(.system(size: 24, weight: .semibold))
    }
}

// MARK: - Stat card
struct RSStat: View {
    let title: String
    @Binding var value: Int
    @Binding var savingThrows: [String]
    let proficiencyBonus: Int
    let skills: [String]
    @Binding var proficiencies: [String]

    init(_ title: String,
         value: Binding<Int>,
         skills: [String],
         proficiencies: Binding<[String]>,
         proficiencyBonus: Int,
         savingThrows: Binding<[String]>) {
        self.title = title
        self._value = value
        self.skills = skills
        self.proficiencyBonus = proficiencyBonus
        self._proficiencies = proficiencies
        self._savingThrows = savingThrows
    }

    var modifier: Int { (value - 10) / 2 }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title.weight(.bold))

            Text(String(format: "%+d", modifier))
                .font(.system(size: 36, weight: .bold, design: .rounded))

            RSIncDec(value: $value, range: 1...30)
            
            Divider()

            HStack {
                Circle()
                    .fill(savingThrows.contains(title) ? Color.orange : .clear)
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                    .frame(width: 16, height: 16)
                    .contentShape(Circle())
                    .onTapGesture {
                        toggleSave(title)
                    }

                let bonus = modifier + (savingThrows.contains(title) ? proficiencyBonus : 0)

                Text("Tiro Salvezza: \(String(format: "%+d", bonus))")
                    .font(.subheadline)
                
                Spacer()
            }

            if !skills.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(skills, id: \.self) { skill in
                        HStack {
                            Circle()
                                .fill(proficiencies.contains(skill) ? Color.orange : .clear)
                                .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                                .frame(width: 16, height: 16)
                                .contentShape(Circle())
                                .onTapGesture {
                                    toggle(skill)
                                }
                            Text(skill)
                                .font(.callout)
                            Spacer()
                            let skillBonus = modifier + (proficiencies.contains(skill) ? proficiencyBonus : 0)
                            Text("\(String(format: "%+d", skillBonus))")
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: RS.corner, style: .continuous)
                .fill(.background.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: RS.corner)
                .stroke(.orange.opacity(0.15), lineWidth: 0)
                .allowsHitTesting(false)
        )
    }

    private func toggle(_ skill: String) {
        if let idx = proficiencies.firstIndex(of: skill) {
            proficiencies.remove(at: idx)
        } else {
            proficiencies.append(skill)
        }
    }
    
    private func toggleSave(_ code: String) {
        if let idx = savingThrows.firstIndex(of: code) {
            savingThrows.remove(at: idx)
        } else {
            savingThrows.append(code)
        }
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

/*
#Preview {
    let context = PreviewData.container.mainContext
    let character = try! context.fetch(FetchDescriptor<Character>()).first!

    return CharacterDetailView(character: character)
        .modelContainer(PreviewData.container)
}
*/
