import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({String? category});
  Future<List<Product>> getFeaturedProducts();
  Future<Product> getProductById(String id);
}
