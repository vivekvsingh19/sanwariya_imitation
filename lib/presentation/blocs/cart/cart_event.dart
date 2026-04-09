import 'package:equatable/equatable.dart';
import '../../../../domain/entities/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final CartItem item;
  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItemFromCart extends CartEvent {
  final String itemId;
  const RemoveItemFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateCartItemQuantity(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

class ClearCart extends CartEvent {}
