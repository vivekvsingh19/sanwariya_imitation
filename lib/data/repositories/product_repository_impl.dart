import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock Data
  final List<Product> _mockProducts = const [
    Product(
      id: 'p1',
      title: 'The Rajkumari Emerald Choker',
      description: 'Intricate emerald choker with kundan framework. Handcrafted precisely over 120 hours. Minimalistic elegant piece representing timeless tradition.',
      price: 425000,
      originalPrice: 510000,
      imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=600&auto=format&fit=crop', // Necklace dummy
      category: 'Necklaces',
      rating: 4.9,
      isFeatured: true,
    ),
    Product(
      id: 'p2',
      title: 'Rajasthan Kundan Set',
      description: 'Classic Rajasthan Kundan Set, perfect for weddings.',
      price: 24499,
      originalPrice: 28000,
      imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a8ef0f1db55?q=80&w=600&auto=format&fit=crop',
      category: 'Necklaces',
      rating: 4.8,
    ),
    Product(
      id: 'p3',
      title: 'Emerald Bloom Rani Haar',
      description: 'Stunning Rani Haar embellished with emerald stones.',
      price: 32000,
      originalPrice: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600&auto=format&fit=crop',
      category: 'Necklaces',
      rating: 4.7,
      isFeatured: true,
    ),
    Product(
      id: 'p4',
      title: 'Temple Art Kada',
      description: 'Traditional temple art bangles, pack of 2.',
      price: 18900,
      originalPrice: 21000,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600&auto=format&fit=crop',// bangles
      category: 'Bangles',
      rating: 4.6,
    ),
  ];

  @override
  Future<List<Product>> getProducts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (category != null && category.isNotEmpty) {
      return _mockProducts.where((p) => p.category == category).toList();
    }
    return _mockProducts;
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockProducts.where((p) => p.isFeatured).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockProducts.firstWhere((p) => p.id == id);
  }
}
