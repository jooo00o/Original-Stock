import 'package:dio/dio.dart';
import 'package:original_stock/core/env.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/models/product_model.dart';

/// Contract for fetching products and categories.
abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({int page = 1});
  Future<List<ProductModel>> search(String q);
  Future<List<String>> getCategories();
}

/// In-memory mock repository populated with local demo catalog.
class MockProductRepository implements ProductRepository {
  MockProductRepository._();
  static final MockProductRepository instance = MockProductRepository._();

  static const List<ProductModel> demoProducts = [
    ProductModel(
      id: "prod-001",
      name: "Oversized Wool Coat",
      image:
          "assets/images/686506127_18133742785562861_5213842607967549061_n.jpg",
      price: 450.0,
      oldPrice: 600.0,
      rating: 4.8,
      category: "Outerwear",
      description:
          "Premium structured oversized coat crafted from dense virgin wool blend for exceptional warmth and clean modern drape.",
      images: [
        "assets/images/686506127_18133742785562861_5213842607967549061_n.jpg",
        "assets/images/vintageinspired-outerwear-designs_1104763-41888.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-002",
      name: "Red Cotton T-Shirt",
      image:
          "assets/images/696679803_18133742905562861_8782142470978230832_n.jpg",
      price: 220.0,
      rating: 4.0,
      category: "Shirts",
      description:
          "Breathable heavyweight cotton tee with ribbed crew neck and relaxed tailoring designed for effortless daily layering.",
      images: [
        "assets/images/696679803_18133742905562861_8782142470978230832_n.jpg",
        "assets/images/three-t-shirts-with-mountain-scene-them-are-hanging-wall-generative-ai_958098-68503.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-003",
      name: "Tokyo Winter Jacket",
      image:
          "assets/images/703796768_18133742803562861_1683141948809483400_n.jpg",
      price: 590.0,
      oldPrice: 750.0,
      rating: 4.6,
      category: "Outerwear",
      description:
          "Technical insulated street jacket inspired by Tokyo urban wear, featuring storm flap closure and soft satin lining.",
      images: [
        "assets/images/703796768_18133742803562861_1683141948809483400_n.jpg",
        "assets/images/705968716_18133742740562861_1785207526640979999_n.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-004",
      name: "Urban Track Jacket",
      image:
          "assets/images/705968716_18133742740562861_1785207526640979999_n.jpg",
      price: 390.0,
      rating: 4.2,
      category: "Outerwear",
      description:
          "Lightweight wind-resistant zip track jacket with contrast minimal piping and ergonomic stretch panels.",
      images: [
        "assets/images/705968716_18133742740562861_1785207526640979999_n.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-005",
      name: "Pastel Oxford Shirt",
      image:
          "assets/images/neatly-folded-including-two-pastelcolored-shirts-one-blue-shirt-placed-table-with-blurred_1308352-31028.jpg",
      price: 340.0,
      oldPrice: 420.0,
      rating: 4.7,
      category: "Shirts",
      description:
          "Crisp pure cotton oxford shirt with structured button-down collar and tailored sleeves for sharp smart-casual wear.",
      images: [
        "assets/images/neatly-folded-including-two-pastelcolored-shirts-one-blue-shirt-placed-table-with-blurred_1308352-31028.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-006",
      name: "Classic Knit Sweater",
      image:
          "assets/images/white-isolated-male-sweater-transparent-background_410516-125527.jpg",
      price: 480.0,
      rating: 4.9,
      category: "Knitwear",
      description:
          "Fine-gauge knitted crew sweater crafted from soft tactile yarns for luxurious comfort across cold seasons.",
      images: [
        "assets/images/white-isolated-male-sweater-transparent-background_410516-125527.jpg",
      ],
      sizes: ["S", "M", "L", "XL", "XXL"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-007",
      name: "Urban Running Sneaker",
      image: "assets/images/shoes-running-sneakers-design_849407-6889.jpg",
      price: 620.0,
      oldPrice: 800.0,
      rating: 4.5,
      category: "Shoes",
      description:
          "Cushioned lifestyle trainer engineered with shock-absorbing foam sole and lightweight breathable knit mesh upper.",
      images: [
        "assets/images/shoes-running-sneakers-design_849407-6889.jpg",
        "assets/images/classic-sneaker-sport-street-wear-fashionable-athletic-apparellight-red-blue_1100418-709.jpg",
      ],
      sizes: ["40", "41", "42", "43", "44", "45"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
    ProductModel(
      id: "prod-008",
      name: "Slim Fit Indigo Jeans",
      image: "assets/images/fashionable-pants-isolated_23-2151336726.jpg",
      price: 410.0,
      rating: 4.4,
      category: "Jeans",
      description:
          "Deep indigo denim with 2% elastane flex stretch for uncompromised mobility and all-day comfort.",
      images: ["assets/images/fashionable-pants-isolated_23-2151336726.jpg"],
      sizes: ["30", "32", "34", "36", "38"],
      colors: ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts({int page = 1}) async {
    await Future.delayed(kMockNetworkDelay); 
    return List.from(demoProducts);
  }

  @override
  Future<List<ProductModel>> search(String q) async {
    await Future.delayed(kMockNetworkDelay); 
    if (q.trim().isEmpty) return List.from(demoProducts);
    final query = q.trim().toLowerCase();
    return demoProducts.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(kMockNetworkDelay); 
    return const ['All', 'Shirts', 'Outerwear', 'Knitwear', 'Shoes', 'Jeans'];
  }
}

class ApiProductRepository implements ProductRepository {
  final Dio _dio;

  ApiProductRepository({Dio? dio})
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

  static final ApiProductRepository instance = ApiProductRepository();

  @override
  Future<List<ProductModel>> getProducts({int page = 1}) async {
    try {
      final response = await _dio.get(
        Env.productsEndpoint,
        queryParameters: {'page': page},
      );

      final dynamic raw = response.data is Map
          ? (response.data['data'] ?? response.data['products'] ?? [])
          : response.data;

      if (raw is List) {
        return raw
            .map(
              (item) =>
                  ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load products: ${e.message}');
    }
  }

  @override
  Future<List<ProductModel>> search(String q) async {
    try {
      final response = await _dio.get(
        Env.searchEndpoint,
        queryParameters: {'q': q},
      );

      final dynamic raw = response.data is Map
          ? (response.data['data'] ?? response.data['results'] ?? [])
          : response.data;

      if (raw is List) {
        return raw
            .map(
              (item) =>
                  ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Search failed: ${e.message}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get(Env.categoriesEndpoint);

      final dynamic raw = response.data is Map
          ? (response.data['data'] ?? response.data['categories'] ?? [])
          : response.data;

      if (raw is List) {
        final list = raw.map((e) => e.toString()).toList();
        if (!list.contains('All')) {
          list.insert(0, 'All');
        }
        return list;
      }
      return const ['All', 'Shirts', 'Outerwear', 'Knitwear', 'Shoes', 'Jeans'];
    } on DioException catch (e) {
      throw Exception('Failed to load categories: ${e.message}');
    }
  }
}
