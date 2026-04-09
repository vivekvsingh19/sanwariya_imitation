import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final List<Order> _orders = [];

  @override
  Future<void> placeOrder(Order order) async {
    await Future.delayed(const Duration(seconds: 1));
    _orders.add(order);
  }

  @override
  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_orders.reversed); // newest first
  }
}
