# Guida Nutrizionale EatWise

Questa guida spiega gli indici e i calcoli nutrizionali utilizzati nell'app EatWise per creare il tuo piano alimentare personalizzato.

---

## 📊 Indici di Riferimento

### BMI (Body Mass Index - Indice di Massa Corporea)

#### Cos'è?
Il BMI è un indice che mette in relazione il peso corporeo con l'altezza di una persona. È un valore numerico che permette di classificare il peso in diverse categorie.

#### Formula di calcolo
```
BMI = peso (kg) / (altezza (m))²
```

**Esempio:**
- Peso: 70 kg
- Altezza: 1.75 m
- BMI = 70 / (1.75 × 1.75) = 70 / 3.06 = **22.9**

#### Categorie BMI
| BMI | Categoria |
|-----|-----------|
| < 18.5 | Sottopeso |
| 18.5 - 24.9 | Normopeso |
| 25.0 - 29.9 | Sovrappeso |
| ≥ 30.0 | Obesità |

#### A cosa serve?
Il BMI è uno strumento rapido e semplice per valutare se il peso di una persona è proporzionato alla sua altezza. Viene utilizzato come indicatore generale di salute e come punto di partenza per definire obiettivi di peso realistici.

#### Perché lo usiamo nell'app?
- **Valutazione iniziale**: durante l'onboarding, calcoliamo il tuo BMI attuale
- **Obiettivi realistici**: quando imposti un peso obiettivo, verifichiamo che il BMI target sia in un range sano
- **Monitoraggio progressi**: nelle statistiche potrai vedere come cambia il tuo BMI nel tempo

⚠️ **Nota**: il BMI ha dei limiti (non considera massa muscolare, struttura ossea, etc.) ma rimane un buon indicatore generale.

---

### BMR (Basal Metabolic Rate - Metabolismo Basale)

#### Cos'è?
Il BMR rappresenta la quantità di energia (calorie) che il tuo corpo consuma **a riposo assoluto** per mantenere le funzioni vitali di base:
- Respirazione
- Circolazione sanguigna
- Regolazione della temperatura corporea
- Funzioni cellulari
- Funzioni cerebrali

È l'energia minima necessaria per sopravvivere, come se rimanessi a letto tutto il giorno senza fare nulla.

#### Formula: Mifflin-St Jeor Equation (la più accurata)

**Per gli uomini:**
```
BMR = (10 × peso_kg) + (6.25 × altezza_cm) - (5 × età) + 5
```

**Per le donne:**
```
BMR = (10 × peso_kg) + (6.25 × altezza_cm) - (5 × età) - 161
```

**Esempio (uomo, 28 anni, 70 kg, 175 cm):**
```
BMR = (10 × 70) + (6.25 × 175) - (5 × 28) + 5
BMR = 700 + 1093.75 - 140 + 5
BMR = 1658.75 kcal/giorno
```

#### A cosa serve?
Il BMR è la base di partenza per calcolare quante calorie hai bisogno ogni giorno. Sapere il tuo metabolismo basale permette di:
- Capire quanto consuma il tuo corpo naturalmente
- Evitare diete troppo restrittive (mai scendere sotto il BMR!)
- Calcolare con precisione il tuo fabbisogno calorico totale

#### Perché lo usiamo nell'app?
Il BMR è il **primo passo** dei nostri calcoli. Lo calcoliamo usando i tuoi dati personali (sesso, età, peso, altezza) per poi determinare il tuo fabbisogno calorico totale (TDEE).

---

### TDEE (Total Daily Energy Expenditure - Dispendio Energetico Totale Giornaliero)

#### Cos'è?
Il TDEE è la quantità totale di calorie che bruci in un giorno normale, considerando:
- Il tuo metabolismo basale (BMR)
- Le attività quotidiane (camminare, lavorare, muoversi)
- L'esercizio fisico programmato

È il valore che ci dice quante calorie hai bisogno per **mantenere il peso attuale**.

#### Formula di calcolo
```
TDEE = BMR × Fattore di Attività
```

#### Fattori di Attività

