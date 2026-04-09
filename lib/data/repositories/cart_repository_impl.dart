import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _cart = [];

  @override
  Future<List<CartItem>> getCart() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_cart);
  }

  @override
  Future<void> addToCart(CartItem item) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _cart.indexWhere((i) => i.product.id == item.product.id);
    if (index >= 0) {
      _cart[index] = _cart[index].copyWith(quantity: _cart[index].quantity + item.quantity);
    } else {
      _cart.add(item);
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cart.removeWhere((item) => item.id == itemId);
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _cart.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cart.clear();
  }
}
