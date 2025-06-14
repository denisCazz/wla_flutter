import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';
import 'pizza_menu_page.dart';
import 'my_orders_page.dart';

class SpeedyDashboardPage extends StatefulWidget {
  const SpeedyDashboardPage({super.key});

  @override
  State<SpeedyDashboardPage> createState() => _SpeedyDashboardPageState();
}

class _SpeedyDashboardPageState extends State<SpeedyDashboardPage> {
  int _selectedIndex = 0;
  final PizzaService _pizzaService = PizzaService();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
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
              child: SafeArea(
                child: _getSelectedPage(),
              ),
            ),
            bottomNavigationBar: _buildBottomNavBar(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return PizzaMenuPage(pizzaService: _pizzaService);
      case 2:
        return MyOrdersPage(pizzaService: _pizzaService);
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state.user),
                const SizedBox(height: 24),
                _buildQuickStats(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildRecentOrders(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(User user) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ciao! 👋',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SpeedyColors.speedyYellow,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _pizzaService.isOpen() ? Icons.circle : Icons.circle_outlined,
                    color: _pizzaService.isOpen() ? SpeedyColors.speedyGreen : SpeedyColors.speedyRed,
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _pizzaService.isOpen() ? 'Aperto ora' : 'Chiuso',
                    style: TextStyle(
                      fontSize: 12,
                      color: _pizzaService.isOpen() ? SpeedyColors.speedyGreen : SpeedyColors.speedyRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<AuthBloc>().add(AuthLogoutRequested());
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: SpeedyColors.speedyRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: SpeedyColors.speedyRed.withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Speedy Pizza Carmagnola',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: SpeedyColors.speedyYellow,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: SpeedyColors.speedyRed,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Via Roma 45, Carmagnola (TO)',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: SpeedyColors.speedyGreen,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                _pizzaService.getOpeningHours(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '⚡️',
                  'Consegna',
                  '20-30 min',
                  SpeedyColors.speedyOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '🍕',
                  'Pizze',
                  '10+ varietà',
                  SpeedyColors.speedyYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Azioni Rapide',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.restaurant_menu,
                title: 'Menu Pizze',
                subtitle: 'Sfoglia e ordina',
                color: SpeedyColors.speedyRed,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.history,
                title: 'I Miei Ordini',
                subtitle: 'Stato e cronologia',
                color: SpeedyColors.speedyOrange,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.phone,
                title: 'Chiama',
                subtitle: '011 123 4567',
                color: SpeedyColors.speedyGreen,
                onTap: () {
                  // In un'app reale, apriresti il dialer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chiamata in corso...'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.star,
                title: 'Valutaci',
                subtitle: 'Lascia una recensione',
                color: SpeedyColors.speedyYellow,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Grazie per il feedback!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.withOpacity(0.3),
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ordini Recenti',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GlassContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildOrderItem(
                'Margherita x2 + Diavola',
                'Consegnato',
                '€24.50',
                SpeedyColors.speedyGreen,
              ),
              const Divider(color: AppColors.glassBorder, height: 20),
              _buildOrderItem(
                'Carmagnola DOC',
                'In consegna',
                '€13.00',
                SpeedyColors.speedyOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(String name, String status, String price, Color statusColor) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: SpeedyColors.speedyRed.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.local_pizza,
            color: SpeedyColors.speedyRed,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SpeedyColors.speedyYellow,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SpeedyColors.speedyGradient,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        state.user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings, color: SpeedyColors.speedyYellow),
                        title: const Text('Impostazioni', style: TextStyle(color: AppColors.textPrimary)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.help, color: SpeedyColors.speedyOrange),
                        title: const Text('Aiuto', style: TextStyle(color: AppColors.textPrimary)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: SpeedyColors.speedyRed),
                        title: const Text('Logout', style: TextStyle(color: AppColors.textPrimary)),
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: SpeedyColors.speedyRed.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: SpeedyColors.speedyYellow,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Ordini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
      ),
    );
  }
}
