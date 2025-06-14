import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../widgets/glass_container.dart';
import '../theme/app_colors.dart';

abstract class BaseLoginPage extends StatefulWidget {
  const BaseLoginPage({super.key});

  // Metodi che possono essere sovrascritti dalle implementazioni client
  String get appTitle => 'Login';
  String get logoAssetPath => '';
  String get welcomeMessage => 'Benvenuto!';
  String get subtitleMessage => 'Accedi al tuo account';
  Color get primaryColor => AppColors.primary;
  String get loginButtonText => 'Accedi';
  String get emailHint => 'Email';
  String get passwordHint => 'Password';
  
  @override
  BaseLoginPageState createState() => BaseLoginPageState();
}

class BaseLoginPageState extends State<BaseLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Getter per permettere l'accesso dalle classi derivate
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool value) {
    setState(() {
      _obscurePassword = value;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  // Metodo pubblico per permettere l'accesso dalle classi derivate
  void onLoginPressed() => _onLoginPressed();

  Widget _buildLogo() {
    if (widget.logoAssetPath.isNotEmpty) {
      return Image.asset(
        widget.logoAssetPath,
        height: 80,
        width: 80,
      );
    }
    return Icon(
      Icons.lock_rounded,
      size: 60,
      color: widget.primaryColor,
    );
  }

  Widget _buildFloatingShapes() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  widget.primaryColor.withOpacity(0.3),
                  AppColors.secondary.withOpacity(0.2),
                ],
              ),
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
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.3),
                  widget.primaryColor.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          right: 80,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            _buildFloatingShapes(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 32),
                        Text(
                          widget.welcomeMessage,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
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
                        const SizedBox(height: 48),
                        GlassContainer(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: InputDecoration(
                                    hintText: widget.emailHint,
                                    hintStyle: const TextStyle(color: AppColors.textMuted),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: AppColors.textSecondary,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.glassOverlay,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: widget.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Inserisci un\'email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return 'Inserisci un\'email valida';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: InputDecoration(
                                    hintText: widget.passwordHint,
                                    hintStyle: const TextStyle(color: AppColors.textMuted),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.textSecondary,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: AppColors.glassOverlay,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.glassBorder,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: widget.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Inserisci una password';
                                    }
                                    if (value!.length < 6) {
                                      return 'La password deve avere almeno 6 caratteri';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    if (state is AuthError) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: GlassButton(
                                        onPressed: _onLoginPressed,
                                        isLoading: state is AuthLoading,
                                        child: Text(
                                          widget.loginButtonText,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Credenziali di test:\nadmin@example.com / password123\nuser@demo.com / demo2024',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
