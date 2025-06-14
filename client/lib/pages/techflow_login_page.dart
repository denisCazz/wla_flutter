import 'package:flutter/material.dart';
import 'package:core/core.dart';

class BrandColors {
  // Brand fittizio: "TechFlow" - Colori moderni per un'app tech
  static const Color brandPrimary = Color(0xFF00D4FF); // Cyan brillante
  static const Color brandSecondary = Color(0xFF7C3AED); // Viola moderno
  static const Color brandAccent = Color(0xFFFF6B35); // Arancione vibrante
  
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPrimary, brandSecondary],
  );
}

class TechFlowLoginPage extends BaseLoginPage {
  const TechFlowLoginPage({super.key});

  @override
  String get appTitle => 'TechFlow';
  
  @override
  String get welcomeMessage => 'Benvenuto in TechFlow';
  
  @override
  String get subtitleMessage => 'La piattaforma del futuro per la gestione digitale';
  
  @override
  Color get primaryColor => BrandColors.brandPrimary;
  
  @override
  String get loginButtonText => 'Accedi a TechFlow';
  
  @override
  String get emailHint => 'Email aziendale';
  
  @override
  String get passwordHint => 'Password sicura';

  @override
  TechFlowLoginPageState createState() => TechFlowLoginPageState();
}

class TechFlowLoginPageState extends BaseLoginPageState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A1A), // Blu scuro profondo
              Color(0xFF1A0A2E), // Viola scuro
              Color(0xFF0F2027), // Verde scuro
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildAnimatedBackground(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBrandLogo(),
                        const SizedBox(height: 32),
                        _buildBrandTitle(),
                        const SizedBox(height: 48),
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

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Forme animate di sfondo
        Positioned(
          top: 80,
          right: 40,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  BrandColors.brandPrimary.withOpacity(0.3),
                  BrandColors.brandPrimary.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 180,
          left: 20,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  BrandColors.brandAccent.withOpacity(0.3),
                  BrandColors.brandSecondary.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 60,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  BrandColors.brandSecondary.withOpacity(0.2),
                  BrandColors.brandPrimary.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        // Linee decorative
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  BrandColors.brandPrimary.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: BrandColors.brandGradient,
        boxShadow: [
          BoxShadow(
            color: BrandColors.brandPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.flash_on_rounded,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBrandTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => BrandColors.brandGradient.createShader(bounds),
          child: Text(
            widget.welcomeMessage,
            style: const TextStyle(
              fontSize: 32,
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
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      backgroundColor: Colors.white.withOpacity(0.05),
      borderColor: BrandColors.brandPrimary.withOpacity(0.2),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 32),
            _buildLoginButton(),
            const SizedBox(height: 16),
            _buildTestCredentials(),
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
          Icons.alternate_email_rounded,
          color: BrandColors.brandPrimary,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Inserisci la tua email aziendale';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Inserisci un\'email valida';
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
          color: BrandColors.brandPrimary,
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
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: BrandColors.brandPrimary,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Inserisci la tua password';
        }
        if (value!.length < 6) {
          return 'La password deve avere almeno 6 caratteri';
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
        gradient: BrandColors.brandGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: BrandColors.brandPrimary.withOpacity(0.3),
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
            child: Text(
              widget.loginButtonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCredentials() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BrandColors.brandSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: BrandColors.brandSecondary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: BrandColors.brandPrimary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Credenziali di test TechFlow:',
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
            'admin@example.com / password123\nuser@demo.com / demo2024\ntest@app.com / test123',
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
}