| Livello | Descrizione | Fattore | Esempio |
|---------|-------------|---------|---------|
| **Sedentario** | Poco o nessun esercizio, lavoro da scrivania | 1.2 | Lavoro d'ufficio, poca attività |
| **Leggermente Attivo** | Esercizio leggero 1-3 giorni/settimana | 1.375 | Camminate regolari, sport occasionale |
| **Moderatamente Attivo** | Esercizio moderato 3-5 giorni/settimana | 1.55 | Palestra 3-4 volte/settimana |
| **Molto Attivo** | Esercizio intenso 6-7 giorni/settimana | 1.725 | Allenamenti intensi quotidiani |
| **Estremamente Attivo** | Esercizio molto intenso o lavoro fisico pesante | 1.9 | Atleti professionisti, lavori molto fisici |

**Esempio (BMR 1658 kcal, moderatamente attivo):**
```
TDEE = 1658 × 1.55 = 2569.9 kcal/giorno
```

#### A cosa serve?
Il TDEE è il valore **più importante** per la gestione del peso:
- **Mantenere il peso**: mangia esattamente il tuo TDEE
- **Perdere peso**: mangia meno del tuo TDEE (deficit calorico)
- **Aumentare peso**: mangia più del tuo TDEE (surplus calorico)

#### Perché lo usiamo nell'app?
Il TDEE è la base per calcolare le tue calorie target. Una volta conosciuto il tuo TDEE, possiamo:
1. Calcolare quanto mangiare per raggiungere il tuo obiettivo
2. Adattare il piano in base ai tuoi progressi
3. Assicurarci che il deficit/surplus sia sano e sostenibile

---

## 🎯 Calcolo delle Calorie Target

### Come calcoliamo le tue calorie giornaliere

Una volta determinato il tuo TDEE, applichiamo un aggiustamento in base al tuo obiettivo:

#### 1️⃣ Perdere Peso
```
Calorie Target = TDEE - Deficit
```

**Deficit standard**: -500 kcal/giorno

**Se hai impostato un peso obiettivo**, calcoliamo un deficit personalizzato:
```
Deficit = (peso_attuale - peso_obiettivo) × 100
Deficit minimo: 300 kcal
Deficit massimo: 800 kcal
```

**Perché -500 kcal?**
- 1 kg di grasso = circa 7700 kcal
- -500 kcal/giorno = -3500 kcal/settimana = circa **0.5 kg/settimana**
- Perdita sana e sostenibile: 0.5-1 kg/settimana

**Esempio:**
- TDEE: 2570 kcal
- Obiettivo: perdere peso
- Calorie target: 2570 - 500 = **2070 kcal/giorno**

#### 2️⃣ Mantenere il Peso
```
Calorie Target = TDEE
```

Nessun aggiustamento. Mangi esattamente quanto bruci.

**Esempio:**
- TDEE: 2570 kcal
- Calorie target: **2570 kcal/giorno**

#### 3️⃣ Aumentare Massa
```
Calorie Target = TDEE + Surplus
```

**Surplus standard**: +300 kcal/giorno

**Se hai impostato un peso obiettivo**, calcoliamo un surplus personalizzato:
```
Surplus = (peso_obiettivo - peso_attuale) × 80
Surplus minimo: 200 kcal
Surplus massimo: 500 kcal
```

**Perché +300 kcal?**
- Aumento sano: 0.25-0.5 kg/settimana
- Minimizza l'accumulo di grasso
- Favorisce la crescita muscolare pulita

**Esempio:**
- TDEE: 2570 kcal
- Obiettivo: aumentare massa
- Calorie target: 2570 + 300 = **2870 kcal/giorno**

---

## 🥗 Calcolo dei Macronutrienti

I macronutrienti sono i tre componenti principali della nostra dieta:
- **Proteine** 🍗
- **Carboidrati** 🍞
- **Grassi** 🥑

### Cosa sono e a cosa servono

#### Proteine (4 kcal per grammo)
**Funzioni:**
- Costruzione e riparazione dei muscoli
- Enzimi e ormoni
- Sistema immunitario
- Sazietà prolungata

**Fonti:** carne, pesce, uova, legumi, latticini, tofu

#### Carboidrati (4 kcal per grammo)
**Funzioni:**
- Energia primaria per il corpo e il cervello
- Prestazioni atletiche
- Funzioni cognitive
- Riserve di glicogeno

**Fonti:** pane, pasta, riso, patate, frutta, verdura

#### Grassi (9 kcal per grammo)
**Funzioni:**
- Energia concentrata
- Assorbimento vitamine (A, D, E, K)
- Produzione ormoni
- Salute cellulare

