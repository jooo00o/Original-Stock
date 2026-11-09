import 'package:original_stock/repositories/order_repository.dart';
import 'package:original_stock/repositories/product_repository.dart';

/// Single switch to toggle between local mock data and remote backend API.
/// When the backend is ready, change this one flag to `false`.
const bool useMockData = true;

/// Artificial network delay for realistic shimmer loading demo.
const Duration kMockNetworkDelay = Duration(milliseconds: 600);

class ServiceLocator {
  ServiceLocator._();

  static ProductRepository get productRepository {
    return useMockData
        ? MockProductRepository.instance
        : ApiProductRepository.instance;
  }

  static OrderRepository get orderRepository {
    return useMockData
        ? MockOrderRepository.instance
        : ApiOrderRepository.instance;
  }
}

/// Direct top-level accessors for clean dependency injection throughout the app
ProductRepository get productRepository => ServiceLocator.productRepository;
OrderRepository get orderRepository => ServiceLocator.orderRepository;
