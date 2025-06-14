import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'pages/speedy_login_page.dart';
import 'pages/speedy_dashboard_page.dart';
import 'theme/speedy_colors.dart';

void main() {
  runApp(const SpeedyPizzaApp());
}

class SpeedyPizzaApp extends StatelessWidget {
  const SpeedyPizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthUserCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Speedy Pizza',
        theme: ThemeData(
          primaryColor: SpeedyColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: SpeedyColors.primary,
            primary: SpeedyColors.primary,
            secondary: SpeedyColors.secondary,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            backgroundColor: SpeedyColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: SpeedyColors.primary,
              ),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return const SpeedyDashboardPage();
        } else {
          return const SpeedyLoginPage();
        }
      },
    );
  }
}


