import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String status; // Processing, Shipped, Delivered
  final DateTime date;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props => [id, items, totalAmount, status, date];
}
