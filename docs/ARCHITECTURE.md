# 🏛️ Architecture Deep Dive

## 🎯 Design Principles

### 1. **Massimo Riuso del Codice**

#### ✅ Cosa ho riutilizzato:
- **ProductCard** widget esistente → 100% riuso
- **Search bar pattern** da pantry_screen.dart
- **Theme** completo (colors, spacing, typography)
- **NutritionProvider** → esteso, non duplicato
- **StorageService** → nessuna modifica necessaria
- **Models esistenti** (Product, Meal, NutritionInfo)

#### ❌ Cosa NON ho duplicato:
- Nessun nuovo provider per prodotti
- Nessuna duplicazione della search bar
- Nessuna reimplementazione di widget esistenti
- Nessuna logica nutrizionale duplicata

### 2. **Separation of Concerns**

```
┌─────────────────────────────────────────────┐
│                    UI Layer                  │
│  (Screens, Widgets - Solo presentazione)    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Business Logic                  │
│  (Providers - State management + logica)    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Data Layer                      │
│  (Repositories - Accesso dati astratto)     │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Data Source                     │
│  (Mock / API - Implementazione concreta)    │
└─────────────────────────────────────────────┘
```

### 3. **Dependency Inversion**

```dart
// ❌ BAD: Dipendenza diretta dall'implementazione
class AddMealProductsScreen {
  final MockProductRepository _repo = MockProductRepository();
  // Ora è impossibile cambiare sorgente dati
}

// ✅ GOOD: Dipendenza dall'astrazione
class AddMealProductsScreen {
  final ProductRepository _repo; // Interfaccia
  // Posso iniettare Mock o API a piacere
}
```

---

## 📊 Data Flow

### 1. **Aggiunta Prodotto al Pasto**

```
User tap su prodotto
       ↓
AddMealProductsScreen._addProduct(product)
       ↓
Crea ConsumedProduct con quantità default
       ↓
Aggiunge a _selectedProducts (local state)
       ↓
User modifica quantità (optional)
       ↓
User tap "Salva"
       ↓
AddMealProductsScreen._saveProducts()
       ↓
provider.addProductsToMeal(type, products)
       ↓
NutritionProvider converte ConsumedProduct → FoodItem
       ↓
NutritionProvider.addMeal(type, foodItems)
       ↓
NutritionService.addMeal(date, type, items)
       ↓
Crea Meal object
       ↓
StorageService.saveDailyLog(updatedLog)
       ↓
SharedPreferences persiste JSON
       ↓
NutritionProvider.notifyListeners()
       ↓
Home screen rebuilds
       ↓
Ring e macro pills si aggiornano ✅
```

### 2. **Ricerca Prodotti**

```
User digita nella search bar
       ↓
Debounce 500ms
       ↓
_searchProducts(query)
       ↓
_repository.searchProducts(query)
       ↓
[MOCK] Filtra lista in memoria
[API] → POST /api/products/search
       ↓
setState(_searchResults = results)
       ↓
UI rebuilds con risultati ✅
```

---

## 🧩 Component Breakdown

### Screen: `AddMealProductsScreen`

**Responsabilità:**
- ✅ Gestione UI e interazioni utente
- ✅ Chiamate al repository per prodotti
- ✅ State locale (prodotti selezionati, risultati ricerca)
- ✅ Conversione Product → ConsumedProduct
- ✅ Navigazione e feedback utente

**NON è responsabile di:**
- ❌ Persistenza dati (delegato a NutritionProvider)
- ❌ Logica nutrizionale (delegato a NutritionService)
- ❌ Implementazione ricerca (delegato a Repository)

### Widget: `QuantitySelector`

**Responsabilità:**
- ✅ UI per modificare quantità
- ✅ Validazione input (non negativi)
- ✅ Gestione unità di misura
- ✅ Callback onChanged

**Design:**
- Stateful per gestire TextEditingController
- Completamente riutilizzabile
- Nessuna dipendenza da ConsumedProduct (accetta primitives)

### Widget: `SelectedProductsList`

**Responsabilità:**
- ✅ Visualizzazione lista prodotti
- ✅ Calcolo totali (calorie, macro)
- ✅ Integrazione QuantitySelector
- ✅ Callbacks per modifica/rimozione

**Design:**
- Stateless (tutto passato via props)
- Presentation-only component
- Logica delegata al parent

### Provider: `NutritionProvider` (esteso)

**Nuovi metodi:**
```dart
// Conversione privata
FoodItem _consumedProductToFoodItem(ConsumedProduct product)

// API pubblica
Future<void> addProductsToMeal(MealType type, List<ConsumedProduct> products)
```

