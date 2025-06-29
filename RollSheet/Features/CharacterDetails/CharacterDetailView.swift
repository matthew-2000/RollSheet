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
                            proficiencyBonus: $character.proficiencyBonus
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
                            proficiencyBonus: $character.proficiencyBonus
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
                           tempHP:    $character.tempHP,
                           successes: $character.deathSavesSuccess,
                           failures:  $character.deathSavesFailure)
                SpellsCard(spellcastingClass: $character.spellcastingClass,
                           spellcastingAbility: $character.spellcastingAbility,
                           spellSaveDC: $character.spellSaveDC,
                           spellAttackBonus: $character.spellAttackBonus)            }
            VStack(spacing: RS.gap) {
                HeaderInfoCard(character: character)
                HStack(spacing: RS.cardGap) {
                    HPMiniCard(maxHP:     $character.maxHP,
                               currentHP: $character.currentHP,
                               tempHP:    $character.tempHP,
                               successes: $character.deathSavesSuccess,
                               failures:  $character.deathSavesFailure)
                    SpellsCard(spellcastingClass: $character.spellcastingClass,
                               spellcastingAbility: $character.spellcastingAbility,
                               spellSaveDC: $character.spellSaveDC,
                               spellAttackBonus: $character.spellAttackBonus)                }
            }
        }
    }
}

private struct SpellsCard: View {
    @Binding var spellcastingClass: String?
    @Binding var spellcastingAbility: String?
    @Binding var spellSaveDC: Int?
    @Binding var spellAttackBonus: Int?

