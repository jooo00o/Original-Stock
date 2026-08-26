// import 'package:dio/dio.dart';
// import 'package:original_stock/screens/home_screen.dart';

// class ApiService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://kinetic-electronics.lol/api/',
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization':
//             'Bearer 87|XhGauuOHBlyh54452IBsi6nE4BxiunoKEfvlQtQc7f511b6c',
//       },
//     ),
//   );

//   Future<List<ProductModel>> fetchProducts({int page = 1}) async {
//     try {
//       final response = await _dio.get(
//         'products',
//         queryParameters: {'page': page}, // 👈 بيبعت ?page=1 أو ?page=2 وهكذا
//       );
//       final List productsList = response.data['data'] ?? [];
//       return productsList.map((json) => ProductModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw Exception('فشل في جلب المنتجات: ${e.message}');
//     }
//   }
// }
