class ProductListPage {
  const ProductListPage({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<Product> productList;
}

enum ProductCategory {
  all,
  accessories,
  clothing,
  home,
}

class Product {
  const Product({
    required this.category,
    required this.id,
    required this.isFeatured,
    required this.name,
    required this.price,
  });

  final ProductCategory category;
  final String id;
  final bool isFeatured;
  final String name;
  final int price;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => "$name (id=$id)";
}
