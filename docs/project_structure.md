# 📁 Struttura Progetto DietApp

## Organizzazione Completa

```
lib/
├── main.dart                                    # Entry point
├── app/                                         # Configurazione app
│   ├── app.dart                                # MaterialApp + Providers
│   ├── app_shell.dart                          # Bottom navigation
│   ├── router.dart                             # GoRouter config
│   ├── theme.dart                              # Theme completo
│   └── platform.dart                           # Platform utilities
│
├── core/                                        # Core business logic
│   ├── models/                                 # Data models
│   │   ├── user.dart                           # User model
│   │   ├── nutrition.dart                      # MacroGoals, NutritionInfo
│   │   ├── food_item.dart                      # FoodItem model
│   │   ├── meal.dart                           # Meal model + MealType enum
│   │   └── daily_log.dart                      # DailyLog + DailyTracking
│   │
│   └── services/                               # Business logic services
│       ├── storage_service.dart                # SharedPreferences wrapper
│       └── nutrition_service.dart              # Nutrition operations
│
├── providers/                                   # State management
│   └── nutrition_provider.dart                 # Main app state
│
├── features/                                    # Features (screens + widgets)
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart               # Home page
│   │   └── widgets/
│   │       ├── calorie_ring_card.dart         # Calorie progress ring
│   │       ├── macro_pills_card.dart          # Macronutrient pills
│   │       ├── meal_card.dart                 # Meal tracker card
│   │       └── tracking_card.dart             # Daily tracking (water/fruit/veggies)
│   │
│   ├── pantry/
│   │   └── screens/
│   │       └── pantry_screen.dart
│   │
│   ├── recipes/
│   │   └── screens/
│   │       └── recipes_screen.dart
│   │
│   ├── insights/
│   │   └── screens/
│   │       └── insights_screen.dart
│   │
│   └── profile/
│       └── screens/
│           └── profile_screen.dart
│
└── pubspec.yaml                                 # Dependencies
```

---

## 🗂️ Descrizione dei Layer

### **1. App Layer** (`/app`)
Contiene tutta la configurazione dell'applicazione:
- **app.dart**: Widget principale con MultiProvider
- **theme.dart**: Colori, fonts, stili completi
- **router.dart**: Routing con go_router
- **app_shell.dart**: Bottom navigation persistente

### **2. Core Layer** (`/core`)
Business logic e modelli dati:
- **models/**: Classi dati immutabili con serializzazione JSON
- **services/**: Logica di business e persistenza dati

### **3. Providers** (`/providers`)
State management con Provider pattern:
- **nutrition_provider.dart**: Gestisce tutto lo stato dell'app (user, daily log, tracking)

### **4. Features** (`/features`)
Organizzazione per feature (ogni feature ha screens + widgets):
- **home/**: Dashboard principale
- **pantry/**: Gestione dispensa
- **recipes/**: Ricette
- **insights/**: Analytics
- **profile/**: Profilo utente

---

## 🔄 Flusso Dati

```
User Interaction (UI)
        ↓
NutritionProvider (State Management)
        ↓
NutritionService (Business Logic)
        ↓
StorageService (Persistence)
        ↓
SharedPreferences (Local Storage)
```

---

## 🎯 Come Aggiungere una Nuova Feature

### Esempio: Aggiungere "Water Tracker Screen"

1. **Crea la cartella feature**:
```
lib/features/water/
├── screens/
│   └── water_screen.dart
└── widgets/
    └── water_progress_widget.dart
```

2. **Aggiungi la route** in `app/router.dart`:
```dart
GoRoute(
  path: '/water',
  builder: (context, state) => const WaterScreen(),
),
```

3. **Aggiungi metodi al provider** se necessario:
```dart
// In nutrition_provider.dart
Future<void> addWaterLog(int ml) async {
  // logica...
  notifyListeners();
}
```

4. **Usa il provider nella UI**:
```dart
Consumer<NutritionProvider>(
  builder: (context, provider, _) {
    return Text('Water: ${provider.waterGlasses}');
  },
)
```

---

## 📦 Dipendenze Utilizzate

| Package | Scopo |
|---------|-------|
| `provider` | State management |
| `go_router` | Navigazione moderna |
| `google_fonts` | Font personalizzati |
| `shared_preferences` | Persistenza locale |
| `intl` | Formattazione date/numeri |
| `uuid` | Generazione ID univoci |

---

## 🎨 Componenti Riutilizzabili

### **CalorieRingCard**
```dart
CalorieRingCard(
  consumed: 1200,
  goal: 1848,
  burned: 300,
)
```

### **MacroPillsCard**
```dart
MacroPillsCard(
  protein: 50, proteinGoal: 92,
  carbs: 120, carbsGoal: 231,
  fats: 30, fatsGoal: 62,
)
```

### **MealCard**
```dart
MealCard(
  type: MealType.breakfast,
  meals: provider.breakfastMeals,
  onAdd: () => _showAddDialog(),
)
```

### **TrackingCard**
```dart
TrackingCard(
  waterGlasses: 4,
  fruitServings: 2,
  veggieServings: 3,
  onWaterIncrement: () => provider.incrementWater(),
  onFruitIncrement: () => provider.incrementFruit(),
  onVeggiesIncrement: () => provider.incrementVeggies(),
)
```

---

## 🚀 Setup e Run

### **1. Installa dipendenze**
```bash
flutter pub get
```

### **2. Esegui l'app**
```bash
flutter run
```

### **3. Carica dati di esempio**
Nell'app, premi il pulsante "Carica dati di esempio" nella home

---

## 🔧 Personalizzazione

### **Cambiare gli obiettivi di default**
Modifica `lib/core/services/nutrition_service.dart`:
```dart
final newUser = User(
  dailyCalorieGoal: 2000,  // Il tuo obiettivo
  macroGoals: MacroGoals(
    protein: 100,
    carbs: 250,
    fats: 70,
  ),
);
```