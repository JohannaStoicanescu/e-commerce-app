import 'cart_item.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final String? paymentIntentId;
  final ShippingAddress shippingAddress;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.status,
    this.paymentIntentId,
    required this.shippingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'paymentIntentId': paymentIntentId,
      'shippingAddress': shippingAddress.toJson(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.byName(json['status']),
      paymentIntentId: json['paymentIntentId'],
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
    );
  }

  String get formattedTotal => '${total.toStringAsFixed(2)} €';

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.processing:
        return 'En cours';
      case OrderStatus.shipped:
        return 'Expédiée';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }
}

class ShippingAddress {
  final String fullName;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.fullName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'],
      street: json['street'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
      phone: json['phone'],
    );
  }

  String get formattedAddress {
    return '$fullName\n$street\n$city, $postalCode\n$country';
  }
}
