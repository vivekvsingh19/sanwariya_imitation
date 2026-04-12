import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import 'product_detail_screen.dart';
import '../../../domain/entities/product.dart';
import '../../widgets/brand_app_bar.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final NumberFormat _currencyFormatter = NumberFormat('#,##0', 'en_IN');

  @override
  void initState() {
    super.initState();
    final productBloc = context.read<ProductBloc>();
    if (productBloc.state is ProductInitial) {
      productBloc.add(const FetchProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProductLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<ProductBloc>().add(const FetchProducts());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BrandAppBar(useSafeArea: false),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.sm,
                              AppSpacing.lg,
                              0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.xxl),
                                Center(
                                  child: Text(
                                    'The Necklaces',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: AppColors.textWhite,
                                          fontSize:
                                              AppTypography.fontSizeDisplayXL,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Center(
                                  child: Text(
                                    'ARTISANAL IMITATION COLLECTION',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          letterSpacing: AppTypography
                                              .letterSpacingXXWide,
                                          fontSize: AppTypography.fontSizeXXS,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg + 2),
                                _buildFilterChips(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 18, AppSpacing.lg, AppSpacing.xxl,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = state.products[index];
                        return _StyledProductTile(
                          product: product,
                          badgeText: _badgeText(product: product, index: index),
                          currencyFormatter: _currencyFormatter,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      }, childCount: state.products.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 22,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.54,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text(
              'Failed to load collection.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }

  String _badgeText({required Product product, required int index}) {
    if (product.originalPrice > product.price) {
      final discount = ((1 - (product.price / product.originalPrice)) * 100)
          .round();
      if (discount >= 10) {
        return '$discount % OFF';
      }
    }
    return index.isEven ? 'LIMITED' : 'NEW';
  }


  Widget _buildFilterChips(BuildContext context) {
    final chipTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AppColors.textWhite,
      fontWeight: FontWeight.w500,
      fontSize: AppTypography.fontSizeXS,
    );

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceGoldAccent,
              borderRadius: AppRadius.xxlBorder,
              border: Border.all(color: AppColors.borderGoldAccent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 6),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text('Sort by', style: chipTextStyle),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _chip(label: 'Price Range', textStyle: chipTextStyle),
          const SizedBox(width: 10),
          _chip(label: 'Purity', textStyle: chipTextStyle),
          const SizedBox(width: 10),
          _chip(label: 'Newest', textStyle: chipTextStyle),
        ],
      ),
    );
  }

  Widget _chip({required String label, required TextStyle? textStyle}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.xxlBorder,
        border: Border.all(color: AppColors.borderMuted),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 6),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(label, style: textStyle),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 15,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _StyledProductTile extends StatelessWidget {
  const _StyledProductTile({
    required this.product,
    required this.badgeText,
    required this.currencyFormatter,
    required this.onTap,
  });

  final Product product;
  final String badgeText;
  final NumberFormat currencyFormatter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lgBorder,
                boxShadow: const [AppShadows.card],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: AppRadius.lgBorder,
                      child: Hero(
                        tag: 'product_${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          fadeInDuration: const Duration(milliseconds: 300),
                          placeholder: (context, url) => Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surface,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.badgeGold,
                        borderRadius: AppRadius.xsBorder,
                      ),
                      child: Text(
                        badgeText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTypography.fontSizeTiny,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontSize: AppTypography.fontSizeXXS,
                  letterSpacing: AppTypography.letterSpacingNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE7E3D9),
              height: 1.2,
              fontSize: AppTypography.fontSizeSM,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                '₹${currencyFormatter.format(product.price)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.fontSizeBase,
                ),
              ),
              if (product.originalPrice > product.price) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '₹${currencyFormatter.format(product.originalPrice)}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textMuted,
                      fontSize: AppTypography.fontSizeXS,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
