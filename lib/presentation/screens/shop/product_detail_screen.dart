import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../widgets/brand_app_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final NumberFormat _currencyFormatter = NumberFormat('#,##0', 'en_IN');
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  Timer? _autoScrollTimer;

  List<String> get _productImages => [
        widget.product.imageUrl,
        'https://images.unsplash.com/photo-1515562141207-7a8ef0f1db55?q=80&w=800',
        'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=800',
      ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextIndex = _currentImageIndex + 1;
        if (nextIndex >= _productImages.length) {
          nextIndex = 0;
        }
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuint,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBadge,
                          borderRadius: AppRadius.xlBorder,
                        ),
                        child: Text(
                          '22K GOLD',
                          style: AppTypography.labelSmall(
                            color: AppColors.primaryLight,
                            letterSpacing: AppTypography.letterSpacingWide,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'IN STOCK',
                            style: AppTypography.labelSmall(
                              color: AppColors.textCaption,
                              letterSpacing: AppTypography.letterSpacingWide,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    widget.product.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${_currencyFormatter.format(widget.product.price)}',
                        style: AppTypography.headingXL(),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '₹${_currencyFormatter.format(widget.product.originalPrice)}',
                          style: AppTypography.bodyMedium(
                            color: AppColors.textDim,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'INCLUSIVE OF ALL TAXES',
                    style: AppTypography.caption(
                      color: AppColors.textDim,
                    ).copyWith(letterSpacing: AppTypography.letterSpacingWide),
                  ),

                  const SizedBox(height: AppSpacing.massive),

                  // Accordion 1
                  _buildAccordion(
                    title: 'Artisan Notes',
                    initiallyExpanded: true,
                    content: Text(
                      widget.product.description,
                      style: AppTypography.labelLarge(
                        color: AppColors.white70,
                      ).copyWith(height: 1.6),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Divider(color: AppColors.divider, height: 1),
                  ),

                  // Accordion 2
                  _buildAccordion(
                    title: 'Technical Details',
                    initiallyExpanded: false,
                    content: const SizedBox(),
                  ),

                  const SizedBox(height: AppSpacing.sectionGap),

                  // Feature Cards
                  _buildFeatureCard(
                    icon: LucideIcons.badgeCheck,
                    title: 'Heritage Certified',
                    subtitle:
                        'Each piece comes with an IGI certification for emeralds and BIS hallmarking for gold.',
                  ),

                  const SizedBox(height: AppSpacing.lg),

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
        SizedBox(
          width: double.infinity,
          height: 520,
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                    // Reset timer on manual scroll
                    _autoScrollTimer?.cancel();
                    _startAutoScroll();
                  },
                  itemCount: _productImages.length,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: index == 0 ? 'product_${widget.product.id}' : 'image_$index',
                      child: CachedNetworkImage(
                        imageUrl: _productImages[index],
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
                    );
                  },
                ),
              ),
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

        // Paging dots overlay
        Positioned(
          bottom: AppSpacing.xxl,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_productImages.length, (index) {
              final isActive = index == _currentImageIndex;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutQuint,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    width: isActive ? 28 : 12,
                    height: 2,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.secondary : AppColors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Top Transparent App Bar area
        const BrandAppBar(isTransparent: true),
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
          style: AppTypography.headingSmall(),
        ),
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.lg),
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
        color: AppColors.surfaceDark,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.bodyLarge(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.labelMedium(
              color: AppColors.textHint,
            ).copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundBottomSheet,
        border: Border(top: BorderSide(color: AppColors.surface)),
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
                  side: BorderSide(color: AppColors.borderMuted),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdBorder,
                  ),
                  foregroundColor: AppColors.textWhite,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.heart, size: 14),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'WISHLIST',
                      style: AppTypography.labelMedium(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: AppTypography.letterSpacingNormal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
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
                    borderRadius: AppRadius.mdBorder,
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.lock, size: 14),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'ACQUIRE NOW',
                      style: AppTypography.labelMedium(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        letterSpacing: AppTypography.letterSpacingNormal,
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
