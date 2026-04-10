import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
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
            Text('SANWARIYA', style: AppTypography.brandTitle()),
            Text('IMITATION', style: AppTypography.brandSubtitle()),
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
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Your selection is empty.',
                      style: AppTypography.headingLarge(),
                    ),
                  ],
                ),
              );
            }

            final subtotal = state.totalAmount;
            final tax = subtotal * 0.18;
            final total = subtotal + tax;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPaddingH,
                      vertical: AppSpacing.xxl,
                    ),
                    child: Text(
                      'Your Private Selection',
                      style: AppTypography.display(),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPaddingH,
                          vertical: AppSpacing.lg,
                        ),
                        child: _buildCartItem(context, item),
                      );
                    },
                    childCount: state.items.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.cardLarge,
                    child: _buildPromoCodeSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSpacing.cardLarge,
                    child: _buildSummarySection(subtotal, tax, total),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.massive)),
              ],
            );
          }
          return const Center(
            child: Text('Error loading cart', style: TextStyle(color: AppColors.textWhite)),
          );
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
          borderRadius: AppRadius.xlBorder,
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.surface),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surface,
                child: Icon(Icons.image_not_supported, color: AppColors.white54),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Title & Remove
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.product.title,
                style: AppTypography.headingLarge(),
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
          '${item.product.category.toUpperCase()} • LUXURY EDITION',
          style: AppTypography.labelMedium(
            letterSpacing: AppTypography.letterSpacingWide,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        // Quantity & Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuantityPill(context, item),
            Text(
              _currencyFormat.format(item.product.price),
              style: AppTypography.headingMedium(
                color: AppColors.primary,
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
        color: AppColors.surfaceDeep,
        borderRadius: AppRadius.mdBorder,
        border: Border.all(color: AppColors.white10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
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
          const SizedBox(width: AppSpacing.xxl),
          Text(
            item.quantity.toString().padLeft(2, '0'),
            style: AppTypography.bodyLarge(),
          ),
          const SizedBox(width: AppSpacing.xxl),
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
          style: AppTypography.labelMedium(
            letterSpacing: AppTypography.letterSpacingWide,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.white12),
            borderRadius: AppRadius.xsBorder,
          ),
          child: TextField(
            controller: _promoController,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: InputDecoration(
              hintText: 'ENTER CODE',
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: AppTypography.fontSizeSM,
                letterSpacing: AppTypography.letterSpacingNormal,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.xsBorder),
            ),
            child: Text(
              'APPLY',
              style: AppTypography.bodySmall(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: AppTypography.letterSpacingXWide,
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
        color: AppColors.surfaceDeep,
        borderRadius: AppRadius.xlBorder,
      ),
      padding: AppSpacing.cardLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acquisition Summary',
            style: AppTypography.headingLarge(),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildSummaryRow('SUBTOTAL', _currencyFormat.format(subtotal)),
          const SizedBox(height: AppSpacing.xl),
          _buildSummaryRow('TAX (GST)', _currencyFormat.format(tax)),
          const SizedBox(height: AppSpacing.xl),
          _buildSummaryRow('INSURED SHIPPING', 'COMPLIMENTARY', valueColor: AppColors.primary),
          const SizedBox(height: AppSpacing.xxl),
          Divider(color: AppColors.white10),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Investment',
                style: AppTypography.headingMedium(fontWeight: FontWeight.normal),
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
          const SizedBox(height: AppSpacing.sectionGap),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PROCEED TO CHECKOUT',
                    style: AppTypography.bodyMedium(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ).copyWith(letterSpacing: AppTypography.letterSpacingNormal),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(LucideIcons.chevronRight, color: Colors.black, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'WHITE-GLOVE DELIVERY AVAILABLE. 14-DAY HERITAGE APPRAISAL WINDOW APPLIES TO ALL COLLECTIONS.',
            textAlign: TextAlign.center,
            style: AppTypography.labelSmall(
              color: AppColors.textMuted,
              fontWeight: FontWeight.normal,
              letterSpacing: AppTypography.letterSpacingTight,
            ).copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.shieldCheck, color: AppColors.primary, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SECURE CURATION',
                      style: AppTypography.labelMedium(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'ENCRYPTED TRANSACTION & HALLMARK GUARANTEED',
                      style: AppTypography.labelSmall(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0,
                      ),
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

  Widget _buildSummaryRow(String label, String value, {Color valueColor = AppColors.textWhite}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall(
            color: AppColors.textMuted,
            letterSpacing: AppTypography.letterSpacingNormal,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium(
            color: valueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
