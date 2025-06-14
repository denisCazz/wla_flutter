<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Core Package

Package core contenente tutta la logica di business condivisa e i componenti UI base riutilizzabili.

## 📁 Struttura

```
lib/
├── models/          # Modelli di dati
│   ├── user.dart   # Modello User
│   └── auth.dart   # Modelli di autenticazione
├── services/        # Servizi di business logic
│   └── auth_service.dart  # Servizio di autenticazione
├── blocs/          # State management
│   └── auth/       # BLoC per autenticazione
├── widgets/        # Widget riutilizzabili
│   ├── glass_container.dart  # Container con effetto glass
│   └── base_login_page.dart  # Pagina login base
├── theme/          # Sistema di design
│   └── app_colors.dart  # Colori e gradienti
└── core.dart       # Export principale
```

## 🧩 Componenti Principali

### Models
- **User**: Rappresenta un utente con id, email, nome e avatar
- **LoginRequest/Response**: DTOs per l'autenticazione

### Services
- **AuthService**: Gestisce l'autenticazione con dati mock
  - Login con credenziali validate
  - Logout
  - Verifica utente corrente

### BLoC
- **AuthBloc**: Gestisce lo stato di autenticazione
  - Eventi: Login, Logout, UserCheck
  - Stati: Initial, Loading, Authenticated, Unauthenticated, Error

### Widgets
- **GlassContainer**: Container con effetto glass morphism
- **GlassButton**: Pulsante con stile glass
- **BaseLoginPage**: Pagina login base estendibile

### Theme
- **AppColors**: Palette colori e gradienti predefiniti

## 🎨 Design System

Il core fornisce un design system moderno con:
- Effetti glass morphism
- Gradienti dark mode
- Palette colori tech-forward
- Componenti responsive

## 🔄 Estensibilità

Ogni componente è progettato per essere esteso:

```dart
// Estendere BaseLoginPage
class CustomLoginPage extends BaseLoginPage {
  @override
  String get welcomeMessage => 'Custom Welcome!';
  
  @override
  Color get primaryColor => CustomColors.brand;
}
```

## 📦 Dipendenze

- `flutter_bloc`: State management
- `equatable`: Equality comparison per BLoC
