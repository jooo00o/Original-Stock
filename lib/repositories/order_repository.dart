import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:original_stock/core/env.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/models/order_model.dart';

/// Contract for order placement, OTP verification, and order history.
abstract class OrderRepository {
  Future<void> requestOtp(String phone);
  Future<bool> verifyOtp(String phone, String code);
  Future<OrderModel> placeOrder(OrderModel draft);
  Future<List<OrderModel>> getOrders(String phone);
}

/// Mock order repository persisting orders locally in [FlutterSecureStorage].
class MockOrderRepository implements OrderRepository {
  final FlutterSecureStorage _storage;
  static const _ordersStorageKey = 'local_mock_orders';

  MockOrderRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static final MockOrderRepository instance = MockOrderRepository();

  @override
  Future<void> requestOtp(String phone) async {
    // Simulate WhatsApp OTP dispatch delay
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<bool> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Accepts any 6-digit number as valid mock OTP
    final trimmed = code.trim();
    return trimmed.length == 6 && RegExp(r'^[0-9]{6}$').hasMatch(trimmed);
  }

  @override
  Future<OrderModel> placeOrder(OrderModel draft) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final generatedOrderNum = draft.orderNumber.isNotEmpty
        ? draft.orderNumber
        : '#OS-${Random().nextInt(90000) + 10000}';

    final confirmed = OrderModel(
      id: draft.id.isNotEmpty
          ? draft.id
          : 'ord-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: generatedOrderNum,
      items: draft.items,
      subtotal: draft.subtotal,
      delivery: draft.delivery,
      total: draft.total,
      customer: draft.customer,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    // Save to local storage
    try {
      final existingOrders = await getOrders(draft.customer.phone);
      final updatedList = [
        confirmed,
        ...existingOrders.where((o) => o.id != confirmed.id),
      ];
      final encoded = jsonEncode(updatedList.map((o) => o.toJson()).toList());
      await _storage.write(key: _ordersStorageKey, value: encoded);
    } catch (_) {}

    return confirmed;
  }

  @override
  Future<List<OrderModel>> getOrders(String phone) async {
    await Future.delayed(kMockNetworkDelay);
    try {
      final raw = await _storage.read(key: _ordersStorageKey);
      if (raw != null && raw.isNotEmpty) {
        final List decoded = jsonDecode(raw) as List;
        return decoded
            .map(
              (item) =>
                  OrderModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
      }
    } catch (_) {}

    // Initial default demo orders for first-time profile view
    return [
      OrderModel(
        id: 'ord-default-1',
        orderNumber: '#OS-10293',
        items: const [
          OrderItemModel(
            productId: 'prod-003',
            productName: 'Tokyo Winter Jacket',
            productImage:
                'assets/images/703796768_18133742803562861_1683141948809483400_n.jpg',
            size: 'L',
            color: 'Midnight Black',
            quantity: 1,
            unitPrice: 590.0,
            totalPrice: 590.0,
          ),
        ],
        subtotal: 590.0,
        delivery: 0.0,
        total: 590.0,
        customer: CustomerModel(
          name: 'Guest Customer',
          phone: phone.isNotEmpty ? phone : '01012345678',
          address: 'Cairo, Egypt',
        ),
        status: 'Shipped',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}

/// Remote API implementation using Dio HTTP client.
class ApiOrderRepository implements OrderRepository {
  final Dio _dio;

  ApiOrderRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: Env.baseUrl,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${Env.apiToken}',
              },
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  static final ApiOrderRepository instance = ApiOrderRepository();

  @override
  Future<void> requestOtp(String phone) async {
    try {
      await _dio.post(Env.otpRequestEndpoint, data: {'phone': phone});
    } on DioException catch (e) {
      throw Exception('Failed to request OTP: ${e.message}');
    }
  }

  @override
  Future<bool> verifyOtp(String phone, String code) async {
    try {
      final response = await _dio.post(
        Env.otpVerifyEndpoint,
        data: {'phone': phone, 'code': code},
      );

      final dynamic data = response.data;
      if (data is Map) {
        return data['verified'] == true ||
            data['success'] == true ||
            response.statusCode == 200;
      }
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('OTP verification failed: ${e.message}');
    }
  }

  @override
  Future<OrderModel> placeOrder(OrderModel draft) async {
    try {
      final response = await _dio.post(
        Env.ordersEndpoint,
        data: draft.toJson(),
      );

      final dynamic data = response.data is Map
          ? (response.data['data'] ?? response.data['order'] ?? response.data)
          : response.data;

      return OrderModel.fromJson(Map<String, dynamic>.from(data as Map));
    } on DioException catch (e) {
      throw Exception('Failed to place order: ${e.message}');
    }
  }

  @override
  Future<List<OrderModel>> getOrders(String phone) async {
    try {
      final response = await _dio.get(
        Env.ordersEndpoint,
        queryParameters: {'phone': phone},
      );

      final dynamic raw = response.data is Map
          ? (response.data['data'] ?? response.data['orders'] ?? [])
          : response.data;

      if (raw is List) {
        return raw
            .map(
              (item) =>
                  OrderModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    }
  }
}
