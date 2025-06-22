import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';

class SpeedyProfilePage extends StatefulWidget {
  const SpeedyProfilePage({super.key});

  @override
  State<SpeedyProfilePage> createState() => _SpeedyProfilePageState();
}

class _SpeedyProfilePageState extends State<SpeedyProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpeedyColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0000),
              Color(0xFF2D1810),
              Color(0xFF1A1A00),
            ],
          ),
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return _buildProfileContent(state.loginResponse);
            }
            return const Center(
              child: CircularProgressIndicator(
                color: SpeedyColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(LoginResponse loginResponse) {
    final user = loginResponse.user;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildProfileCard(user),
                const SizedBox(height: 24),
                _buildSessionInfo(loginResponse.sessionInfo),
                const SizedBox(height: 24),
                _buildPermissions(loginResponse.permissions),
                const SizedBox(height: 24),
                _buildPreferences(user.preferences),
                const SizedBox(height: 24),
                _buildFavorites(user.favoriteItems),
                const SizedBox(height: 32),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
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
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Il Mio Profilo',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: SpeedyColors.speedyGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(User user) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      backgroundColor: Colors.white.withOpacity(0.08),
      borderColor: SpeedyColors.speedyRed.withOpacity(0.3),
      child: Column(
        children: [
          // Avatar e informazioni base
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: user.hasAvatar ? null : SpeedyColors.speedyGradient,
                  border: Border.all(
                    color: SpeedyColors.speedyYellow,
                    width: 3,
                  ),
                ),
                child: user.hasAvatar
                    ? ClipOval(
                        child: Image.network(
                          user.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: SpeedyColors.speedyGradient,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: SpeedyColors.speedyYellow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getRoleColor(user.role),
                        ),
                      ),
                      child: Text(
                        _getRoleText(user.role),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getRoleColor(user.role),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          // Statistiche utente
          Row(
            children: [
              _buildStatItem(
                'Membro da',
                _formatDate(user.createdAt),
                Icons.calendar_today,
                SpeedyColors.speedyGreen,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                'Ultimo accesso',
                user.lastLoginAt != null ? _formatDate(user.lastLoginAt!) : 'Mai',
                Icons.access_time,
                SpeedyColors.speedyOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfo(SessionInfo sessionInfo) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withOpacity(0.05),
      borderColor: SpeedyColors.speedyBlue.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: SpeedyColors.speedyBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Informazioni Sessione',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ID Sessione', sessionInfo.sessionId),
          _buildInfoRow('Durata', _formatDuration(sessionInfo.sessionDuration)),
          if (sessionInfo.location != null)
            _buildInfoRow('Posizione', sessionInfo.location!),
          if (sessionInfo.ipAddress != null)
            _buildInfoRow('IP Address', sessionInfo.ipAddress!),
          Row(
            children: [
              const Text(
                'Stato: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: sessionInfo.isActive ? SpeedyColors.speedyGreen : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sessionInfo.isActive ? 'Attiva' : 'Inattiva',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissions(List<String> permissions) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withOpacity(0.05),
      borderColor: SpeedyColors.speedyOrange.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: SpeedyColors.speedyOrange,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Permessi Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions.map((permission) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPermissionColor(permission).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getPermissionColor(permission),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPermissionIcon(permission),
                      size: 16,
                      color: _getPermissionColor(permission),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      permission.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getPermissionColor(permission),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(Map<String, dynamic> preferences) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withOpacity(0.05),
      borderColor: SpeedyColors.speedyGreen.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: SpeedyColors.speedyGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Preferenze',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...preferences.entries.map((entry) {
            return _buildPreferenceItem(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFavorites(List<String> favoriteItems) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withOpacity(0.05),
      borderColor: SpeedyColors.speedyYellow.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: SpeedyColors.speedyYellow,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Pizze Preferite',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (favoriteItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Nessuna pizza preferita ancora',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: favoriteItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SpeedyColors.speedyYellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: SpeedyColors.speedyYellow,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_pizza,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade800],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showLogoutDialog();
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Disconnetti',
                  style: TextStyle(
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            _getPreferenceIcon(key),
            size: 20,
            color: SpeedyColors.speedyGreen,
          ),
          const SizedBox(width: 12),
          Text(
            _getPreferenceLabel(key),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: SpeedyColors.speedyGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SpeedyColors.speedyGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.moderator:
        return Colors.orange;
      case UserRole.customer:
        return SpeedyColors.speedyGreen;
    }
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.moderator:
        return 'MODERATORE';
      case UserRole.customer:
        return 'CLIENTE';
    }
  }

  Color _getPermissionColor(String permission) {
    switch (permission.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'write':
        return Colors.orange;
      case 'delete':
        return Colors.red.shade700;
      case 'read':
      default:
        return SpeedyColors.speedyGreen;
    }
  }

  IconData _getPermissionIcon(String permission) {
    switch (permission.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'write':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'read':
      default:
        return Icons.visibility;
    }
  }

  IconData _getPreferenceIcon(String key) {
    switch (key.toLowerCase()) {
      case 'theme':
        return Icons.palette;
      case 'notifications':
        return Icons.notifications;
      case 'language':
        return Icons.language;
      default:
        return Icons.settings;
    }
  }

  String _getPreferenceLabel(String key) {
    switch (key.toLowerCase()) {
      case 'theme':
        return 'Tema';
      case 'notifications':
        return 'Notifiche';
      case 'language':
        return 'Lingua';
      default:
        return key;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} anni fa';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mesi fa';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} giorni fa';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ore fa';
    } else {
      return 'Poco fa';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}g ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Conferma Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Sei sicuro di voler disconnetterti dal tuo account?',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annulla',
              style: TextStyle(
                color: SpeedyColors.speedyYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Disconnetti',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
