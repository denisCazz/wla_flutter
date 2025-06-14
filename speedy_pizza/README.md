# 🍕 Speedy Pizza - App di Ordinazione Online

![Speedy Pizza Logo](https://img.shields.io/badge/Speedy%20Pizza-🍕-red)
![Flutter](https://img.shields.io/badge/Flutter-3.32.4-blue)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue)

Un'app Flutter moderna per l'ordinazione online di pizze della Pizzeria Speedy Pizza di Carmagnola.

## 🌟 Caratteristiche

### 🎨 Design e UI
- **Glass Morphism**: Interfaccia moderna con effetti vetro
- **Tema Rosso/Oro**: Colori che richiamano l'Italia e la pizza
- **Animazioni**: Transizioni fluide e micro-interazioni
- **Responsive**: Funziona su mobile, tablet e web

### 🍕 Funzionalità Pizza
- **Menu Completo**: Oltre 10 varietà di pizza incluse specialità di Carmagnola
- **Categorie**: Pizze Classiche, Vegetariane, Specialità locali
- **Personalizzazione**: Selezione dimensioni (Piccola, Media, Grande)
- **Ingredienti Extra**: Aggiunta di ingredienti opzionali
- **Ricerca e Filtri**: Trova facilmente la tua pizza preferita

### 📱 Gestione Ordini
- **Carrello Intelligente**: Aggiungi, modifica e rimuovi pizze
- **Stato Ordini**: Tracciamento in tempo reale (In Preparazione, In Forno, Pronta, Consegnata)
- **Cronologia**: Visualizza tutti i tuoi ordini passati
- **Riordina**: Ripeti facilmente gli ordini precedenti
- **Annullamento**: Cancella ordini entro 5 minuti

### 👤 Autenticazione
- **Login Sicuro**: Sistema di autenticazione con email/password
- **Gestione Profilo**: Informazioni utente e preferenze
- **Sessioni Persistenti**: Rimani collegato tra le sessioni

## 🚀 Come Iniziare

### Prerequisiti
- Flutter 3.32.4 o superiore
- Dart 3.0 o superiore
- Melos per la gestione multi-package

### Installazione

1. **Clona il repository**
```bash
git clone <repository-url>
cd wla
```

2. **Installa Melos**
```bash
flutter pub global activate melos
```

3. **Bootstrap del workspace**
```bash
melos bootstrap
```

4. **Esegui l'app**
```bash
cd speedy_pizza
flutter run
```

### Piattaforme Supportate
- ✅ **Web** (Chrome, Safari, Firefox)
- ⏳ **iOS** (iPhone, iPad) - In configurazione
- ⏳ **Android** (Phone, Tablet) - Richiede Android Studio
- ✅ **macOS** (Desktop)

## 🍕 Menu Pizze

### Classiche
- **Margherita** - Pomodoro, mozzarella, basilico (€8.50)
- **Marinara** - Pomodoro, aglio, origano (€7.00)
- **Diavola** - Pomodoro, mozzarella, salame piccante (€9.50)
- **Prosciutto** - Pomodoro, mozzarella, prosciutto cotto (€9.00)

### Vegetariane
- **Vegetariana** - Pomodoro, mozzarella, verdure miste (€10.00)
- **Funghi** - Pomodoro, mozzarella, funghi porcini (€9.50)
- **Capricciosa** - Pomodoro, mozzarella, carciofi, olive (€11.00)

### Specialità di Carmagnola
- **Carmagnola DOC** - Con peperoni locali di Carmagnola IGP (€12.50)
- **Speedy Special** - La pizza signature del locale (€13.00)
- **Quattro Stagioni** - Rappresenta le quattro stagioni del Piemonte (€11.50)

## 🛠️ Sviluppo

### Struttura Multi-Package
```
wla/
├── core/                    # Business logic condivisa
│   ├── models/             # User, Pizza, PizzaOrder
│   ├── services/           # AuthService, PizzaService
│   ├── blocs/              # AuthBloc per state management
│   └── widgets/            # BaseLoginPage, GlassContainer
├── speedy_pizza/           # Client Speedy Pizza
└── client/                 # Client TechFlow (esempio)
```

### Componenti Principali

#### SpeedyLoginPage
- Glass morphism con tema rosso/oro
- Animazioni pizza e fulmini
- Orari di apertura: Lun-Dom 18:00-24:00
- Validazione email/password

#### SpeedyDashboardPage
- Bottom navigation (Home, Menu, Ordini, Profilo)
- Informazioni utente e quick actions
- Statistiche ordini personalizzate

#### PizzaMenuPage
- Grid responsive con 10+ pizze
- Ricerca in tempo reale
- Filtri: Tutte, Classiche, Vegetariane, Specialità
- Modal personalizzazione dimensioni/extra

#### MyOrdersPage
- Lista ordini con stati colorati
- Filtri per stato ordine
- Azioni: cancella (entro 5min), riordina
- Card design moderne

## 🎯 Stato Attuale

### ✅ Completato
- [x] Architettura multi-package con core condiviso
- [x] Sistema autenticazione BLoC
- [x] UI completa con glass morphism
- [x] Menu pizze con ricerca/filtri
- [x] Gestione ordini con stati
- [x] Tema personalizzato Speedy Pizza
- [x] App funzionante su web

### 🔄 In Corso
- [ ] Download runtime iOS (7% completato)
- [ ] Configurazione simulatore iPhone

### 📋 Prossimi Passi
- [ ] Implementazione carrello completo
- [ ] Flow di pagamento
- [ ] Notifiche ordini
- [ ] Test su iOS/Android

## 📱 Test

L'app è attualmente testabile su:
- **Web**: `flutter run -d chrome`
- **macOS**: `flutter run -d macos`

## 👨‍💻 Autore

**Denis** - Sviluppatore Flutter specializzato in architetture multi-package

---

**Speedy Pizza** - *La vera pizza di Carmagnola, ora a portata di app* 🍕⚡
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
