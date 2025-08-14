import 'dart:convert';

class DeliveryAgentOrderListResponse {
  final bool success;
  final DeliveryAgentOrderListData? data;

  DeliveryAgentOrderListResponse({required this.success, this.data});

  factory DeliveryAgentOrderListResponse.fromJson(String source) =>
      DeliveryAgentOrderListResponse.fromMap(json.decode(source));

  factory DeliveryAgentOrderListResponse.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentOrderListResponse(
      success: map['success'] ?? false,
      data: map['data'] != null
          ? DeliveryAgentOrderListData.fromMap(map['data'])
          : null,
    );
  }
}

class DeliveryAgentOrderListData {
  final int count;
  final int pageCount;
  final List<DeliveryAgentOrder> orders;

  DeliveryAgentOrderListData(
      {required this.count, required this.pageCount, required this.orders});

  factory DeliveryAgentOrderListData.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentOrderListData(
      count: map['count'] ?? 0,
      pageCount: map['pageCount'] ?? 0,
      orders: map['data'] != null
          ? List<DeliveryAgentOrder>.from(
              (map['data'] as List).map((x) => DeliveryAgentOrder.fromMap(x)),
            )
          : [],
    );
  }
}

class DeliveryAgentOrder {
  final String id;
  final Branch branch;
  final Customer customer;
  final bool isPickup;
  final List<OrderItem> items;
  final String status;
  final DeliveryAddress deliveryAddress;
  final double deliveryCharge;
  final double gstCharge;
  final double totalAmount;
  final String paymentMethod;
  final List<StatusTimeline> statusTimeline;
  final String specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String orderId;
  final String? deliveryProof;

  DeliveryAgentOrder({
    required this.id,
    required this.branch,
    required this.customer,
    required this.isPickup,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.deliveryCharge,
    required this.gstCharge,
    required this.totalAmount,
    required this.paymentMethod,
    required this.statusTimeline,
    required this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
    this.deliveryProof,
  });

  factory DeliveryAgentOrder.fromMap(Map<String, dynamic> map) {
    return DeliveryAgentOrder(
      id: map['_id'] ?? '',
      branch: Branch.fromMap(map['branchId'] ?? {}),
      customer: Customer.fromMap(map['customerId'] ?? {}),
      isPickup: map['isPickup'] ?? false,
      items: map['items'] != null
          ? List<OrderItem>.from(
              (map['items'] as List).map((x) => OrderItem.fromMap(x)))
          : [],
      status: map['status'] ?? '',
      deliveryAddress: DeliveryAddress.fromMap(map['deliveryAddress'] ?? {}),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      gstCharge: (map['gstCharge'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      statusTimeline: map['statusTimeline'] != null
          ? List<StatusTimeline>.from((map['statusTimeline'] as List)
              .map((x) => StatusTimeline.fromMap(x)))
          : [],
      specialInstructions: map['specialInstructions'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      orderId: map['orderId'] ?? '',
      deliveryProof: map['deliveryProof'],
    );
  }
}

class Branch {
  final String id;
  final String name;
  final String address;
  Branch({required this.id, required this.name, required this.address});
  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }
}

class Customer {
  final String id;
  final String number;
  final String email;
  final String? image;
  final String? name;
  Customer(
      {required this.id,
      required this.number,
      required this.email,
      this.image,
      this.name});
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['_id'] ?? '',
      number: map['number'] ?? '',
      email: map['email'] ?? '',
      image: map['image'],
      name: map['customerName'] ?? '',
    );
  }
}

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final double price;
  final double totalPrice;
  final Variation? variation;
  OrderItem({
    required this.menuItem,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.variation,
  });
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuItem: MenuItem.fromMap(map['menuItem'] ?? {}),
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      variation:
          map['variation'] != null ? Variation.fromMap(map['variation']) : null,
    );
  }
}

class Variation {
  final VariationType? variationType;
  final double price;
  Variation({this.variationType, required this.price});
  factory Variation.fromMap(Map<String, dynamic> map) {
    return Variation(
      variationType: map['variationType'] != null
          ? VariationType.fromMap(map['variationType'])
          : null,
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}

class VariationType {
  final String id;
  final String name;
  VariationType({required this.id, required this.name});
  factory VariationType.fromMap(Map<String, dynamic> map) {
    return VariationType(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final String? description;
  MenuItem(
      {required this.id,
      required this.name,
      required this.images,
      required this.price,
      this.discountPrice,
      this.description});
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: map['discountPrice'] != null
          ? (map['discountPrice'] as num?)?.toDouble()
          : null,
      description: map['description'],
    );
  }
}

class DeliveryAddress {
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String customerName;
  DeliveryAddress({
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.landmark,
    required this.customerName,
  });
  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      landmark: map['landmark'] ?? '',
      customerName: map['customerName'] ?? '',
    );
  }
}

class StatusTimeline {
  final String status;
  final DateTime timestamp;
  final String updatedBy;
  StatusTimeline(
      {required this.status, required this.timestamp, required this.updatedBy});
  factory StatusTimeline.fromMap(Map<String, dynamic> map) {
    return StatusTimeline(
      status: map['status'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      updatedBy: map['updatedBy'] ?? '',
    );
  }
}