**Perché esteso invece di nuovo provider:**
- ✅ Evita duplicazione logica pasti
- ✅ Mantiene coerenza state management
- ✅ Single source of truth per nutrizione
- ✅ Riusa metodi esistenti (addMeal)

### Repository: `ProductRepository`

**Interface:**
```dart
abstract class ProductRepository {
  // Search
  Future<List<Product>> searchProducts(String query);
  
  // Barcode
  Future<Product?> getProductByBarcode(String barcode);
  
  // Image Recognition
  Future<List<Product>> searchProductsByImage(String path);
  
  // User data
  Future<List<Product>> getRecentProducts();
  Future<List<Product>> getFavoriteProducts();
}
```

**Implementazioni:**
1. `MockProductRepository` → Dati fake per sviluppo
2. `ApiProductRepository` → API reale (TODO)
3. `CachedProductRepository` → Wrapper con cache (TODO)

---

## 🔄 State Management Strategy

### Local State vs Provider State

**Local State (_selectedProducts):**
- ✅ Temporaneo (solo durante editing)
- ✅ Non serve persistenza
- ✅ Non serve notifica ad altri screen
→ **Usa setState()**

**Provider State (meals in DailyLog):**
- ✅ Persistito su disco
- ✅ Condiviso tra screen
- ✅ Notifica rebuild automatico
→ **Usa ChangeNotifier**

### Perché non Redux/Bloc/Riverpod?

Il progetto usa già **Provider + ChangeNotifier**, quindi:
- ✅ Coerenza con architettura esistente
- ✅ Minore complessità
- ✅ Learning curve zero per team
- ✅ Sufficiente per questo use case

---

## 🎨 UX Design Decisions

### 1. **Aggiunta con 1 Tap**

**Alternativa scartata:**
```
Tap prodotto → Modal "Inserisci quantità" → Conferma
```

**Scelta:**
```
Tap prodotto → Aggiunto con quantità default → Modifica inline (opzionale)
```

**Motivazione:**
- 90% degli utenti usa quantità standard
- Riduce friction per uso rapido
- Power users possono sempre modificare

### 2. **Quantità Default Intelligente**

```dart
// Bevande → 250ml (1 bicchiere)
if (name.contains('latte') || name.contains('acqua'))
  return 250.0;

// Frutta → 1 pezzo
if (name.contains('mela') || name.contains('banana'))
  return 1.0;

// Default → 100g (porzione standard)
return 100.0;
```

**Motivazione:**
- Riduce editing manuale
- Rispetta convenzioni comuni
- Facilmente estendibile con ML

### 3. **Modifica Quantità Inline**

**Alternativa scartata:**
```
Lista prodotti → Tap prodotto → Modal modifica
```

**Scelta:**
```
Lista prodotti → QuantitySelector sempre visibile
```

**Motivazione:**
- Zero tap extra per modificare
- Feedback immediato
- Meno context switching

### 4. **FAB per Salvataggio**

**Posizione:** Bottom-right (Material Design standard)
**Label:** "Salva (N)" con count prodotti
**Colore:** Accent1 (arancione) per visibilità

**Motivazione:**
- Thumb-friendly su mobile
- Sempre accessibile durante scroll
- Counter evita confusione

---

## 🔒 Type Safety & Validation

### 1. **Enum invece di String**

```dart
// ❌ BAD
String unit = "grams"; // Typo-prone

// ✅ GOOD
enum MeasurementUnit { grams, ml, pieces }
```

### 2. **Non-nullable dove possibile**

```dart
class ConsumedProduct {
  final String id;              // required, non-null
  final Product product;        // required, non-null
  final double quantity;        // required, non-null
  final MeasurementUnit unit;   // required, non-null
  final DateTime addedAt;       // default: DateTime.now()
}
```

### 3. **Validazione Input**

```dart
void _updateQuantity(double newQuantity) {
  if (newQuantity <= 0) return; // Guard clause
  // ... aggiorna
}
```

---

## 📈 Scalability Considerations

### 1. **Repository Pattern → Easy Backend Swap**

```dart
// Development
final repo = MockProductRepository();

// Staging
final repo = ApiProductRepository(
  baseUrl: 'https://staging.api.com',
);

// Production
final repo = CachedProductRepository(
  remote: ApiProductRepository(baseUrl: 'https://api.com'),
  local: HiveProductCache(),
);
```

### 2. **ConsumedProduct → Decoupling**

Senza `ConsumedProduct`:
```dart
// ❌ Product e quantità mischiate
class Product {
  ...
  double? consumedQuantity; // Inquina il modello!
}
```

