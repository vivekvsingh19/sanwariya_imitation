import 'package:flutter/material.dart';
import '../../widgets/product_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        return ProductCard(
                          product: product,
                          badgeText: _badgeText(product: product, index: index),
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
