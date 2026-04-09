import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../domain/entities/order.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _paymentMethod = 0; // 0: UPI, 1: Card, 2: COD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('CHECKOUT'),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlacedSuccess) {
            context.read<CartBloc>().add(ClearCart());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.surface,
                title: const Icon(Icons.check_circle, color: AppColors.primary, size: 60),
                content: const Text('Your masterpiece is being prepared for delivery.', textAlign: TextAlign.center),
                actions: [
                   Center(
                     child: TextButton(
                       onPressed: () {
                         Navigator.popUntil(context, (route) => route.isFirst);
                       },
                       child: const Text('BACK TO HOME', style: TextStyle(color: AppColors.primary)),
                     ),
                   )
                ],
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Address', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vaidehi Sharma', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('123, Khandeshwar, Navi Mumbai\nMaharashtra, India, 410206', style: TextStyle(color: AppColors.textMuted)),
                    SizedBox(height: 8),
                    Text('+91 99999 00000'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Payment Method', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              _buildPaymentOption(0, 'UPI', Icons.qr_code_scanner),
              const SizedBox(height: 12),
              _buildPaymentOption(1, 'Credit / Debit Card', Icons.credit_card),
              const SizedBox(height: 12),
              _buildPaymentOption(2, 'Cash on Delivery', Icons.money),
              
              const SizedBox(height: 48),
              CustomButton(
                text: 'CONFIRM ORDER',
                onPressed: () {
                  final cartState = context.read<CartBloc>().state;
                  if (cartState is! CartLoaded || cartState.items.isEmpty) return;

                  final order = Order(
                    id: const Uuid().v4(),
                    items: cartState.items,
                    totalAmount: cartState.totalAmount,
                    status: 'Processing',
                    date: DateTime.now(),
                  );
                  context.read<OrderBloc>().add(PlaceOrder(order));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, IconData icon) {
    final isSelected = _paymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() => _paymentMethod = index);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.white),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
