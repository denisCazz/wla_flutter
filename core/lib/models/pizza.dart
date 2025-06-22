import 'dart:convert';

/// Modello Pizza ultra moderno con JSON serialization e validazioni
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
  final String category;
  final DateTime? availableFrom;
  final DateTime? availableUntil;
  final int preparationTimeMinutes;
  final bool isActive;

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
    this.category = 'Classiche',
    this.availableFrom,
    this.availableUntil,
    this.preparationTimeMinutes = 20,
    this.isActive = true,
  });

  /// Crea una Pizza da JSON
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      ingredients: List<String>.from(json['ingredients'] as List),
      imageUrl: json['imageUrl'] as String? ?? '',
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      category: json['category'] as String? ?? 'Classiche',
      availableFrom: json['availableFrom'] != null 
          ? DateTime.parse(json['availableFrom'] as String)
          : null,
      availableUntil: json['availableUntil'] != null 
          ? DateTime.parse(json['availableUntil'] as String)
          : null,
      preparationTimeMinutes: json['preparationTimeMinutes'] as int? ?? 20,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Converte la Pizza in JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'category': category,
      'availableFrom': availableFrom?.toIso8601String(),
      'availableUntil': availableUntil?.toIso8601String(),
      'preparationTimeMinutes': preparationTimeMinutes,
      'isActive': isActive,
    };
  }

  /// Verifica se la pizza è disponibile in questo momento
  bool get isAvailable {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (availableFrom != null && now.isBefore(availableFrom!)) return false;
    if (availableUntil != null && now.isAfter(availableUntil!)) return false;
    
    return true;
  }

  /// Tempo di preparazione formattato
  String get preparationTimeFormatted {
    if (preparationTimeMinutes < 60) {
      return '$preparationTimeMinutes min';
    } else {
      final hours = preparationTimeMinutes ~/ 60;
      final minutes = preparationTimeMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  /// Badge per categoria alimentare
  List<String> get dietaryBadges {
    final badges = <String>[];
    if (isVegetarian) badges.add('Vegetariano');
    if (isVegan) badges.add('Vegano');
    if (isGlutenFree) badges.add('Senza Glutine');
    return badges;
  }

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
    String? category,
    DateTime? availableFrom,
    DateTime? availableUntil,
    int? preparationTimeMinutes,
    bool? isActive,
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
      category: category ?? this.category,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      isActive: isActive ?? this.isActive,
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
        other.isGlutenFree == isGlutenFree &&
        other.category == category &&
        other.availableFrom == availableFrom &&
        other.availableUntil == availableUntil &&
        other.preparationTimeMinutes == preparationTimeMinutes &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      ingredients,
      imageUrl,
      isVegetarian,
      isVegan,
      isGlutenFree,
      category,
      availableFrom,
      availableUntil,
      preparationTimeMinutes,
      isActive,
    );
  }

  @override
  String toString() {
    return 'Pizza(id: $id, name: $name, price: €$price, category: $category, isAvailable: $isAvailable)';
  }
}

/// Enum per le dimensioni delle pizze
enum PizzaSize {
  small('S', 'Piccola', 0.8),
  medium('M', 'Media', 1.0),
  large('L', 'Grande', 1.3);

  const PizzaSize(this.code, this.displayName, this.priceMultiplier);

  final String code;
  final String displayName;
  final double priceMultiplier;

  /// Converte da codice stringa
  static PizzaSize fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'S':
        return PizzaSize.small;
      case 'L':
        return PizzaSize.large;
      default:
        return PizzaSize.medium;
    }
  }

  @override
  String toString() => displayName;
}

/// Enum per i metodi di pagamento
enum PaymentMethod {
  cash('Contanti', '💵'),
  card('Carta', '💳'),
  digital('Digitale', '📱'),
  online('Online', '🌐');

  const PaymentMethod(this.displayName, this.emoji);

  final String displayName;
  final String emoji;

  /// Converte da stringa
  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'carta':
      case 'card':
        return PaymentMethod.card;
      case 'digitale':
      case 'digital':
        return PaymentMethod.digital;
      case 'online':
        return PaymentMethod.online;
      default:
        return PaymentMethod.cash;
    }
  }

  @override
  String toString() => displayName;
}

/// Item di ordine pizza ultra moderno con calcoli automatici
class PizzaOrderItem {
  final Pizza pizza;
  final int quantity;
  final PizzaSize size;
  final List<String> extraIngredients;
  final List<String> removedIngredients;
  final String notes;
  final DateTime addedAt;

