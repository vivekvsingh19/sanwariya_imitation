import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/colors.dart';
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
  int _paymentMethod = 0; // 0: UPI, 1: Card, 2: Net Banking, 3: COD
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
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primary,
            fontSize: 16,
            letterSpacing: 4.0,
            fontWeight: FontWeight.w600,
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow('Delivery Address', 'CHANGE'),
              const SizedBox(height: 16),
              _buildAddressCard(),
              const SizedBox(height: 32),
              
              _buildHeaderRow('Payment Method', ''),
              const SizedBox(height: 16),
              _buildPaymentOption(0, 'UPI', 'Google Pay, PhonePe, Paytm', Icons.account_balance_wallet_outlined),
              const SizedBox(height: 12),
              _buildPaymentOption(1, 'Credit / Debit Card', 'Visa, Mastercard, RuPay', Icons.credit_card_outlined),
              const SizedBox(height: 12),
              _buildPaymentOption(2, 'Net Banking', 'All major Indian banks', Icons.account_balance_outlined),
              const SizedBox(height: 12),
              _buildPaymentOption(3, 'Cash on Delivery', 'Pay when you receive your order', Icons.payments_outlined),
              
              const SizedBox(height: 32),
              _buildHeaderRow('Order Summary', ''),
              const SizedBox(height: 16),
              
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartLoaded) {
                    final subtotal = cartState.totalAmount;
                    final tax = subtotal * 0.03; // GST 3% for imitation jewelry/gems
                    final total = subtotal + tax;
                    final itemCount = cartState.items.fold(0, (sum, item) => sum + item.quantity);

                    return Column(
                      children: [
                        _buildSummaryCard(subtotal, tax, total, itemCount),
                        const SizedBox(height: 32),
                        _buildPlaceOrderButton(cartState, total),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                },
              ),
              
              const SizedBox(height: 16),
              _buildFooterText(),
              const SizedBox(height: 32),
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
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(LucideIcons.checkCircle, color: AppColors.primary, size: 60),
        content: Text(
          'Your masterpiece is being prepared for delivery.', 
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.white),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                'BACK TO HOME', 
                style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold),
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
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            color: const Color(0xFFD4AF37), // Gold
            fontWeight: FontWeight.w500,
          ),
        ),
        if (action.isNotEmpty)
          Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFFD4AF37).withOpacity(0.6), // Muted gold
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF201F1F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
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
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '102, Emerald Heights, Marine Drive\nNear Oberoi Hotel, Mumbai - 400021\nMaharashtra, India',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(LucideIcons.phone, color: Colors.white70, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      '+91 98765 43210',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.mapPin, color: Colors.white24, size: 28),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF201F1F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
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
                  color: isSelected ? const Color(0xFFF2D368) : Colors.white24,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF201F1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($itemCount items)',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              ),
              Text(
                _currencyFormat.format(subtotal),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST (3%)',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              ),
              Text(
                _currencyFormat.format(tax),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Express Shipping',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              ),
              Text(
                'FREE',
                style: GoogleFonts.inter(color: const Color(0xFFD4AF37), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'INCLUSIVE OF ALL TAXES',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _currencyFormat.format(total),
                style: GoogleFonts.inter(
                  color: const Color(0xFFD4AF37),
                  fontSize: 24,
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
          backgroundColor: const Color(0xFFD4A347), // Solid warm gold
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PLACE ORDER',
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.arrowRight, color: Colors.black87, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Text(
      'By placing the order, you agree to Sanwariya Imitation\'s\nTerms of Service and Privacy Policy.',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        color: Colors.white38,
        fontSize: 10,
        height: 1.5,
      ),
    );
  }
}
