import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../../core/constants/colors.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  final TextEditingController _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text('SANWARIYA', style: GoogleFonts.cinzel(color: AppColors.primary, fontSize: 16, letterSpacing: 4)),
            Text('IMITATION', style: GoogleFonts.cinzel(color: AppColors.primary, fontSize: 16, letterSpacing: 4)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.shoppingBag, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Your selection is empty.',
                      style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              );
            }

            final subtotal = state.totalAmount;
            final tax = subtotal * 0.18; // 18% GST
            final total = subtotal + tax;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Text(
                      'Your Private Selection',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: _buildCartItem(context, item),
                      );
                    },
                    childCount: state.items.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildPromoCodeSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildSummarySection(subtotal, tax, total),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            );
          }
          return const Center(child: Text('Error loading cart', style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.surface),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surface,
                child: const Icon(Icons.image_not_supported, color: Colors.white54),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Title & Remove
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.product.title,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x, color: AppColors.textMuted, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              onPressed: () {
                context.read<CartBloc>().add(RemoveItemFromCart(item.id));
              },
            ),
          ],
        ),
        // Subtitle
        Text(
          '${item.product.category.toUpperCase()} • LUXURY EDITION', // Mock subtitle
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        // Quantity & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuantityPill(context, item),
            Text(
              _currencyFormat.format(item.product.price),
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityPill(BuildContext context, dynamic item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151515), // Deep dark, slightly distinct from black
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(UpdateCartItemQuantity(item.id, item.quantity - 1));
              }
            },
            child: const Icon(LucideIcons.minus, color: AppColors.textMuted, size: 16),
          ),
          const SizedBox(width: 24),
          Text(
            item.quantity.toString().padLeft(2, '0'),
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () {
              context.read<CartBloc>().add(UpdateCartItemQuantity(item.id, item.quantity + 1));
            },
            child: const Icon(LucideIcons.plus, color: AppColors.textMuted, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IMITATION PRIVILEGE CODE',
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _promoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'ENTER CODE',
              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14, letterSpacing: 1.0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(
              'APPLY',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                letterSpacing: 2.0,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(double subtotal, double tax, double total) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acquisition Summary',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 32),
          _buildSummaryRow('SUBTOTAL', _currencyFormat.format(subtotal)),
          const SizedBox(height: 20),
          _buildSummaryRow('TAX (GST)', _currencyFormat.format(tax)),
          const SizedBox(height: 20),
          _buildSummaryRow('INSURED SHIPPING', 'COMPLIMENTARY', valueColor: AppColors.primary),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Investment',
                style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 20),
              ),
              Text(
                _currencyFormat.format(total),
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROCEED TO CHECKOUT',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.chevronRight, color: Colors.black, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'WHITE-GLOVE DELIVERY AVAILABLE. 14-DAY HERITAGE APPRAISAL WINDOW APPLIES TO ALL COLLECTIONS.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 0.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.shieldCheck, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SECURE CURATION',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ENCRYPTED TRANSACTION & HALLMARK GUARANTEED',
                      style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color valueColor = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12, letterSpacing: 1.0),
        ),
        Text(
          value,
          style: GoogleFonts.inter(color: valueColor, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
