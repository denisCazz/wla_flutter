import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';

class SpeedyRegisterPage extends StatefulWidget {
  const SpeedyRegisterPage({super.key});

  @override
  State<SpeedyRegisterPage> createState() => _SpeedyRegisterPageState();
}

class _SpeedyRegisterPageState extends State<SpeedyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _subscribeToNewsletter = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final registerRequest = RegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        acceptTerms: _acceptTerms,
        subscribeToNewsletter: _subscribeToNewsletter,
      );

      context.read<AuthBloc>().add(
        AuthRegisterRequested(registerRequest: registerRequest),
      );
    }
  }

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
                        _buildBackButton(),
                        const SizedBox(height: 24),
                        _buildSpeedyLogo(),
                        const SizedBox(height: 32),
                        _buildBrandTitle(),
                        const SizedBox(height: 32),
                        _buildRegistrationForm(),
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
        Positioned(
          top: 120,
          right: 30,
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
              Icons.local_pizza,
              color: SpeedyColors.speedyGreen.withOpacity(0.7),
              size: 30,
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: 40,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  SpeedyColors.speedyOrange.withOpacity(0.3),
                  SpeedyColors.speedyYellow.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.restaurant,
              color: SpeedyColors.speedyOrange.withOpacity(0.7),
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SpeedyColors.speedyYellow.withOpacity(0.3),
            ),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: SpeedyColors.speedyYellow,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedyLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SpeedyColors.speedyGradient,
        boxShadow: [
          BoxShadow(
            color: SpeedyColors.speedyRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_pizza,
        color: Colors.white,
        size: 50,
      ),
    );
  }

  Widget _buildBrandTitle() {
    return Column(
      children: [
        const Text(
          'Crea Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Unisciti alla famiglia Speedy Pizza!',
          style: TextStyle(
            fontSize: 16,
            color: SpeedyColors.speedyYellow,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return GlassContainer(
      padding: const EdgeInsets.all(28),
      backgroundColor: Colors.white.withOpacity(0.08),
      borderColor: SpeedyColors.speedyRed.withOpacity(0.3),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registrazione completata! Benvenuto ${state.user.name}!'),
                backgroundColor: SpeedyColors.speedyGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 20),
                _buildTermsCheckbox(),
                const SizedBox(height: 12),
                _buildNewsletterCheckbox(),
                const SizedBox(height: 28),
                _buildRegisterButton(state),
                const SizedBox(height: 16),
                _buildLoginLink(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Nome completo',
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
        if (value?.trim().isEmpty ?? true) {
          return 'Inserisci il tuo nome';
        }
        if (value!.trim().length < 2) {
          return 'Il nome deve avere almeno 2 caratteri';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.email_outlined,
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
        if (value?.trim().isEmpty ?? true) {
          return 'Inserisci la tua email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Inserisci un\'email valida';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Telefono (opzionale)',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.phone_outlined,
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
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: SpeedyColors.speedyYellow,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
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
          return 'Inserisci una password';
        }
        if (value!.length < 8) {
          return 'La password deve avere almeno 8 caratteri';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Conferma password',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: SpeedyColors.speedyYellow,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
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
          return 'Conferma la password';
        }
        if (value != _passwordController.text) {
          return 'Le password non corrispondono';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: SpeedyColors.speedyRed,
          checkColor: Colors.white,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: const Text(
              'Accetto i termini e condizioni',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsletterCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _subscribeToNewsletter,
          onChanged: (value) {
            setState(() {
              _subscribeToNewsletter = value ?? false;
            });
          },
          activeColor: SpeedyColors.speedyGreen,
          checkColor: Colors.white,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _subscribeToNewsletter = !_subscribeToNewsletter;
              });
            },
            child: const Text(
              'Iscrivimi alla newsletter per offerte speciali',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(AuthState state) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _acceptTerms ? SpeedyColors.speedyGradient : LinearGradient(
          colors: [Colors.grey.shade600, Colors.grey.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: _acceptTerms ? [
          BoxShadow(
            color: SpeedyColors.speedyRed.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _acceptTerms && state is! AuthLoading ? _onRegisterPressed : null,
          child: Center(
            child: state is AuthLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Crea Account',
                        style: TextStyle(
                          color: _acceptTerms ? Colors.white : Colors.grey.shade400,
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

  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: RichText(
        text: TextSpan(
          text: 'Hai già un account? ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'Accedi qui',
              style: TextStyle(
                color: SpeedyColors.speedyYellow,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
