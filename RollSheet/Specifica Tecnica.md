
# RollSheet — Specifica Tecnica

## Obiettivo
Creare un'applicazione moderna per macOS (eventualmente estendibile a iPadOS) dedicata alla gestione di personaggi per giochi di ruolo come Dungeons & Dragons.  
L'app aiuterà i giocatori a tenere traccia di statistiche, abilità, incantesimi, inventario e progressione del personaggio in modo centralizzato e intuitivo durante le sessioni di gioco.

---

## Requisiti Funzionali
- Creazione di nuovi personaggi (nome, classe, razza, livello, statistiche, ecc.)
- Visualizzazione e modifica delle schede dei personaggi
- Gestione dell'inventario (oggetti, armi, armature, peso)
- Gestione degli incantesimi e delle abilità
- Diario personale per note ed eventi di gioco
- Salvataggio persistente locale dei dati
- Possibilità futura di sincronizzazione cloud (iCloud)

---

## Tecnologie
- **Linguaggio:** Swift
- **Interfaccia:** SwiftUI
- **Persistenza dati:** SwiftData
- **Compatibilità:** 
  - macOS 14 (Sonoma) o superiore
  - Possibile estensione futura a iPadOS
- **Architettura:** MVVM (Model - View - ViewModel)

---

## Moduli Principali
- **Character List**: elenco dei personaggi salvati
- **Character Detail**: schermata dettagliata per ogni personaggio
- **Inventory Manager**: gestione oggetti ed equipaggiamento
- **Spellbook Manager**: gestione degli incantesimi
- **Notes Manager**: gestione di appunti e diario di gioco
- **Condition Tracker**: applicazione e rimozione di condizioni di stato

---

## Struttura del progetto

```
Sources/
└── RollSheet/
    ├── Core/                 # Base condivisa e indipendente dalle feature
    │   ├── Models/           # SwiftData Models (@Model)
    │   ├── Persistence/      # Setup database, preview context, seeding
    │   └── Utilities/        # Enum, costanti, formatter, estensioni
    │
    ├── Features/             # Ogni cartella = 1 funzionalità isolata
    │   ├── CharacterList/    # Elenco personaggi e selezione
    │   ├── CharacterDetail/  # Dettagli scheda personaggio
    │   ├── InventoryManager/ # Oggetti, peso, equipaggiamento
    │   ├── SpellbookManager/ # Incantesimi per livello e stato
    │   ├── NotesManager/     # Diario e note
    │   └── ConditionTracker/ # Gestione condizioni attive
    │
    ├── SharedUI/             # Componenti SwiftUI riutilizzabili
    ├── App/                  # Entry point, app lifecycle, router
    └── Resources/            # Assets, colori, localizzazione
    
```

---

## Target Utente
Giocatori di ruolo (es. D&D 5e) che usano il Mac durante le sessioni e vogliono una scheda digitale centralizzata, interattiva e personalizzabile.  
Il focus è su semplicità, immediatezza d'accesso ai dati del personaggio e affidabilità durante la sessione.

---

## Espansioni Future
- Sincronizzazione dati via iCloud
- Importazione/esportazione schede in formato JSON

---

## Vincoli
- Utilizzare solo API moderne (SwiftUI e SwiftData)
- Focus su esperienza desktop prima di estendere a touch
- Ottimizzazione per macOS (finestre multiple, menu contestuali)
