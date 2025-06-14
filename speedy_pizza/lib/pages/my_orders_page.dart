import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';

class MyOrdersPage extends StatefulWidget {
  final PizzaService pizzaService;

  const MyOrdersPage({
    super.key,
    required this.pizzaService,
  });

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<PizzaOrder> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tutti';

  final List<String> _filters = [
    'Tutti',
    'In corso',
    'Consegnati',
    'Annullati',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await widget.pizzaService.getUserOrders('current_user');
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<PizzaOrder> get _filteredOrders {
    switch (_selectedFilter) {
      case 'In corso':
        return _orders.where((order) => 
          [OrderStatus.pending, OrderStatus.confirmed, OrderStatus.preparing, 
           OrderStatus.cooking, OrderStatus.ready, OrderStatus.delivering]
          .contains(order.status)).toList();
      case 'Consegnati':
        return _orders.where((order) => order.status == OrderStatus.delivered).toList();
      case 'Annullati':
        return _orders.where((order) => order.status == OrderStatus.cancelled).toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading ? _buildLoading() : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.history,
          color: SpeedyColors.speedyYellow,
          size: 28,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'I Miei Ordini',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: _loadOrders,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SpeedyColors.speedyGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: SpeedyColors.speedyGreen.withOpacity(0.3),
              ),
            ),
            child: Icon(
              Icons.refresh,
              color: SpeedyColors.speedyGreen,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedFilter = filter);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected ? SpeedyColors.speedyGradient : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? SpeedyColors.speedyRed 
                        : SpeedyColors.speedyYellow.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: SpeedyColors.speedyYellow,
          ),
          const SizedBox(height: 16),
          const Text(
            'Caricamento ordini...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    final filteredOrders = _filteredOrders;
    
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 60,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'Tutti' 
                  ? 'Nessun ordine trovato'
                  : 'Nessun ordine ${_selectedFilter.toLowerCase()}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'I tuoi ordini appariranno qui',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: SpeedyColors.speedyYellow,
      child: ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOrderCard(order),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(PizzaOrder order) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header ordine
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ordine #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _formatDate(order.orderTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(order.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  order.status.displayName,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Items dell'ordine
          ...order.items.map((item) => _buildOrderItem(item)),
          
          const SizedBox(height: 12),
          
          // Info consegna e totale
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: SpeedyColors.speedyRed,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.deliveryAddress,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
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
                    const SizedBox(width: 8),
                    Text(
                      'Consegna stimata: ${_formatTime(order.estimatedDelivery)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '€${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SpeedyColors.speedyYellow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Azioni
          if (_canCancelOrder(order) || order.status == OrderStatus.delivered)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  if (_canCancelOrder(order))
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _cancelOrder(order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: SpeedyColors.speedyRed),
                          foregroundColor: SpeedyColors.speedyRed,
                        ),
                        child: const Text('Annulla'),
                      ),
                    ),
                  if (_canCancelOrder(order) && order.status == OrderStatus.delivered)
                    const SizedBox(width: 12),
                  if (order.status == OrderStatus.delivered)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _reorderItems(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SpeedyColors.speedyGreen,
                        ),
                        child: const Text(
                          'Riordina',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(PizzaOrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
                  '${item.pizza.name} (${item.size})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (item.extraIngredients.isNotEmpty)
                  Text(
                    'Extra: ${item.extraIngredients.join(', ')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${item.quantity}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '€${item.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SpeedyColors.speedyYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return SpeedyColors.speedyYellow;
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
      case OrderStatus.cooking:
        return SpeedyColors.speedyOrange;
      case OrderStatus.ready:
      case OrderStatus.delivering:
        return Colors.blue;
      case OrderStatus.delivered:
        return SpeedyColors.speedyGreen;
      case OrderStatus.cancelled:
        return SpeedyColors.speedyRed;
    }
  }

  bool _canCancelOrder(PizzaOrder order) {
    return [OrderStatus.pending, OrderStatus.confirmed].contains(order.status);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(date.year, date.month, date.day);
    
    if (orderDate == today) {
      return 'Oggi, ${_formatTime(date)}';
    } else if (orderDate == today.subtract(const Duration(days: 1))) {
      return 'Ieri, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _cancelOrder(PizzaOrder order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1810),
        title: const Text(
          'Annulla Ordine',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Sei sicuro di voler annullare l\'ordine #${order.id}?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: SpeedyColors.speedyRed,
            ),
            child: const Text('Sì, Annulla'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.pizzaService.cancelOrder(order.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ordine annullato con successo'),
            backgroundColor: SpeedyColors.speedyGreen,
          ),
        );
        _loadOrders(); // Ricarica gli ordini
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Errore nell\'annullamento dell\'ordine'),
            backgroundColor: SpeedyColors.speedyRed,
          ),
        );
      }
    }
  }

  void _reorderItems(PizzaOrder order) {
    // In un'app reale, aggiungeresti gli items al carrello
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Articoli aggiunti al carrello!'),
        backgroundColor: SpeedyColors.speedyGreen,
        action: SnackBarAction(
          label: 'Vai al Menu',
          textColor: Colors.white,
          onPressed: () {
            // Naviga al tab menu
          },
        ),
      ),
    );
  }
}
