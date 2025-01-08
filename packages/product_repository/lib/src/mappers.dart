import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain_models/domain_models.dart';

Product _fromMap(String id, Map<String, dynamic> data) {
  ProductCategory productCategory = switch (data['category']) {
    'all' => ProductCategory.all,
    'clothing' => ProductCategory.clothing,
    'accessories' => ProductCategory.accessories,
    'home' => ProductCategory.home,
    _ => throw ('unknown category')
  };

  return Product(
    id: id,
    name: data['name'] as String,
    price: data['price'].toDouble(),
    isFeatured: data['isFeatured'] as bool,
    description: data['description'],
    category: productCategory,
    imageUrl: data['image_url'],
  );
}

extension QueryDocumentSnapshotToDomain on QueryDocumentSnapshot {
  Product get toDomain => _fromMap(id, data() as Map<String, dynamic>);
}

extension ProductToFirestore on Product {
  Map<String, dynamic> get toMap => {
        'name': name,
        'price': price,
        'isFeatured': isFeatured,
        'description': description,
        'category': category.name,
        'image_url': imageUrl,
      };
}

extension DocumentSnapshotToDomain on DocumentSnapshot {
  Product get toDomain => _fromMap(id, data() as Map<String, dynamic>);
}
