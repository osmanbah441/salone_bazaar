import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

import 'mappers.dart';

class ProductsRepository {
  const ProductsRepository();
  static final _productRef = FirebaseFirestore.instance.collection('products');

// Store the last document for pagination
  static DocumentSnapshot? _lastDocument;

  Future<void> addProduct(Product product) async =>
      await _productRef.add(product.toMap);

  Future<ProductListPage> getProductListPage({
    required int page,
    String category = '',
    String searchTerm = '',
    int limit = 10,
  }) async {
    if (page == 1) _lastDocument = null;
    final isFiltering = category.isNotEmpty && searchTerm.isEmpty;
    final isSearching = category.isEmpty && searchTerm.isNotEmpty;
    Query query = _productRef;

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

    final products = snapshot.docs.map((doc) => doc.toDomain).toList();

    return ProductListPage(isLastPage: isLastPage, productList: products);
  }

  Future<void> updateProduct(Product product) async =>
      await _productRef.doc(product.id).update(product.toMap);

  Future<void> deleteProduct(String id) async =>
      await _productRef.doc(id).delete();

  Future<Product?> getSingleProduct(String id) async {
    final snapshot = await _productRef.doc(id).get();
    if (snapshot.data() == null) return null;
    return snapshot.toDomain;
  }
}
