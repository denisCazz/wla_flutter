import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../models/auth.dart';
import '../../services/auth_service.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserCheckRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final RegisterRequest registerRequest;

  const AuthRegisterRequested({required this.registerRequest});

  @override
  List<Object> get props => [registerRequest];
}

class AuthPasswordResetRequested extends AuthEvent {
  final PasswordResetRequest resetRequest;

  const AuthPasswordResetRequested({required this.resetRequest});

  @override
  List<Object> get props => [resetRequest];
}

class AuthTokenRefreshRequested extends AuthEvent {
  final String refreshToken;

  const AuthTokenRefreshRequested({required this.refreshToken});

  @override
  List<Object> get props => [refreshToken];
}

// Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String accessToken;
  final LoginResponse loginResponse;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
    required this.loginResponse,
  });

  @override
  List<Object> get props => [user, accessToken, loginResponse];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthPasswordResetSuccess extends AuthState {}

class AuthRegistrationSuccess extends AuthState {
  final User user;

  const AuthRegistrationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

// Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({AuthService? authService})
      : _authService = authService ?? AuthService(),
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserCheckRequested>(_onUserCheckRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );
      
      final response = await _authService.login(loginRequest);
      
      emit(AuthAuthenticated(
        user: response.user,
        accessToken: response.accessToken,
        loginResponse: response,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUserCheckRequested(
    AuthUserCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        // Crea una LoginResponse mock per compatibilità
        final mockResponse = LoginResponse(
          user: user,
          accessToken: 'existing_token',
          expiresAt: DateTime.now().add(const Duration(hours: 8)),
          sessionInfo: SessionInfo(
            sessionId: 'existing_session',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        );
        
        emit(AuthAuthenticated(
          user: user,
          accessToken: 'existing_token',
          loginResponse: mockResponse,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final response = await _authService.register(event.registerRequest);
      
      emit(AuthRegistrationSuccess(user: response.user));
      
      // Dopo la registrazione, effettua il login automatico
      emit(AuthAuthenticated(
        user: response.user,
        accessToken: response.accessToken,
        loginResponse: response,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authService.resetPassword(event.resetRequest);
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _authService.refreshToken(event.refreshToken);
      
      emit(AuthAuthenticated(
        user: response.user,
        accessToken: response.accessToken,
        loginResponse: response,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
