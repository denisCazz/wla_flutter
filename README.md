# TechFlow - Flutter Multi-Package Architecture

Questo progetto dimostra un'architettura modulare Flutter con un core condiviso e customizzazioni client-specific.

## 🏗 Struttura del Progetto

```
wla/
├── core/                   # Package core con logiche di business condivise
│   ├── lib/
│   │   ├── models/        # Modelli di dati (User, Auth)
│   │   ├── services/      # Servizi di business logic (AuthService)
│   │   ├── blocs/         # State management con BLoC (AuthBloc)
│   │   ├── widgets/       # Widget base riutilizzabili (BaseLoginPage, GlassContainer)
│   │   └── theme/         # Colori e temi base
│   └── pubspec.yaml
├── client/                # App client con customizzazioni TechFlow
│   ├── lib/
│   │   ├── pages/         # Pagine specifiche del client
│   │   └── main.dart      # Entry point dell'app
│   └── pubspec.yaml
└── melos.yaml             # Gestione del workspace multi-package
```

## 🎨 Design System

### Core Design
- **Effetto Glass**: UI moderna con sfondo sfocato e bordi trasparenti
- **Gradients**: Sfondi dinamici con gradienti scuri moderni
- **Animazioni**: Elementi fluttuanti e transizioni fluide

### Brand TechFlow
- **Colori Primari**: 
  - Cyan brillante: `#00D4FF`
  - Viola moderno: `#7C3AED`
  - Arancione vibrante: `#FF6B35`
- **Stile**: Tech-forward con elementi glass e animazioni

## 🔐 Sistema di Autenticazione

### Credenziali di Test
```
admin@example.com / password123
user@demo.com / demo2024
test@app.com / test123
```

### Funzionalità
- ✅ Login con validazione
- ✅ Gestione stato con BLoC
- ✅ UI responsiva e moderna
- ✅ Feedback visivo per loading/errori
- ✅ Dashboard post-login

## 🚀 Come Utilizzare

### Setup
```bash
# Installa le dipendenze
melos bootstrap

# Avvia l'app client
cd client
flutter run
```

### Sviluppo
1. **Core**: Modifica i componenti base in `core/lib/`
2. **Client**: Customizza l'esperienza utente in `client/lib/`
3. **Hot Reload**: Usa `r` nel terminale per ricariche rapide

## 🏛 Architettura

### Core Package
- **Models**: Strutture dati condivise (User, LoginRequest, LoginResponse)
- **Services**: Logica di business (AuthService con dati mock)
- **BLoC**: Gestione stato reattiva (AuthBloc con eventi/stati)
- **Widgets**: Componenti UI riutilizzabili (BaseLoginPage)
- **Theme**: Sistema di colori e stili base

### Client Package
- **Customizzazione**: Estende BaseLoginPage con brand TechFlow
- **UI Specifica**: Dashboard e pagine cliente-specifiche
- **Brand Identity**: Colori, logo e messaging personalizzati

### Vantaggi
1. **Separazione delle Responsabilità**: Core business logic vs UI customization
2. **Riutilizzo**: Il core può essere condiviso tra più client
3. **Manutenibilità**: Modifiche al core si propagano a tutti i client
4. **Scalabilità**: Facile aggiungere nuovi client o funzionalità

## 🎯 Prossimi Passi

### Core Enhancements
- [ ] Integrazione API reali
- [ ] Sistema di caching
- [ ] Gestione offline
- [ ] Testing automatizzato

### Client Features
- [ ] Onboarding flow
- [ ] Settings personalizzabili
- [ ] Notifiche push
- [ ] Analytics integrato

### Multi-Client
- [ ] Secondo client con brand diverso
- [ ] White-label configuration
- [ ] Theme switching dinamico

## 🛠 Tecnologie

- **Flutter**: Framework UI cross-platform
- **BLoC**: State management pattern
- **Melos**: Gestione monorepo
- **Glass Morphism**: Design trend moderno
- **Material Design**: Componenti UI base

## 📱 Screenshots

L'app presenta:
- Login page con effetto glass e gradients
- Animazioni fluide e feedback visivo
- Dashboard moderna post-autenticazione
- Design responsive per tutte le piattaforme
