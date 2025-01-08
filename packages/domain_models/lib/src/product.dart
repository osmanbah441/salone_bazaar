enum ProductCategory {
  all,
  clothing,
  accessories,
  home;
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
}

class ProductListPage {
  final bool isLastPage;
  final List<Product> productList;

  const ProductListPage({required this.isLastPage, required this.productList});
}
