import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../../domain/entities/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _paymentMethod = 0;
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CHECKOUT',
          style: AppTypography.bodyLarge(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ).copyWith(letterSpacing: AppTypography.letterSpacingUltra),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.lock, color: AppColors.primary, size: 18),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlacedSuccess) {
             context.read<CartBloc>().add(ClearCart());
             _showSuccessDialog();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
            vertical: AppSpacing.screenPaddingV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow('Delivery Address', 'CHANGE'),
              const SizedBox(height: AppSpacing.lg),
              _buildAddressCard(),
              const SizedBox(height: AppSpacing.sectionGap),

              _buildHeaderRow('Payment Method', ''),
              const SizedBox(height: AppSpacing.lg),
              _buildPaymentOption(0, 'UPI', 'Google Pay, PhonePe, Paytm', Icons.account_balance_wallet_outlined),
              const SizedBox(height: AppSpacing.md),
              _buildPaymentOption(1, 'Credit / Debit Card', 'Visa, Mastercard, RuPay', Icons.credit_card_outlined),
              const SizedBox(height: AppSpacing.md),
              _buildPaymentOption(2, 'Net Banking', 'All major Indian banks', Icons.account_balance_outlined),
              const SizedBox(height: AppSpacing.md),
              _buildPaymentOption(3, 'Cash on Delivery', 'Pay when you receive your order', Icons.payments_outlined),

              const SizedBox(height: AppSpacing.sectionGap),
              _buildHeaderRow('Order Summary', ''),
              const SizedBox(height: AppSpacing.lg),

              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartLoaded) {
                    final subtotal = cartState.totalAmount;
                    final tax = subtotal * 0.03;
                    final total = subtotal + tax;
                    final itemCount = cartState.items.fold(0, (sum, item) => sum + item.quantity);

                    return Column(
                      children: [
                        _buildSummaryCard(subtotal, tax, total, itemCount),
                        const SizedBox(height: AppSpacing.sectionGap),
                        _buildPlaceOrderButton(cartState, total),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                },
              ),

              const SizedBox(height: AppSpacing.lg),
              _buildFooterText(),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlBorder),
        title: const Icon(LucideIcons.checkCircle, color: AppColors.primary, size: 60),
        content: Text(
          'Your masterpiece is being prepared for delivery.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(color: AppColors.textWhite),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                'BACK TO HOME',
                style: AppTypography.bodyMedium(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderRow(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingLarge(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (action.isNotEmpty)
          Text(
            action,
            style: AppTypography.bodySmall(
              color: AppColors.primary.withOpacity(0.6),
              letterSpacing: AppTypography.letterSpacingNormal,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: AppSpacing.cardLarge,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: AppRadius.xlBorder,
        boxShadow: [AppShadows.soft],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priya Sharma',
                  style: AppTypography.headingSmall(),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '102, Emerald Heights, Marine Drive\nNear Oberoi Hotel, Mumbai - 400021\nMaharashtra, India',
                  style: AppTypography.bodyMedium(
                    color: AppColors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Icon(LucideIcons.phone, color: AppColors.white70, size: 14),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '+91 98765 43210',
                      style: AppTypography.bodyMedium(color: AppColors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(LucideIcons.mapPin, color: AppColors.white24, size: 28),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, String title, String subtitle, IconData icon) {
    final isSelected = _paymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() => _paymentMethod = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceWarm,
          borderRadius: AppRadius.lgBorder,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall(color: AppColors.white54),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryBright : AppColors.white24,
                  width: isSelected ? 6 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double subtotal, double tax, double total, int itemCount) {
    return Container(
      padding: AppSpacing.cardLarge,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: AppRadius.xlBorder,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($itemCount items)',
                style: AppTypography.bodyMedium(color: AppColors.white70),
              ),
              Text(
                _currencyFormat.format(subtotal),
                style: AppTypography.bodyMedium(color: AppColors.textWhite),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST (3%)',
                style: AppTypography.bodyMedium(color: AppColors.white70),
              ),
              Text(
                _currencyFormat.format(tax),
                style: AppTypography.bodyMedium(color: AppColors.textWhite),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Express Shipping',
                style: AppTypography.bodyMedium(color: AppColors.white70),
              ),
              Text(
                'FREE',
                style: AppTypography.bodyMedium(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Divider(color: AppColors.white12),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'INCLUSIVE OF ALL TAXES',
              style: AppTypography.labelSmall(
                color: AppColors.white54,
                fontWeight: FontWeight.normal,
                letterSpacing: AppTypography.letterSpacingTight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTypography.headingMedium(fontWeight: FontWeight.w500),
              ),
              Text(
                _currencyFormat.format(total),
                style: AppTypography.headingLarge(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartLoaded cartState, double totalAmount) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (cartState.items.isEmpty) return;

          final order = Order(
            id: const Uuid().v4(),
            items: cartState.items,
            totalAmount: totalAmount,
            status: 'Processing',
            date: DateTime.now(),
          );
          context.read<OrderBloc>().add(PlaceOrder(order));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryWarm,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdBorder,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PLACE ORDER',
              style: AppTypography.bodyMedium(
                color: AppColors.black87,
                fontWeight: FontWeight.w700,
              ).copyWith(letterSpacing: AppTypography.letterSpacingXWide),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(LucideIcons.arrowRight, color: AppColors.black87, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Text(
      'By placing the order, you agree to Sanwariya Imitation\'s\nTerms of Service and Privacy Policy.',
      textAlign: TextAlign.center,
      style: AppTypography.labelMedium(
        color: AppColors.white38,
        letterSpacing: 0,
      ).copyWith(height: 1.5),
    );
  }
}
