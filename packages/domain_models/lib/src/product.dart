enum ProductCategory {
  all,
  clothing,
  accessories,
  home;

  static ProductCategory _getCategory(String category) {
    switch (category) {
      case 'all':
        return ProductCategory.all;

      case 'clothing':
        return ProductCategory.clothing;

      case 'accessories':
        return ProductCategory.accessories;

      case 'home':
        return ProductCategory.home;

      default:
        throw ('unknown category');
    }
  }
}

class Product {
  final String? id;
  final String name;
  final double price;
  final bool isFeatured;
  final String description;
  final ProductCategory category;
  final String imageUrl;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.isFeatured,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] as String,
      price: data['price'].toDouble(),
      isFeatured: data['isFeatured'] as bool,
      description: data['description'],
      category: ProductCategory._getCategory(data['category']),
      imageUrl: data['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'isFeatured': isFeatured,
      'description': description,
      'category': category.name,
      'image_url': imageUrl,
    };
  }
}

class ProductListPage {
  final bool isLastPage;
  final List<Product> productList;

  const ProductListPage({required this.isLastPage, required this.productList});
}
