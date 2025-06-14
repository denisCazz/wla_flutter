import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../theme/speedy_colors.dart';

class PizzaMenuPage extends StatefulWidget {
  final PizzaService pizzaService;

  const PizzaMenuPage({
    super.key,
    required this.pizzaService,
  });

  @override
  State<PizzaMenuPage> createState() => _PizzaMenuPageState();
}

class _PizzaMenuPageState extends State<PizzaMenuPage> {
  List<Pizza> _pizzas = [];
  List<Pizza> _filteredPizzas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'Tutte';
  final List<PizzaOrderItem> _cart = [];

  final List<String> _categories = [
    'Tutte',
    'Classiche',
    'Vegetariane',
    'Specialità',
  ];

  @override
  void initState() {
    super.initState();
    _loadPizzas();
  }

  Future<void> _loadPizzas() async {
    try {
      final pizzas = await widget.pizzaService.getAllPizzas();
      setState(() {
        _pizzas = pizzas;
        _filteredPizzas = pizzas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterPizzas() {
    List<Pizza> filtered = _pizzas;

    // Filtro per categoria
    if (_selectedCategory != 'Tutte') {
      switch (_selectedCategory) {
        case 'Classiche':
          filtered = filtered.where((p) => 
            ['Margherita', 'Diavola', 'Capricciosa', 'Quattro Stagioni']
                .contains(p.name)).toList();
          break;
        case 'Vegetariane':
          filtered = filtered.where((p) => p.isVegetarian).toList();
          break;
        case 'Specialità':
          filtered = filtered.where((p) => 
            ['Speedy Special', 'Carmagnola DOC'].contains(p.name)).toList();
          break;
      }
    }

    // Filtro per ricerca
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((pizza) {
        return pizza.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               pizza.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               pizza.ingredients.any((ingredient) => 
                  ingredient.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    setState(() => _filteredPizzas = filtered);
  }

  void _addToCart(Pizza pizza) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPizzaCustomizer(pizza),
    );
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
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildCategoryTabs(),
          const SizedBox(height: 16),
          _buildCartButton(),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading ? _buildLoading() : _buildPizzaGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.restaurant_menu,
          color: SpeedyColors.speedyYellow,
          size: 28,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Menu Pizze',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (!widget.pizzaService.isOpen())
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SpeedyColors.speedyRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SpeedyColors.speedyRed.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: SpeedyColors.speedyRed,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Chiuso',
                  style: TextStyle(
                    color: SpeedyColors.speedyRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cerca pizze, ingredienti...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(
            Icons.search,
            color: SpeedyColors.speedyYellow,
          ),
          border: InputBorder.none,
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textMuted),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                    _filterPizzas();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
          _filterPizzas();
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = category);
                _filterPizzas();
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
                  category,
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

  Widget _buildCartButton() {
    if (_cart.isEmpty) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: _showCart,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: SpeedyColors.speedyGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: SpeedyColors.speedyRed.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                _cart.length.toString(),
                style: TextStyle(
                  color: SpeedyColors.speedyRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Visualizza Carrello',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '€${_getCartTotal().toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
            'Caricamento menu...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPizzaGrid() {
    if (_filteredPizzas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nessuna pizza trovata',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 140,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredPizzas.length,
      itemBuilder: (context, index) {
        final pizza = _filteredPizzas[index];
        return _buildPizzaCard(pizza);
      },
    );
  }

  Widget _buildPizzaCard(Pizza pizza) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  SpeedyColors.speedyYellow.withOpacity(0.3),
                  SpeedyColors.speedyRed.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.local_pizza,
              color: SpeedyColors.speedyRed,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pizza.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (pizza.isVegetarian)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: SpeedyColors.speedyGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.eco,
                          color: SpeedyColors.speedyGreen,
                          size: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pizza.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '€${pizza.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SpeedyColors.speedyYellow,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.pizzaService.isOpen() 
                          ? () => _addToCart(pizza)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: widget.pizzaService.isOpen() 
                              ? SpeedyColors.speedyGradient 
                              : null,
                          color: widget.pizzaService.isOpen() 
                              ? null 
                              : AppColors.textMuted,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPizzaCustomizer(Pizza pizza) {
    String selectedSize = 'M';
    int quantity = 1;
    List<String> selectedExtras = [];

    return StatefulBuilder(
      builder: (context, setModalState) {
        double totalPrice = pizza.price;
        switch (selectedSize) {
          case 'S':
            totalPrice *= 0.8;
            break;
          case 'L':
            totalPrice *= 1.3;
            break;
        }
        totalPrice += selectedExtras.length * 2.0;
        totalPrice *= quantity;

        return GlassContainer(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pizza.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Selezione dimensione
              const Text(
                'Dimensione:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['S', 'M', 'L'].map((size) {
                  final isSelected = size == selectedSize;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedSize = size),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: isSelected ? SpeedyColors.speedyGradient : null,
                            color: isSelected ? null : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected 
                                  ? SpeedyColors.speedyRed 
                                  : SpeedyColors.speedyYellow.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            size,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Quantità
              Row(
                children: [
                  const Text(
                    'Quantità:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: quantity > 1 ? () => setModalState(() => quantity--) : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SpeedyColors.speedyRed.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: quantity > 1 ? SpeedyColors.speedyRed : AppColors.textMuted,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setModalState(() => quantity++),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SpeedyColors.speedyGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.add,
                            color: SpeedyColors.speedyGreen,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Aggiungi al carrello
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final orderItem = PizzaOrderItem(
                      pizza: pizza,
                      quantity: quantity,
                      size: selectedSize,
                      extraIngredients: selectedExtras,
                    );
                    setState(() => _cart.add(orderItem));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${pizza.name} aggiunta al carrello!'),
                        backgroundColor: SpeedyColors.speedyGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SpeedyColors.speedyRed,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Aggiungi al carrello - €${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getCartTotal() {
    return _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCartView(),
    );
  }

  Widget _buildCartView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: const EdgeInsets.all(16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: SpeedyColors.speedyYellow,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Il tuo carrello',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_cart.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Il carrello è vuoto',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart[index];
                    return _buildCartItem(item, index);
                  },
                ),
              ),
            
            if (_cart.isNotEmpty) ...[
              const Divider(color: AppColors.textMuted),
              const SizedBox(height: 16),
              
              // Totale
              Row(
                children: [
                  const Text(
                    'Totale:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '€${_getCartTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SpeedyColors.speedyYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Bottoni azione
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _cart.clear());
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Carrello svuotato'),
                            backgroundColor: AppColors.textMuted,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: SpeedyColors.speedyRed),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Svuota',
                        style: TextStyle(
                          color: SpeedyColors.speedyRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _proceedToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SpeedyColors.speedyRed,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Procedi all\'ordine',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(PizzaOrderItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SpeedyColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SpeedyColors.speedyYellow.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.pizza.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _cart.removeAt(index));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.pizza.name} rimossa dal carrello'),
                      backgroundColor: SpeedyColors.speedyRed,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: SpeedyColors.speedyRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: SpeedyColors.speedyRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Text(
                'Dimensione: ${item.size}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Quantità: ${item.quantity}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          if (item.extraIngredients.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Extra: ${item.extraIngredients.join(', ')}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          
          const SizedBox(height: 8),
          Row(
            children: [
              // Quantità controls
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.quantity > 1) {
                        setState(() {
                          _cart[index] = item.copyWith(quantity: item.quantity - 1);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: SpeedyColors.speedyRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: SpeedyColors.speedyRed,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cart[index] = item.copyWith(quantity: item.quantity + 1);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: SpeedyColors.speedyGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: SpeedyColors.speedyGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '€${item.totalPrice.toStringAsFixed(2)}',
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
    );
  }

  void _proceedToCheckout() {
    Navigator.pop(context); // Chiude il carrello
    
    // Per ora mostriamo un dialogo di conferma
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SpeedyColors.surface,
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: SpeedyColors.speedyGreen,
            ),
            const SizedBox(width: 8),
            const Text(
              'Ordine confermato!',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Il tuo ordine è stato ricevuto e sarà pronto in 20-30 minuti.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'Totale: €${_getCartTotal().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: SpeedyColors.speedyYellow,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tempo di consegna stimato: ${DateTime.now().add(const Duration(minutes: 25)).hour}:${DateTime.now().add(const Duration(minutes: 25)).minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cart.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Ordine completato! Controlla la sezione "I miei ordini"'),
                  backgroundColor: SpeedyColors.speedyGreen,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: Text(
              'OK',
              style: TextStyle(color: SpeedyColors.speedyYellow),
            ),
          ),
        ],
      ),
    );
  }
}
