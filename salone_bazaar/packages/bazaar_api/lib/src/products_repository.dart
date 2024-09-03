import 'package:domain_models/domain_models.dart';

class ProductsRepository {
  const ProductsRepository();

  static const _allProducts = <Product>[
    Product(
      category: ProductCategory.accessories,
      id: '0',
      isFeatured: true,
      name: 'Vagabond sack',
      price: 120,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '1',
      isFeatured: true,
      name: 'Stella sunglasses',
      price: 58,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '2',
      isFeatured: false,
      name: 'Whitney belt',
      price: 35,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '3',
      isFeatured: true,
      name: 'Garden strand',
      price: 98,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '4',
      isFeatured: false,
      name: 'Strut earrings',
      price: 34,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '5',
      isFeatured: false,
      name: 'Varsity socks',
      price: 12,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '6',
      isFeatured: false,
      name: 'Weave keyring',
      price: 16,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '7',
      isFeatured: true,
      name: 'Gatsby hat',
      price: 40,
    ),
    Product(
      category: ProductCategory.accessories,
      id: '8',
      isFeatured: true,
      name: 'Shrug bag',
      price: 198,
    ),
    Product(
      category: ProductCategory.home,
      id: '9',
      isFeatured: true,
      name: 'Gilt desk trio',
      price: 58,
    ),
    Product(
      category: ProductCategory.home,
      id: '10',
      isFeatured: false,
      name: 'Copper wire rack',
      price: 18,
    ),
    Product(
      category: ProductCategory.home,
      id: '11',
      isFeatured: false,
      name: 'Soothe ceramic set',
      price: 28,
    ),
    Product(
      category: ProductCategory.home,
      id: '12',
      isFeatured: false,
      name: 'Hurrahs tea set',
      price: 34,
    ),
    Product(
      category: ProductCategory.home,
      id: '13',
      isFeatured: true,
      name: 'Blue stone mug',
      price: 18,
    ),
    Product(
      category: ProductCategory.home,
      id: '14',
      isFeatured: true,
      name: 'Rainwater tray',
      price: 27,
    ),
    Product(
      category: ProductCategory.home,
      id: '15',
      isFeatured: true,
      name: 'Chambray napkins',
      price: 16,
    ),
    Product(
      category: ProductCategory.home,
      id: '16',
      isFeatured: true,
      name: 'Succulent planters',
      price: 16,
    ),
    Product(
      category: ProductCategory.home,
      id: '17',
      isFeatured: false,
      name: 'Quartet table',
      price: 175,
    ),
    Product(
      category: ProductCategory.home,
      id: '18',
      isFeatured: true,
      name: 'Kitchen quattro',
      price: 129,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '19',
      isFeatured: false,
      name: 'Clay sweater',
      price: 48,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '20',
      isFeatured: false,
      name: 'Sea tunic',
      price: 45,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '21',
      isFeatured: false,
      name: 'Plaster tunic',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '22',
      isFeatured: false,
      name: 'White pinstripe shirt',
      price: 70,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '23',
      isFeatured: false,
      name: 'Chambray shirt',
      price: 70,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '24',
      isFeatured: true,
      name: 'Seabreeze sweater',
      price: 60,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '25',
      isFeatured: false,
      name: 'Gentry jacket',
      price: 178,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '26',
      isFeatured: false,
      name: 'Navy trousers',
      price: 74,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '27',
      isFeatured: true,
      name: 'Walter henley (white)',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '28',
      isFeatured: true,
      name: 'Surf and perf shirt',
      price: 48,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '29',
      isFeatured: true,
      name: 'Ginger scarf',
      price: 98,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '30',
      isFeatured: true,
      name: 'Ramona crossover',
      price: 68,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '31',
      isFeatured: false,
      name: 'Chambray shirt',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '32',
      isFeatured: false,
      name: 'Classic white collar',
      price: 58,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '33',
      isFeatured: true,
      name: 'Cerise scallop tee',
      price: 42,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '34',
      isFeatured: false,
      name: 'Shoulder rolls tee',
      price: 27,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '35',
      isFeatured: false,
      name: 'Grey slouch tank',
      price: 24,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '36',
      isFeatured: false,
      name: 'Sunshirt dress',
      price: 58,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '37',
      isFeatured: true,
      name: 'Fine lines tee',
      price: 58,
    ),
  ];

  Future<ProductListPage> getProductListPage({
    required int page,
    required String category,
    required String searchTerm,
  }) async {
    // Simulate a delay for the API call
    await Future.delayed(const Duration(seconds: 1));

    // Filter products by category if provided
    final filteredProducts = category == 'all'
        ? _allProducts
        : _allProducts
            .where((Product p) => p.category.name == category)
            .toList();

    // Define the number of items per page
    const int itemsPerPage = 5;

    // Calculate the start and end indices for the current page
    final int startIndex = (page - 1) * itemsPerPage;
    final int endIndex = startIndex + itemsPerPage;

    // Get the list of products for the current page
    final List<Product> pagedProducts = filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );

    // Determine if this is the last page
    final bool isLastPage = endIndex >= filteredProducts.length;

    return ProductListPage(
      isLastPage: isLastPage,
      productList: pagedProducts,
    );
  }
}