    var body: some View {
        RSCard(title: "Incantesimi") {
            VStack(alignment: .leading, spacing: 18) {
                
                HStack(spacing: 4) {
                    Text("Classe:").font(.headline)
                    RSEditInlineText(
                        text: Binding(
                            get: { spellcastingClass ?? "" },
                            set: { spellcastingClass = $0.isEmpty ? nil : $0 }
                        ),
                        font: .title2
                    )
                }

                HStack(spacing: 4) {
                    Text("Abilità:").font(.headline)
                    RSEditInlineText(
                        text: Binding(
                            get: { spellcastingAbility ?? "" },
                            set: { spellcastingAbility = $0.isEmpty ? nil : $0 }
                        ),
                        font: .title2
                    )
                }

                RSEditNumber(
                    label: "CD Tiro Salvezza",
                    value: Binding(
                        get: { spellSaveDC ?? 0 },
                        set: { spellSaveDC = $0 }
                    )
                )

                RSEditNumber(
                    label: "Bonus Attacco",
                    value: Binding(
                        get: { spellAttackBonus ?? 0 },
                        set: { spellAttackBonus = $0 }
                    )
                )
                
                NavigationLink {
                    SpellListView()
                } label: {
                    HStack {
                        Image(systemName: "book")
                        Text("Apri Lista Incantesimi")
                            .font(.title3.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: RS.corner)
                            .fill(Color.orange.opacity(0.15))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
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
    @Binding var successes: Int
    @Binding var failures:  Int

    var body: some View {
        RSCard(title: "Punti Ferita") {
            VStack(spacing: 14) {
                RSEditNumber(label: "Massimi",    value: $maxHP)
                RSEditNumber(label: "Correnti",   value: $currentHP)
                RSEditNumber(label: "Temporanei", value: $tempHP)
                Divider()
                if currentHP <= 0 {
                    RSDeathSaveDots(successes: $successes, failures: $failures)
                }
            }
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
    @Binding var proficiencyBonus: Int

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: RS.cardGap) {
                VStack(spacing: RS.cardGap) {
                    ProficiencyBonusCard(bonus: $proficiencyBonus)
                    RSStat("FOR", value: $strength, skills: Character.skillMap["FOR"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus, savingThrows: $savingThrows)
                    RSStat("DES", value: $dexterity, skills: Character.skillMap["DES"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus, savingThrows: $savingThrows)
                    RSStat("COS", value: $constitution, skills: [], proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                }
                VStack(spacing: RS.cardGap) {
                    RSStat("INT", value: $intelligence, skills: Character.skillMap["INT"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                    RSStat("SAG", value: $wisdom, skills: Character.skillMap["SAG"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                    RSStat("CAR", value: $charisma, skills: Character.skillMap["CAR"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                }
            }
            VStack(spacing: RS.cardGap) {
                ProficiencyBonusCard(bonus: $proficiencyBonus)
                RSStat("FOR", value: $strength, skills: Character.skillMap["FOR"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus, savingThrows: $savingThrows)
                RSStat("DES", value: $dexterity, skills: Character.skillMap["DES"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus, savingThrows: $savingThrows)
                RSStat("COS", value: $constitution, skills: [], proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                RSStat("INT", value: $intelligence, skills: Character.skillMap["INT"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                RSStat("SAG", value: $wisdom, skills: Character.skillMap["SAG"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
                RSStat("CAR", value: $charisma, skills: Character.skillMap["CAR"]!, proficiencies: $proficiencies, proficiencyBonus: proficiencyBonus,  savingThrows: $savingThrows)
            }
        }
        .frame(maxWidth: 400)
    }
}

struct ProficiencyBonusCard: View {
    @Binding var bonus: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("Competenza")
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)

            Text(String(format: "%+d", bonus))
                .font(.system(size: 36, weight: .bold, design: .rounded))

            RSIncDec(value: $bonus, range: 1...10)
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
}


// MARK: - RIGHT GRID
private struct RightGridView: View {
    @Bindable var character: Character
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: RS.cardGap)],
                  spacing: RS.cardGap) {
            
            StatCardView(passivePerception: $character.passivePerception,
                         armorClass: $character.armorClass,
                         initiative: $character.initiative,
                         speed:      $character.speed)
            
            ProficienciesCardView(armorProficiencies: $character.armorProficiencies, weaponProficiencies: $character.weaponProficiencies, toolProficiencies: $character.toolProficiencies)
            AbilitiesCard(title: "\(character.race)",
                          source: .race,
                          abilities: $character.racialAbilities)

            AbilitiesCard(title: "\(character.characterClass)",
                          source: .class,
                          abilities: $character.classAbilities)

            AbilitiesCard(title: "\(character.subclass ?? "No subclass")",
                          source: .subclass,
                          abilities: $character.subclassAbilities)

            FeatsCard(title: "Talenti", feats: $character.feats)
        }
        .frame(maxWidth: .infinity)
    }
}

// ── 1. Stat card
private struct StatCardView: View {
    @Binding var passivePerception: Int
    @Binding var armorClass: Int
    @Binding var initiative: Int
    @Binding var speed:      Int
    
    var body: some View {
        RSCard(title: "Statistiche") {
            RSEditNumber(label: "Percezione Passiva", value: $passivePerception)
            RSEditNumber(label: "Classe Armatura (CA)", value: $armorClass)
            RSEditNumber(label: "Iniziativa",  value: $initiative)
            RSEditNumber(label: "Velocità (m)", value: $speed)
        }
    }
}

private struct ProficienciesCardView: View {
    @Binding var armorProficiencies: [ArmorType]
    @Binding var weaponProficiencies: [WeaponType]
    @Binding var toolProficiencies: [ToolType]
    
    @State private var newArmor: ArmorType?
    @State private var newWeapon: WeaponType?
    @State private var newTool: ToolType?

    var body: some View {
        RSCard(title: "Addestramento e Competenze") {
            VStack(spacing: 18) {
                proficiencySection(title: "Armature", items: $armorProficiencies, allCases: ArmorType.allCases)
                Divider()
                proficiencySection(title: "Armi", items: $weaponProficiencies, allCases: WeaponType.allCases)
                Divider()
                proficiencySection(title: "Strumenti", items: $toolProficiencies, allCases: ToolType.allCases)
            }
        }
    }

    private func proficiencySection<T: Hashable & Identifiable & CustomStringConvertible>(title: String, items: Binding<[T]>, allCases: [T]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            ForEach(items.wrappedValue, id: \.self) { item in
                HStack {
                    Text(item.description)
                    Spacer()
                    Button(role: .destructive) {
                        if let index = items.wrappedValue.firstIndex(of: item) {
                            items.wrappedValue.remove(at: index)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }

            Menu("Aggiungi \(title.lowercased())") {
                ForEach(allCases.filter { !items.wrappedValue.contains($0) }, id: \.self) { option in
                    Button(option.description) {
                        items.wrappedValue.append(option)
                    }
                }
            }
            .padding(.top, 5)
        }
    }
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
struct RSEditText: View {
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
struct RSEditNumber: View {
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
struct RSEditInlineText: View {
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
struct RSEditInlineNumber: View {
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
struct RSIncDec: View {
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
                    .font(.headline)
                
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
struct RSDeathSaveDots: View {
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
