import '../models/pizza.dart';

// Mock pizza service
class PizzaService {
  // Menu pizze di Speedy Pizza Carmagnola
  static const List<Pizza> _mockPizzas = [
    Pizza(
      id: '1',
      name: 'Margherita',
      description: 'La classica: pomodoro, mozzarella, basilico fresco',
      price: 7.50,
      ingredients: ['Pomodoro', 'Mozzarella', 'Basilico'],
      isVegetarian: true,
    ),
    Pizza(
      id: '2',
      name: 'Diavola',
      description: 'Piccante con salame piccante e peperoncino',
      price: 9.00,
      ingredients: ['Pomodoro', 'Mozzarella', 'Salame piccante', 'Peperoncino'],
    ),
    Pizza(
      id: '3',
      name: 'Capricciosa',
      description: 'Prosciutto cotto, funghi, carciofi, olive',
      price: 10.50,
      ingredients: ['Pomodoro', 'Mozzarella', 'Prosciutto cotto', 'Funghi', 'Carciofi', 'Olive'],
    ),
    Pizza(
      id: '4',
      name: 'Quattro Stagioni',
      description: 'Divisa in quattro: prosciutto, funghi, carciofi, olive',
      price: 11.00,
      ingredients: ['Pomodoro', 'Mozzarella', 'Prosciutto', 'Funghi', 'Carciofi', 'Olive'],
    ),
    Pizza(
      id: '5',
      name: 'Speedy Special',
      description: 'La nostra specialità: salsiccia, patatine, rosmarino',
      price: 12.00,
      ingredients: ['Pomodoro', 'Mozzarella', 'Salsiccia', 'Patatine', 'Rosmarino'],
    ),
    Pizza(
      id: '6',
      name: 'Vegetariana',
      description: 'Verdure grigliate: zucchine, melanzane, peperoni',
      price: 9.50,
      ingredients: ['Pomodoro', 'Mozzarella', 'Zucchine', 'Melanzane', 'Peperoni'],
      isVegetarian: true,
    ),
    Pizza(
      id: '7',
      name: 'Quattro Formaggi',
      description: 'Mozzarella, gorgonzola, parmigiano, ricotta',
      price: 10.00,
      ingredients: ['Mozzarella', 'Gorgonzola', 'Parmigiano', 'Ricotta'],
      isVegetarian: true,
    ),
    Pizza(
      id: '8',
      name: 'Tonno e Cipolla',
      description: 'Tonno, cipolla rossa, olive nere',
      price: 9.50,
      ingredients: ['Pomodoro', 'Mozzarella', 'Tonno', 'Cipolla rossa', 'Olive nere'],
    ),
    Pizza(
      id: '9',
      name: 'Carmagnola DOC',
      description: 'Specialità locale: peperoni di Carmagnola, salsiccia',
      price: 13.00,
      ingredients: ['Pomodoro', 'Mozzarella', 'Peperoni di Carmagnola', 'Salsiccia locale'],
    ),
    Pizza(
      id: '10',
      name: 'Vegan Delight',
      description: 'Mozzarella vegana, verdure, pomodori secchi',
      price: 11.50,
      ingredients: ['Pomodoro', 'Mozzarella vegana', 'Verdure miste', 'Pomodori secchi'],
      isVegetarian: true,
      isVegan: true,
    ),
  ];

  static const List<String> _availableExtras = [
    'Mozzarella extra',
    'Prosciutto crudo',
    'Salame piccante',
    'Funghi',
    'Olive',
    'Peperoni',
    'Cipolla',
    'Pomodori freschi',
    'Rucola',
    'Parmigiano',
  ];

  Future<List<Pizza>> getAllPizzas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPizzas;
  }

  Future<List<Pizza>> searchPizzas(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return _mockPizzas;
    
    return _mockPizzas.where((pizza) {
      return pizza.name.toLowerCase().contains(query.toLowerCase()) ||
             pizza.description.toLowerCase().contains(query.toLowerCase()) ||
             pizza.ingredients.any((ingredient) => 
                ingredient.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  Future<List<Pizza>> getPizzasByCategory({
    bool? vegetarian,
    bool? vegan,
    bool? glutenFree,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockPizzas.where((pizza) {
      if (vegetarian == true && !pizza.isVegetarian) return false;
      if (vegan == true && !pizza.isVegan) return false;
      if (glutenFree == true && !pizza.isGlutenFree) return false;
      return true;
    }).toList();
  }

  Future<Pizza?> getPizzaById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockPizzas.firstWhere((pizza) => pizza.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> getAvailableExtras() {
    return _availableExtras;
  }

  Future<PizzaOrder> submitOrder(PizzaOrder order) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Simula la creazione dell'ordine
    final confirmedOrder = order.copyWith(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      status: OrderStatus.confirmed,
      orderTime: DateTime.now(),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 25)),
    );
    
    return confirmedOrder;
  }

  Future<List<PizzaOrder>> getUserOrders(String userEmail) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock degli ordini dell'utente
    final mockOrders = <PizzaOrder>[
      PizzaOrder(
        id: 'ORD001',
        items: [
          PizzaOrderItem(
            pizza: _mockPizzas[0], // Margherita
            quantity: 2,
            size: 'M',
          ),
          PizzaOrderItem(
            pizza: _mockPizzas[4], // Speedy Special
            quantity: 1,
            size: 'L',
            extraIngredients: ['Rucola'],
          ),
        ],
        customerName: 'Mario Rossi',
        customerPhone: '+39 334 1234567',
        deliveryAddress: 'Via Roma 123, Carmagnola',
        orderTime: DateTime.now().subtract(const Duration(hours: 2)),
        estimatedDelivery: DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
        status: OrderStatus.delivered,
        totalAmount: 31.50,
        paymentMethod: 'Carta',
      ),
      PizzaOrder(
        id: 'ORD002',
        items: [
          PizzaOrderItem(
            pizza: _mockPizzas[8], // Carmagnola DOC
            quantity: 1,
            size: 'M',
          ),
        ],
        customerName: 'Mario Rossi',
        customerPhone: '+39 334 1234567',
        deliveryAddress: 'Via Roma 123, Carmagnola',
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedDelivery: DateTime.now().add(const Duration(minutes: 10)),
        status: OrderStatus.delivering,
        totalAmount: 13.00,
        paymentMethod: 'Contanti',
      ),
    ];
    
    return mockOrders;
  }

  Future<PizzaOrder?> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final orders = await getUserOrders('current_user');
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simula la cancellazione (in un'app reale verificheresti lo stato)
    return true;
  }

  // Calcola il tempo stimato di consegna basato sull'ora corrente
  DateTime getEstimatedDeliveryTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // Tempo base: 20-30 minuti
    int baseMinutes = 25;
    
    // Aggiusta in base all'orario (ore di punta)
    if ((hour >= 12 && hour <= 14) || (hour >= 19 && hour <= 21)) {
      baseMinutes += 10; // Più traffico durante pranzo e cena
    }
    
    // Weekend = più traffico
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      baseMinutes += 5;
    }
    
    return now.add(Duration(minutes: baseMinutes));
  }

  // Verifica se la pizzeria è aperta
  bool isOpen() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final timeInMinutes = hour * 60 + minute;
    
    // Orari: 18:00 - 23:30 (tutti i giorni)
    const openTime = 18 * 60; // 18:00
    const closeTime = 23 * 60 + 30; // 23:30
    
    return timeInMinutes >= openTime && timeInMinutes <= closeTime;
  }

  String getOpeningHours() {
    return 'Aperto tutti i giorni dalle 18:00 alle 23:30';
  }
}
