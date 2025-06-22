import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';
import 'speedy_register_page.dart';
import 'speedy_password_reset_page.dart';

class SpeedyLoginPage extends BaseLoginPage {
  const SpeedyLoginPage({super.key});

  @override
  String get appTitle => 'Speedy Pizza';
  
  @override
  String get welcomeMessage => 'Benvenuto in Speedy Pizza';
  
  @override
  String get subtitleMessage => 'Le migliori pizze di Carmagnola, veloci e gustose!';
  
  @override
  Color get primaryColor => SpeedyColors.speedyRed;
  
  @override
  String get loginButtonText => 'Accedi e Ordina';
  
  @override
  String get emailHint => 'Email o Telefono';
  
  @override
  String get passwordHint => 'Password';

  @override
  SpeedyLoginPageState createState() => SpeedyLoginPageState();
}

class SpeedyLoginPageState extends BaseLoginPageState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0000), // Rosso molto scuro
              Color(0xFF2D1810), // Marrone scuro
              Color(0xFF1A1A00), // Giallo molto scuro
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingPizzaElements(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSpeedyLogo(),
                        const SizedBox(height: 32),
                        _buildBrandTitle(),
                        const SizedBox(height: 16),
                        _buildOpeningHours(),
                        const SizedBox(height: 32),
                        _buildLoginForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPizzaElements() {
    return Stack(
      children: [
        // Elementi decorativi a tema pizza
        Positioned(
          top: 100,
          right: 50,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  SpeedyColors.speedyYellow.withOpacity(0.3),
                  SpeedyColors.speedyRed.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: Icon(
              Icons.local_pizza,
              color: SpeedyColors.speedyYellow.withOpacity(0.6),
              size: 40,
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  SpeedyColors.speedyGreen.withOpacity(0.3),
                  SpeedyColors.speedyRed.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.restaurant,
              color: SpeedyColors.speedyGreen.withOpacity(0.7),
              size: 30,
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          right: 40,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  SpeedyColors.speedyOrange.withOpacity(0.3),
                  SpeedyColors.speedyYellow.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.delivery_dining,
              color: SpeedyColors.speedyOrange.withOpacity(0.7),
              size: 35,
            ),
          ),
        ),
        // Linee decorative
        Positioned(
          top: 350,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  SpeedyColors.speedyYellow.withOpacity(0.4),
                  SpeedyColors.speedyRed.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedyLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: SpeedyColors.logoGradient,
        boxShadow: [
          BoxShadow(
            color: SpeedyColors.speedyRed.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: SpeedyColors.speedyYellow.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.local_pizza,
            size: 60,
            color: SpeedyColors.speedyRed,
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SpeedyColors.speedyRed,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => SpeedyColors.speedyGradient.createShader(bounds),
          child: Text(
            widget.welcomeMessage,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitleMessage,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOpeningHours() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: SpeedyColors.speedyGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SpeedyColors.speedyGreen.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            color: SpeedyColors.speedyGreen,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Aperto tutti i giorni 18:00 - 23:30',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return GlassContainer(
      padding: const EdgeInsets.all(28),
      backgroundColor: Colors.white.withOpacity(0.08),
      borderColor: SpeedyColors.speedyRed.withOpacity(0.3),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 28),
            _buildLoginButton(),
            const SizedBox(height: 16),
            _buildForgotPasswordLink(),
            const SizedBox(height: 16),
            _buildTestCredentials(),
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildRegisterLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.emailHint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: SpeedyColors.speedyYellow,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyRed.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyYellow.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyRed,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Inserisci email o telefono';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.passwordHint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: SpeedyColors.speedyYellow,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyRed.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyYellow.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SpeedyColors.speedyRed,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Inserisci la password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: SpeedyColors.speedyGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SpeedyColors.speedyRed.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onLoginPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.loginButtonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SpeedyPasswordResetPage(),
          ),
        );
      },
      child: Text(
        'Hai dimenticato la password?',
        style: TextStyle(
          color: SpeedyColors.speedyOrange,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SpeedyRegisterPage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SpeedyColors.speedyGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SpeedyColors.speedyGreen.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_rounded,
              color: SpeedyColors.speedyGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Non hai un account? Registrati qui!',
              style: TextStyle(
                color: SpeedyColors.speedyGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCredentials() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SpeedyColors.speedyYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SpeedyColors.speedyYellow.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: SpeedyColors.speedyYellow,
              ),
              const SizedBox(width: 8),
              const Text(
                'Account demo per testing:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'admin@example.com / password123\nuser@demo.com / demo2024',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SpeedyColors.speedyGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SpeedyColors.speedyGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_pizza,
            color: SpeedyColors.speedyOrange,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Ordina le tue pizze preferite\nConsegna rapida a Carmagnola',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
