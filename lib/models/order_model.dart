library;

/// Order models representing confirmed orders and line items.

class CustomerModel {
  final String name;
  final String phone;
  final String address;
  final String email;

  const CustomerModel({
    required this.name,
    required this.phone,
    required this.address,
    this.email = '',
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'address': address,
    'email': email,
  };
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String size;
  final String color;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.size,
    required this.color,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return OrderItemModel(
      productId: json['productId']?.toString() ??
          json['product_id']?.toString() ??
          '',
      productName: json['productName']?.toString() ??
          json['product_name']?.toString() ??
          '',
      productImage: json['productImage']?.toString() ??
          json['product_image']?.toString() ??
          '',
      size: json['size']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: parseNum(json['unitPrice'] ?? json['unit_price']),
      totalPrice: parseNum(json['totalPrice'] ?? json['total_price']),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'size': size,
    'color': color,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
  };
}

class OrderModel {
  final String id;
  final String orderNumber;
  final List<OrderItemModel> items;
  final double subtotal;
  final double delivery;
  final double total;
  final CustomerModel customer;
  final String status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.customer,
    this.status = 'Confirmed',
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final rawItems = json['items'] as List? ?? [];
    final itemsList = rawItems
        .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    DateTime parsedDate;
    if (json['createdAt'] != null) {
      parsedDate = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    } else if (json['created_at'] != null) {
      parsedDate = DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ??
          json['order_number']?.toString() ??
          '',
      items: itemsList,
      subtotal: parseNum(json['subtotal']),
      delivery: parseNum(json['delivery']),
      total: parseNum(json['total']),
      customer: CustomerModel.fromJson(
        json['customer'] != null
            ? Map<String, dynamic>.from(json['customer'] as Map)
            : const {},
      ),
      status: json['status']?.toString() ?? 'Confirmed',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderNumber': orderNumber,
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal': subtotal,
    'delivery': delivery,
    'total': total,
    'customer': customer.toJson(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };
}
