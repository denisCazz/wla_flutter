# TechFlow Client App

App client che implementa il brand TechFlow utilizzando il core package condiviso.

## 🎨 Brand Identity

### TechFlow
Brand tecnologico moderno con focus su:
- **Innovazione**: Colori brillanti e design futuristico
- **Professionalità**: UI pulita e funzionale
- **Modernità**: Effetti glass e animazioni fluide

### Palette Colori
```dart
// Colori brand TechFlow
static const Color brandPrimary = Color(0xFF00D4FF);   // Cyan brillante
static const Color brandSecondary = Color(0xFF7C3AED); // Viola moderno  
static const Color brandAccent = Color(0xFFFF6B35);    // Arancione vibrante
```

## 🏗 Struttura

```
lib/
├── main.dart              # Entry point dell'app
└── pages/
    ├── techflow_login_page.dart  # Login personalizzato TechFlow
    └── dashboard_page.dart       # Dashboard post-login
```

## 🎯 Customizzazioni

### Login Page
- Estende `BaseLoginPage` dal core
- Brand colors e messaging personalizzati
- Animazioni e effetti specifici TechFlow
- Logo e elementi grafici brand

### Dashboard
- UI moderna con cards glass
- Quick actions personalizzate
- Profilo utente integrato
- Navigazione brand-consistent

## 🚀 Features

### Autenticazione
- Login con validazione real-time
- Feedback visivo per errori
- Loading states eleganti
- Gestione sessione automatica

### UI/UX
- Design responsive
- Animazioni fluide
- Glass morphism effects
- Dark theme moderno

### Dashboard
- Informazioni utente
- Quick actions
- Layout modulare
- Logout integrato

## 🔧 Configurazione

### Dipendenze
```yaml
dependencies:
  core:
    path: ../core
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
```

### Setup
```bash
# Installa dipendenze
flutter pub get

# Avvia app
flutter run
```

## 🎮 Testing

### Credenziali Demo
- `admin@example.com` / `password123`
- `user@demo.com` / `demo2024`  
- `test@app.com` / `test123`

### Flow di Test
1. Avvia l'app
2. Inserisci credenziali di test
3. Verifica login e navigazione dashboard
4. Testa logout e ritorno al login

## 🎨 Design Guidelines

### Colori
- Usa sempre i brand colors per elementi primari
- Mantieni coerenza con il core per elementi base
- Applica gradients per elementi hero

### Typography
- Titoli bold per gerarchie importanti
- Text secondario per descrizioni
- Monospace per credenziali e codici

### Spacing
- Padding standard 24px per containers
- Margini 16px tra elementi correlati
- Gap 8px per elementi inline

### Animazioni
- Transizioni smooth (300ms)
- Easing curves naturali
- Feedback immediato per interazioni

## 🔄 Estensioni Future

### Features
- [ ] Onboarding multi-step
- [ ] Settings personalizzabili
- [ ] Notifiche push
- [ ] Tema chiaro/scuro

### Integrations
- [ ] Analytics
- [ ] Crash reporting
- [ ] API reali
- [ ] Offline support
