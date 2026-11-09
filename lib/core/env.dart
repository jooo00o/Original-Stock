/// Central environment configuration for API integration.
/// Contains placeholder values with no real secrets committed.
class Env {
  Env._();

  /// Base URL for backend endpoints
  static const String baseUrl = 'https://api.originalstock.com/v1';

  /// Placeholder bearer authorization token
  static const String apiToken = 'PLACEHOLDER_TOKEN_BEARER';

  // API Endpoints
  static const String productsEndpoint = '/products';
  static const String searchEndpoint = '/products/search';
  static const String categoriesEndpoint = '/categories';
  static const String otpRequestEndpoint = '/auth/otp/request';
  static const String otpVerifyEndpoint = '/auth/otp/verify';
  static const String ordersEndpoint = '/orders';
}

