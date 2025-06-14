// Pizza model
class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> ingredients;
  final String imageUrl;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
    this.imageUrl = '',
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
  });

  Pizza copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? ingredients,
    String? imageUrl,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
  }) {
    return Pizza(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pizza &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.ingredients.length == ingredients.length &&
        other.imageUrl == imageUrl &&
        other.isVegetarian == isVegetarian &&
        other.isVegan == isVegan &&
        other.isGlutenFree == isGlutenFree;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        ingredients.hashCode ^
        imageUrl.hashCode ^
        isVegetarian.hashCode ^
        isVegan.hashCode ^
        isGlutenFree.hashCode;
  }
}

// Pizza order item
class PizzaOrderItem {
  final Pizza pizza;
  final int quantity;
  final String size; // S, M, L
  final List<String> extraIngredients;
  final String notes;

  const PizzaOrderItem({
    required this.pizza,
    required this.quantity,
    this.size = 'M',
    this.extraIngredients = const [],
    this.notes = '',
  });

  double get totalPrice {
    double basePrice = pizza.price;
    
    // Prezzo per dimensione
    switch (size) {
      case 'S':
        basePrice *= 0.8;
        break;
      case 'L':
        basePrice *= 1.3;
        break;
      default: // M
        break;
    }
    
    // Costo ingredienti extra (€2 ciascuno)
    basePrice += extraIngredients.length * 2.0;
    
    return basePrice * quantity;
  }

  PizzaOrderItem copyWith({
    Pizza? pizza,
    int? quantity,
    String? size,
    List<String>? extraIngredients,
    String? notes,
  }) {
    return PizzaOrderItem(
      pizza: pizza ?? this.pizza,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      extraIngredients: extraIngredients ?? this.extraIngredients,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PizzaOrderItem &&
        other.pizza == pizza &&
        other.quantity == quantity &&
        other.size == size &&
        other.extraIngredients.length == extraIngredients.length &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return pizza.hashCode ^
        quantity.hashCode ^
        size.hashCode ^
        extraIngredients.hashCode ^
        notes.hashCode;
  }
}

// Order model
class PizzaOrder {
  final String id;
  final List<PizzaOrderItem> items;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final DateTime orderTime;
  final DateTime estimatedDelivery;
  final OrderStatus status;
  final double totalAmount;
  final String paymentMethod;

  const PizzaOrder({
    required this.id,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.orderTime,
    required this.estimatedDelivery,
    required this.status,
    required this.totalAmount,
    this.paymentMethod = 'Contanti',
  });

  PizzaOrder copyWith({
    String? id,
    List<PizzaOrderItem>? items,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    DateTime? orderTime,
    DateTime? estimatedDelivery,
    OrderStatus? status,
    double? totalAmount,
    String? paymentMethod,
  }) {
    return PizzaOrder(
      id: id ?? this.id,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      orderTime: orderTime ?? this.orderTime,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PizzaOrder &&
        other.id == id &&
        other.items.length == items.length &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.deliveryAddress == deliveryAddress &&
        other.status == status &&
        other.totalAmount == totalAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        items.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        deliveryAddress.hashCode ^
        status.hashCode ^
        totalAmount.hashCode;
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  cooking,
  ready,
  delivering,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'In attesa';
      case OrderStatus.confirmed:
        return 'Confermato';
      case OrderStatus.preparing:
        return 'In preparazione';
      case OrderStatus.cooking:
        return 'In cottura';
      case OrderStatus.ready:
        return 'Pronto';
      case OrderStatus.delivering:
        return 'In consegna';
      case OrderStatus.delivered:
        return 'Consegnato';
      case OrderStatus.cancelled:
        return 'Annullato';
    }
  }

  String get emoji {
    switch (this) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.confirmed:
        return '✅';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.cooking:
        return '🔥';
      case OrderStatus.ready:
        return '✨';
      case OrderStatus.delivering:
        return '🚗';
      case OrderStatus.delivered:
        return '🎉';
      case OrderStatus.cancelled:
        return '❌';
    }
  }
}
