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
        description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
        imageUrl: 'https://picsum.photos/id/1/200/300'),
    Product(
        category: ProductCategory.accessories,
        id: '1',
        isFeatured: true,
        name: 'Stella sunglasses',
        price: 58,
        description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
        imageUrl: 'https://picsum.photos/id/10/200/300'),
    Product(
        category: ProductCategory.accessories,
        id: '2',
        isFeatured: false,
        name: 'Whitney belt',
        price: 35,
        description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
        imageUrl: 'https://picsum.photos/id/20/200/300'),
    Product(
        category: ProductCategory.accessories,
        id: '3',
        isFeatured: true,
        name: 'Garden strand',
        price: 98,
        description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
        imageUrl: 'https://picsum.photos/id/30/200/300'),
    Product(
        category: ProductCategory.accessories,
        id: '4',
        isFeatured: false,
        name: 'Strut earrings',
        price: 34,
        description:
            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
        imageUrl: 'https://picsum.photos/id/40/200/300'),
    Product(
      category: ProductCategory.accessories,
      id: '5',
      isFeatured: false,
      name: 'Varsity socks',
      price: 12,
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/50/200/300',
    ),
    Product(
      category: ProductCategory.accessories,
      id: '6',
      isFeatured: false,
      name: 'Weave keyring',
      price: 16,
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/60/200/300',
    ),
    Product(
      category: ProductCategory.accessories,
      id: '7',
      isFeatured: true,
      name: 'Gatsby hat',
      price: 40,
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/70/200/300',
    ),
    Product(
      category: ProductCategory.accessories,
      id: '8',
      isFeatured: true,
      name: 'Shrug bag',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/80/200/300',
      price: 198,
    ),
    Product(
      category: ProductCategory.home,
      id: '9',
      isFeatured: true,
      name: 'Gilt desk trio',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/90/200/300',
      price: 58,
    ),
    Product(
      category: ProductCategory.home,
      id: '10',
      isFeatured: false,
      name: 'Copper wire rack',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/100/200/300',
      price: 18,
    ),
    Product(
      category: ProductCategory.home,
      id: '11',
      isFeatured: false,
      name: 'Soothe ceramic set',
      imageUrl: 'https://picsum.photos/id/110/200/300',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      price: 28,
    ),
    Product(
      category: ProductCategory.home,
      id: '12',
      isFeatured: false,
      name: 'Hurrahs tea set',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/120/200/300',
      price: 34,
    ),
    Product(
      category: ProductCategory.home,
      id: '13',
      isFeatured: true,
      name: 'Blue stone mug',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/130/200/300',
      price: 18,
    ),
    Product(
      category: ProductCategory.home,
      id: '14',
      isFeatured: true,
      name: 'Rainwater tray',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/140/200/300',
      price: 27,
    ),
    Product(
      category: ProductCategory.home,
      id: '15',
      isFeatured: true,
      name: 'Chambray napkins',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/200/200/300',
      price: 16,
    ),
    Product(
      category: ProductCategory.home,
      id: '16',
      isFeatured: true,
      name: 'Succulent planters',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/160/200/300',
      price: 16,
    ),
    Product(
      category: ProductCategory.home,
      id: '17',
      isFeatured: false,
      name: 'Quartet table',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/170/200/300',
      price: 175,
    ),
    Product(
      category: ProductCategory.home,
      id: '18',
      isFeatured: true,
      name: 'Kitchen quattro',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/180/200/300',
      price: 129,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '19',
      isFeatured: false,
      name: 'Clay sweater',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/190/200/300',
      price: 48,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '20',
      isFeatured: false,
      name: 'Sea tunic',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/200/200/300',
      price: 45,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '21',
      isFeatured: false,
      name: 'Plaster tunic',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/210/200/300',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '22',
      isFeatured: false,
      name: 'White pinstripe shirt',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/220/200/300',
      price: 70,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '23',
      isFeatured: false,
      name: 'Chambray shirt',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/240/200/300',
      price: 70,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '24',
      isFeatured: true,
      name: 'Seabreeze sweater',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/330/200/300',
      price: 60,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '25',
      isFeatured: false,
      name: 'Gentry jacket',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/440/200/300',
      price: 178,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '26',
      isFeatured: false,
      name: 'Navy trousers',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/250/200/300',
      price: 74,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '27',
      isFeatured: true,
      name: 'Walter henley (white)',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/450/200/300',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '28',
      isFeatured: true,
      name: 'Surf and perf shirt',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/330/200/300',
      price: 48,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '29',
      isFeatured: true,
      name: 'Ginger scarf',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/43/200/300',
      price: 98,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '30',
      isFeatured: true,
      name: 'Ramona crossover',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/320/200/300',
      price: 68,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '31',
      isFeatured: false,
      name: 'Chambray shirt',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/120/200/300',
      price: 38,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '32',
      isFeatured: false,
      name: 'Classic white collar',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/210/200/300',
      price: 58,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '33',
      isFeatured: true,
      name: 'Cerise scallop tee',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/340/200/300',
      price: 42,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '34',
      isFeatured: false,
      name: 'Shoulder rolls tee',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/780/200/300',
      price: 27,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '35',
      isFeatured: false,
      name: 'Grey slouch tank',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/430/200/300',
      price: 24,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '36',
      isFeatured: false,
      name: 'Sunshirt dress',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/210/200/300',
      price: 58,
    ),
    Product(
      category: ProductCategory.clothing,
      id: '37',
      isFeatured: true,
      name: 'Fine lines tee',
      description:
          "Lorem ipsum dolor sit amet consectetur adipisicing elit. Aut expedita nulla veniam perspiciatis est? Possimus aliquam dolores officiis mollitia in nesciunt porro nulla, cum dolorum, quis aspernatur, sit ullam rem?",
      imageUrl: 'https://picsum.photos/id/220/200/300',
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

  Future<Product> getProductDetails(String productId) async {
    print(productId);
    await Future.delayed(const Duration(seconds: 1));
    return _allProducts.firstWhere((p) => p.id == productId);
  }

  add(
      {required String name,
      required String description,
      required double price,
      required String imagePath}) {}
}