  PizzaOrderItem({
    required this.pizza,
    required this.quantity,
    this.size = PizzaSize.medium,
    this.extraIngredients = const [],
    this.removedIngredients = const [],
    this.notes = '',
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Crea un PizzaOrderItem da JSON
  factory PizzaOrderItem.fromJson(Map<String, dynamic> json) {
    return PizzaOrderItem(
      pizza: Pizza.fromJson(json['pizza'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      size: PizzaSize.fromCode(json['size'] as String),
      extraIngredients: List<String>.from(json['extraIngredients'] as List? ?? []),
      removedIngredients: List<String>.from(json['removedIngredients'] as List? ?? []),
      notes: json['notes'] as String? ?? '',
      addedAt: json['addedAt'] != null 
          ? DateTime.parse(json['addedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Converte il PizzaOrderItem in JSON
  Map<String, dynamic> toJson() {
    return {
      'pizza': pizza.toJson(),
      'quantity': quantity,
      'size': size.code,
      'extraIngredients': extraIngredients,
      'removedIngredients': removedIngredients,
      'notes': notes,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  double get totalPrice {
    double basePrice = pizza.price * size.priceMultiplier;
    
    // Costo ingredienti extra (€2 ciascuno)
    basePrice += extraIngredients.length * 2.0;
    
    // Sconto per ingredienti rimossi (€0.50 ciascuno)
    basePrice -= removedIngredients.length * 0.5;
    
    return (basePrice * quantity).clamp(0.0, double.infinity);
  }

  /// Prezzo unitario formattato
  String get unitPriceFormatted => '€${(totalPrice / quantity).toStringAsFixed(2)}';
  
  /// Prezzo totale formattato
  String get totalPriceFormatted => '€${totalPrice.toStringAsFixed(2)}';

  /// Descrizione completa dell'item
  String get fullDescription {
    final parts = <String>[
      '${pizza.name} (${size.displayName})',
      if (extraIngredients.isNotEmpty) 'Extra: ${extraIngredients.join(', ')}',
      if (removedIngredients.isNotEmpty) 'Senza: ${removedIngredients.join(', ')}',
      if (notes.isNotEmpty) 'Note: $notes',
    ];
    return parts.join(' • ');
  }

  PizzaOrderItem copyWith({
    Pizza? pizza,
    int? quantity,
    PizzaSize? size,
    List<String>? extraIngredients,
    List<String>? removedIngredients,
    String? notes,
    DateTime? addedAt,
  }) {
    return PizzaOrderItem(
      pizza: pizza ?? this.pizza,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      extraIngredients: extraIngredients ?? this.extraIngredients,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
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
        other.removedIngredients.length == removedIngredients.length &&
        other.notes == notes &&
        other.addedAt == addedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      pizza,
      quantity,
      size,
      extraIngredients,
      removedIngredients,
      notes,
      addedAt,
    );
  }

  @override
  String toString() {
    return 'PizzaOrderItem(pizza: ${pizza.name}, quantity: $quantity, size: ${size.displayName}, total: $totalPriceFormatted)';
  }
}

/// Modello ordine pizza ultra moderno con tracking completo
class PizzaOrder {
  final String id;
  final List<PizzaOrderItem> items;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String deliveryAddress;
  final String? deliveryNotes;
  final DateTime orderTime;
  final DateTime estimatedDelivery;
  final OrderStatus status;
  final double totalAmount;
  final double deliveryFee;
  final double discount;
  final PaymentMethod paymentMethod;
  final String? couponCode;
  final DateTime? deliveredAt;
  final String? cancellationReason;

  const PizzaOrder({
    required this.id,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.deliveryAddress,
    this.deliveryNotes,
    required this.orderTime,
    required this.estimatedDelivery,
    required this.status,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    this.paymentMethod = PaymentMethod.cash,
    this.couponCode,
    this.deliveredAt,
    this.cancellationReason,
  });

  /// Crea un PizzaOrder da JSON
  factory PizzaOrder.fromJson(Map<String, dynamic> json) {
    return PizzaOrder(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => PizzaOrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryNotes: json['deliveryNotes'] as String?,
      orderTime: DateTime.parse(json['orderTime'] as String),
      estimatedDelivery: DateTime.parse(json['estimatedDelivery'] as String),
      status: OrderStatus.values.byName(json['status'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] as String? ?? 'cash'),
      couponCode: json['couponCode'] as String?,
      deliveredAt: json['deliveredAt'] != null 
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      cancellationReason: json['cancellationReason'] as String?,
    );
  }

  /// Converte il PizzaOrder in JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'deliveryAddress': deliveryAddress,
      'deliveryNotes': deliveryNotes,
      'orderTime': orderTime.toIso8601String(),
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
      'status': status.name,
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'paymentMethod': paymentMethod.displayName,
      'couponCode': couponCode,
      'deliveredAt': deliveredAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  /// Calcola il totale effettivo dell'ordine
  double get calculatedTotal {
    final itemsTotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    return itemsTotal + deliveryFee - discount;
  }

  /// Totale formattato
  String get totalFormatted => '€${totalAmount.toStringAsFixed(2)}';

  /// Durata stimata di consegna
  Duration get estimatedDuration => estimatedDelivery.difference(orderTime);

  /// Tempo rimanente per la consegna
  Duration? get remainingDeliveryTime {
    if (status == OrderStatus.delivered || status == OrderStatus.cancelled) {
      return null;
    }
    final now = DateTime.now();
    final remaining = estimatedDelivery.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Verifica se l'ordine è in ritardo
  bool get isLate {
    if (status == OrderStatus.delivered || status == OrderStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(estimatedDelivery);
  }

  /// Numero di pizze totali
  int get totalPizzas => items.fold(0, (sum, item) => sum + item.quantity);

  PizzaOrder copyWith({
    String? id,
    List<PizzaOrderItem>? items,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? deliveryAddress,
    String? deliveryNotes,
    DateTime? orderTime,
    DateTime? estimatedDelivery,
    OrderStatus? status,
    double? totalAmount,
    double? deliveryFee,
    double? discount,
    PaymentMethod? paymentMethod,
    String? couponCode,
    DateTime? deliveredAt,
    String? cancellationReason,
  }) {
    return PizzaOrder(
      id: id ?? this.id,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      orderTime: orderTime ?? this.orderTime,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      couponCode: couponCode ?? this.couponCode,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
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
        other.customerEmail == customerEmail &&
        other.deliveryAddress == deliveryAddress &&
        other.status == status &&
        other.totalAmount == totalAmount &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      items,
      customerName,
      customerPhone,
      customerEmail,
      deliveryAddress,
      status,
      totalAmount,
      paymentMethod,
    );
  }

  @override
  String toString() {
    return 'PizzaOrder(id: $id, customer: $customerName, items: ${items.length}, status: ${status.displayName}, total: $totalFormatted)';
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
