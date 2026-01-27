# 🚀 Quick Implementation Guide

## 📦 File da Copiare

### 1. Nuovi File (da creare)

**Models:**
```
lib/core/models/
├── daily_log.dart                 ← COPIA
└── consumed_product.dart          ← COPIA
```

**Repositories:**
```
lib/core/repositories/
├── product_repository.dart        ← COPIA
└── mock_product_repository.dart   ← COPIA
```

**Features:**
```
lib/features/meals/
├── screens/
│   └── add_meal_products_screen.dart    ← COPIA
└── widgets/
    ├── quantity_selector.dart           ← COPIA
    └── selected_products_list.dart      ← COPIA
```

### 2. File da Sostituire

```
lib/providers/
└── nutrition_provider.dart        ← SOSTITUISCI

lib/features/home/
├── screens/
│   └── home_screen.dart          ← SOSTITUISCI
└── widgets/
    └── meal_card.dart            ← SOSTITUISCI

lib/app/
└── router.dart                    ← SOSTITUISCI
```

---

## 🎯 Test Rapido

1. **Start app**: `flutter run`

2. **Naviga alla Home**

3. **Tap sul pulsante + di un pasto**
   - Dovrebbe aprire `AddMealProductsScreen`

4. **Cerca un prodotto** (es: "pasta")
   - Dovrebbe mostrare risultati dopo ~300ms

5. **Tap su un prodotto**
   - Dovrebbe aggiungerlo alla lista con quantità default
   - Dovrebbe mostrare snackbar di conferma

6. **Modifica quantità**
   - Usa i bottoni +/- o digita direttamente
   - Cambia unità di misura dal dropdown

7. **Tap "Salva (N)"** (FAB in basso)
   - Dovrebbe tornare alla Home
   - I prodotti dovrebbero apparire nel pasto

8. **Verifica calorie aggiornate**
   - Il ring dovrebbe mostrare le calorie totali aggiornate
   - Le macro pill dovrebbero aggiornarsi

---

## ⚠️ Troubleshooting

### Errore: "Cannot find import"
**Soluzione**: Verifica di aver copiato tutti i file nella struttura corretta

### Errore: "MealType is not defined"
**Soluzione**: Aggiungi import: `import 'package:dietapp/core/models/meal.dart';`

### Errore: "ConsumedProduct is not defined"
**Soluzione**: Verifica di aver copiato `consumed_product.dart` in `lib/core/models/`

### Screen non si apre al tap
**Soluzione**: Verifica che `router.dart` sia stato aggiornato correttamente

### Prodotti non si salvano
**Soluzione**: Controlla console per errori. Verifica che `nutrition_provider.dart` sia aggiornato

---

## 🔧 Configurazione Dependencies

Aggiungi a `pubspec.yaml` se mancano:

```yaml
dependencies:
  uuid: ^4.0.0
  provider: ^6.0.0
  go_router: ^10.0.0
  intl: ^0.18.0
```

Poi: `flutter pub get`

---

## 📱 Features Testate

✅ Navigazione a schermata
✅ Ricerca prodotti
✅ Aggiunta prodotto
✅ Modifica quantità
✅ Cambio unità misura
✅ Rimozione prodotto
✅ Salvataggio nel pasto
✅ Calcolo calorie totali
✅ Update ring e macro pills

---

## 🎨 UI Placeholder (TODO Backend)

### Barcode Scanner
- Tap su "Barcode" → Mostra dialog placeholder
- **TODO**: Implementare con `mobile_scanner` package + API call

### Photo Search
- Tap su "Foto" → Mostra dialog placeholder
- **TODO**: Implementare con `image_picker` + Image Recognition API

---

## ✅ Success Criteria

Se tutto funziona correttamente:
1. ✅ Puoi navigare alla schermata di aggiunta prodotti
2. ✅ Puoi cercare e vedere risultati mock
3. ✅ Puoi aggiungere prodotti con 1 tap
4. ✅ Puoi modificare quantità facilmente
5. ✅ I prodotti vengono salvati nel pasto
6. ✅ Le calorie si aggiornano correttamente
7. ✅ Il flow è fluido senza lag

---

## 📞 Next Steps

1. **Testa tutto il flow** ✅
2. **Personalizza UI** (opzionale - colori, spacing, etc.)
3. **Prepara backend** (vedi README.md sezione TODO)
4. **Implementa barcode scanner** (quando pronto)
5. **Implementa photo search** (quando pronto)
6. **Sostituisci MockRepository** con API reale

---

**Tempo stimato implementazione**: 5-10 minuti (solo copy-paste files)

**Tempo stimato test**: 5 minuti

**Totale**: ~15 minuti per essere operativo! 🚀