**Fonti:** olio d'oliva, frutta secca, avocado, pesce grasso, uova

---

### Come calcoliamo i tuoi macro

Usiamo un approccio **protein-first** (proteine prima di tutto) perché sono il macronutriente più importante per preservare la massa muscolare durante la perdita di peso o per costruirla durante l'aumento.

#### 1️⃣ Proteine (Priority #1)
```
Proteine (g) = peso_corporeo (kg) × 2.0
```

**Perché 2g/kg?**
- Quantità ottimale per preservare/costruire muscolo
- Aumenta la sazietà
- Supporta il recupero
- Effetto termico elevato (brucia più calorie durante la digestione)

**Esempio (70 kg):**
```
Proteine = 70 × 2.0 = 140g
Calorie da proteine = 140 × 4 = 560 kcal
```

#### 2️⃣ Grassi (Priority #2)
```
Grassi (g) = peso_corporeo (kg) × 0.8
```

**Perché 0.8g/kg?**
- Minimo per salute ormonale: 0.6g/kg
- 0.8g/kg è un buon bilanciamento
- Permette flessibilità con i carboidrati

**Esempio (70 kg):**
```
Grassi = 70 × 0.8 = 56g
Calorie da grassi = 56 × 9 = 504 kcal
```

#### 3️⃣ Carboidrati (Riempiono il resto)
```
Calorie rimanenti = Calorie_target - (Proteine_kcal + Grassi_kcal)
Carboidrati (g) = Calorie_rimanenti / 4
```

**Esempio completo (2070 kcal target, 70 kg):**
```
Proteine: 140g = 560 kcal
Grassi: 56g = 504 kcal
Totale fisso: 1064 kcal

Calorie rimanenti: 2070 - 1064 = 1006 kcal
Carboidrati: 1006 / 4 = 251.5g ≈ 252g
```

### Riassunto Macro
```
🍗 Proteine: 140g (560 kcal - 27%)
🍞 Carboidrati: 252g (1008 kcal - 49%)
🥑 Grassi: 56g (504 kcal - 24%)

Totale: 2072 kcal
```

---

## 📈 Adattamenti nel Tempo

### Ricalcolo automatico
L'app ricalcola automaticamente i tuoi macro quando:
- Perdi o guadagni peso (cambiano le proteine e i grassi)
- Cambi livello di attività (cambia il TDEE)
- Modifichi il tuo obiettivo

### Progressi verso l'obiettivo
Se hai impostato un peso obiettivo, l'app calcola:
- **Tempo stimato**: quante settimane/mesi servono
- **Ritmo sano**: 0.5-0.75 kg/settimana (perdita) o 0.25-0.4 kg/settimana (aumento)

---

## ❓ FAQ

### Posso mangiare meno del mio BMR?
**NO!** Scendere sotto il BMR può:
- Rallentare il metabolismo
- Causare perdita di massa muscolare
- Provocare carenze nutrizionali
- Non è sostenibile nel lungo termine

### Devo colpire esattamente i macro ogni giorno?
L'ideale è rispettare le calorie totali e avvicinarsi ai macro. Piccole variazioni giornaliere sono normali. Guarda la media settimanale.

### Cosa succede se non raggiungo le proteine?
Le proteine sono le più importanti. Cerca di raggiungerle il più possibile per:
- Preservare la massa muscolare
- Mantenerti sazio
- Ottimizzare i risultati

### I macro cambiano se faccio sport?
Il tuo TDEE tiene già conto del tuo livello di attività. Non serve "mangiare di più" nei giorni di allenamento a meno che tu non faccia attività estreme.

### Quanto tempo serve per vedere risultati?
- **Perdita peso**: primi risultati visibili in 2-3 settimane
- **Aumento massa**: primi cambiamenti in 4-6 settimane
- **Mantenimento**: stabilità in 1-2 settimane

---

## 🎯 Conclusione

EatWise usa metodi scientificamente provati per creare un piano nutrizionale:
1. **Personalizzato** sui tuoi dati (sesso, età, peso, altezza, attività)
2. **Basato sulla scienza** (formule validate)
3. **Sicuro e sostenibile** (deficit/surplus sani)
4. **Adattabile** nel tempo

Ricorda: la costanza è più importante della perfezione! 💪

---

*Ultima revisione: Gennaio 2025*
