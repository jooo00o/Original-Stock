/// Product data model with numeric pricing and JSON serialization.
class ProductModel {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final double price;
  final double? oldPrice;
  final double rating;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  const ProductModel({
    this.id = '',
    required this.name,
    required this.image,
    this.images = const [],
    required this.price,
    this.oldPrice,
    this.rating = 4.5,
    this.category = 'All',
    this.description = '',
    this.sizes = const ["S", "M", "L", "XL", "XXL"],
    this.colors = const ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Robust double parsing for price
    double parseNum(dynamic val, [double defaultVal = 0.0]) {
      if (val == null) return defaultVal;
      if (val is num) return val.toDouble();
      if (val is String) {
        final cleaned = val.replaceAll(RegExp(r'[^0-9.]'), '');
        return double.tryParse(cleaned) ?? defaultVal;
      }
      return defaultVal;
    }

    final priceVal = parseNum(json['price']);
    final oldPriceVal = json['oldPrice'] != null || json['old_price'] != null
        ? parseNum(json['oldPrice'] ?? json['old_price'])
        : null;

    final ratingVal = parseNum(json['rating'], 4.5);

    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    final rawImages = parseStringList(json['images']);
    final primaryImg = json['image']?.toString() ??
        (rawImages.isNotEmpty ? rawImages.first : '');

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: primaryImg,
      images: rawImages.isNotEmpty ? rawImages : (primaryImg.isNotEmpty ? [primaryImg] : const []),
      price: priceVal,
      oldPrice: oldPriceVal,
      rating: ratingVal,
      category: json['category']?.toString() ?? 'All',
      description: json['description']?.toString() ?? '',
      sizes: json['sizes'] != null
          ? parseStringList(json['sizes'])
          : const ["S", "M", "L", "XL", "XXL"],
      colors: json['colors'] != null
          ? parseStringList(json['colors'])
          : const ["Midnight Black", "Heather Grey", "Off White", "Deep Navy"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'images': images,
      'price': price,
      if (oldPrice != null) 'oldPrice': oldPrice,
      'rating': rating,
      'category': category,
      'description': description,
      'sizes': sizes,
      'colors': colors,
    };
  }
}
