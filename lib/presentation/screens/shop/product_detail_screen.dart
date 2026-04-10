import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../../core/constants/colors.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final NumberFormat _currencyFormatter = NumberFormat('#,##0', 'en_IN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Custom App Bar with image overlay
          SliverToBoxAdapter(child: _buildHeroHeader(context)),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF231F17),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '22K GOLD',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFE2C26C),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C26E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'IN STOCK',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF909090),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    widget.product.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${_currencyFormatter.format(widget.product.price)}',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.primary,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '₹${_currencyFormatter.format(widget.product.originalPrice)}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B6B6B),
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'INCLUSIVE OF ALL TAXES',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B6B6B),
                      fontSize: 8,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Accordion 1
                  _buildAccordion(
                    title: 'Artisan Notes',
                    initiallyExpanded: true,
                    content: Text(
                      widget.product.description,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Divider(color: Color(0xFF1E1E1E), height: 1),
                  ),

                  // Accordion 2
                  _buildAccordion(
                    title: 'Technical Details',
                    initiallyExpanded: false,
                    content: const SizedBox(),
                  ),

                  const SizedBox(height: 32),

                  // Feature Cards
                  _buildFeatureCard(
                    icon: LucideIcons.badgeCheck,
                    title: 'Heritage Certified',
                    subtitle:
                        'Each piece comes with an IGI certification for emeralds and BIS hallmarking for gold.',
                  ),

                  const SizedBox(height: 16),

                  _buildFeatureCard(
                    icon: LucideIcons.truck,
                    title: 'Insured Delivery',
                    subtitle:
                        'Complimentary door-to-door insured shipping across India and select international cities.',
                  ),

                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomActions(context),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Stack(
      children: [
        // Main Image Area
        SizedBox(
          width: double.infinity,
          height: 520,
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: 'product_${widget.product.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.surface),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom gradient to blend into background smoothly
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppColors.background],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Paging dots overlay (static design placeholder)
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 24, height: 2, color: AppColors.secondary),
              const SizedBox(width: 6),
              Container(width: 24, height: 2, color: Colors.white24),
              const SizedBox(width: 6),
              Container(width: 24, height: 2, color: Colors.white24),
            ],
          ),
        ),

        // Top Transparent App Bar area
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(
                    context,
                  ), // Typically leads to menu, but pop is suitable for detail back
                ),
                Text(
                  'S A N W A R I Y A\nI M I T A T I O N',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 12,
                    height: 1.3,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool initiallyExpanded,
    required Widget content,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: initiallyExpanded,
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.primary,
        title: Text(
          title,
          style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 18),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 16.0),
        children: [content],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: const Color(0xFF141414), // Darker grey card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF888888),
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0E0D),
        border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Color(0xFF2D2D2D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.heart, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      'WISHLIST',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(
                    AddItemToCart(
                      CartItem(
                        id: DateTime.now().toString(),
                        product: widget.product,
                        quantity: 1,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Acquired to Cart',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.lock, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      'ACQUIRE NOW',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