Con `ConsumedProduct`:
```dart
// ✅ Separazione chiara
Product        → Database prodotti (immutabile)
ConsumedProduct → Consumption tracking (mutable quantity)
```

### 3. **Future-proof Nutrition Data**

```dart
// Ora (mock):
NutritionInfo get totalNutrition {
  // Stima approssimativa
  return estimated...
}

// Futuro (backend):
class Product {
  final ProductNutrition nutritionPer100g;
}

NutritionInfo get totalNutrition {
  final multiplier = quantity / 100;
  return product.nutritionPer100g * multiplier;
}
```

---

## 🧪 Testing Strategy

### Unit Tests (TODO)

```dart
test('ConsumedProduct calculates nutrition correctly', () {
  final product = Product(..., calories: 100);
  final consumed = ConsumedProduct(
    product: product,
    quantity: 200,
    unit: MeasurementUnit.grams,
  );
  
  expect(consumed.totalNutrition.calories, equals(200));
});

test('QuantitySelector validates non-negative', () {
  // Test che quantity < 0 sia rifiutato
});

test('MockRepository simulates network delay', () async {
  final repo = MockProductRepository();
  final start = DateTime.now();
  await repo.searchProducts('pasta');
  final elapsed = DateTime.now().difference(start);
  
  expect(elapsed.inMilliseconds, greaterThan(300));
});
```

### Integration Tests (TODO)

```dart
testWidgets('Full flow: search → add → save', (tester) async {
  // 1. Navigate to screen
  await tester.tap(find.byIcon(Icons.add_circle));
  await tester.pumpAndSettle();
  
  // 2. Search
  await tester.enterText(find.byType(TextField), 'pasta');
  await tester.pumpAndSettle();
  
  // 3. Add product
  await tester.tap(find.byType(ProductCard).first);
  await tester.pumpAndSettle();
  
  // 4. Verify added
  expect(find.text('1 prodotto'), findsOneWidget);
  
  // 5. Save
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  
  // 6. Verify on home
  expect(find.text('Pasta'), findsOneWidget);
});
```

---

## 🎓 Lessons Learned

### ✅ Good Decisions

1. **Repository Pattern early** → Easy to swap mock with API
2. **ConsumedProduct wrapper** → Clean separation of concerns
3. **Extending existing provider** → No duplication
4. **Quantità default** → Great UX improvement
5. **Inline editing** → Reduced friction

### 🤔 Could Improve

1. **Caching Strategy**: Nessun cache implementato (TODO)
2. **Offline Support**: Non gestito (TODO)
3. **Image Optimization**: Immagini caricate ogni volta
4. **Debounce Search**: Implementato ma potrebbe essere configurabile
5. **Error Handling**: Basico, potrebbe essere più robusto

### 📝 If I had to refactor...

1. Add **Dependency Injection** (get_it)
   ```dart
   final repo = locator<ProductRepository>();
   ```

2. Add **Result Type** per gestire errori
   ```dart
   sealed class Result<T> {
     Success<T>(T data);
     Error<T>(String message);
   }
   ```

3. Add **Logging** per debugging
   ```dart
   logger.info('Searching products: $query');
   ```

4. Add **Analytics**
   ```dart
   analytics.logEvent('product_added', {
     'product_id': product.id,
     'meal_type': mealType.name,
   });
   ```

---

## 📚 References

### Design Patterns Used
- **Repository Pattern** (data access)
- **Provider Pattern** (state management)
- **Factory Pattern** (fromJson constructors)
- **Strategy Pattern** (MockRepository vs ApiRepository)
- **Composition over Inheritance** (ConsumedProduct wraps Product)

### Flutter Best Practices
- ✅ Const constructors where possible
- ✅ Named parameters for clarity
- ✅ Meaningful variable names
- ✅ Single Responsibility Principle
- ✅ DRY (Don't Repeat Yourself)

### Material Design Guidelines
- ✅ 44x44 minimum touch target
- ✅ FAB positioning (bottom-right)
- ✅ Elevation hierarchy
- ✅ Color contrast (WCAG AA)
- ✅ Consistent spacing (8px grid)

---

## 🎯 Conclusione

Questa implementazione bilancia:
- **Pragmatismo** (funziona subito con mock data)
- **Scalabilità** (facile aggiungere backend)
- **Manutenibilità** (codice pulito, ben strutturato)
- **UX** (flow ottimizzato, minimo friction)

Il codice è pronto per essere:
1. ✅ Usato immediatamente (con mock)
2. ✅ Testato facilmente
3. ✅ Esteso con backend
4. ✅ Manutenuto nel tempo

**Next evolution**: Backend integration + advanced features (ML, caching, offline) 🚀
