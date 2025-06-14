import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'pages/techflow_login_page.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(const TechFlowApp());
}

class TechFlowApp extends StatelessWidget {
  const TechFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthUserCheckRequested()),
      child: MaterialApp(
        title: 'TechFlow',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          fontFamily: 'SF Pro Display',
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
          return const LoadingPage();
        } else if (state is AuthAuthenticated) {
          return const DashboardPage();
        } else {
          return const TechFlowLoginPage();
        }
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A1A),
              Color(0xFF1A0A2E),
              Color(0xFF0F2027),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF00D4FF),
              ),
              SizedBox(height: 24),
              Text(
                'TechFlow',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Caricamento in corso...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB4B6C7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
