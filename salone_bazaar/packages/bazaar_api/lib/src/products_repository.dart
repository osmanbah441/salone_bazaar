import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

class ProductsRepository {
  const ProductsRepository();
  static final _ref = FirebaseFirestore.instance.collection('products');

  static DocumentSnapshot?
      _lastDocument; // Store the last document for pagination

  Future<void> add(Product product) async => await _ref.add(product.toMap());

  Future<ProductListPage> getProductListPage({
    required int page,
    String category = '',
    String searchTerm = '',
    int limit = 10,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));
    if (page == 1) _lastDocument = null;
    final isFiltering = category.isNotEmpty && searchTerm.isEmpty;
    final isSearching = category.isEmpty && searchTerm.isNotEmpty;
    Query query = _ref;

    if (isFiltering) {
      query = query.where('category', isEqualTo: category);
      _lastDocument = null;
    }
    if (isSearching) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: '$searchTerm\uf8ff');
      _lastDocument = null;
    }
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    query.limit(limit);

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      return const ProductListPage(isLastPage: true, productList: []);
    }
    // Update the last document for the next pagination call
    final isLastPage = snapshot.docs.length < limit;
    _lastDocument = snapshot.docs.last;

    final products = snapshot.docs
        .map((doc) =>
            Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    return ProductListPage(isLastPage: isLastPage, productList: products);
  }

  Future<void> update(Product product) async =>
      await _ref.doc(product.id).update(product.toMap());

  Future<void> deleteProduct(String id) async => await _ref.doc(id).delete();

  Future<Product?> getSingle(String id) async {
    final snapshot = await _ref.doc(id).get();
    if (snapshot.data() == null) return null;
    return Product.fromMap(snapshot.data()!, snapshot.id);
  }
}
