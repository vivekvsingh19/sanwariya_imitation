import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/product/product_event.dart';
import '../../../domain/entities/product.dart';
import '../shop/product_detail_screen.dart';
import '../offers/offers_screen.dart';
import '../../widgets/brand_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NumberFormat _currencyFormatter = NumberFormat('#,##0', 'en_IN');
  final PageController _pageController = PageController();
  int _currentHeroIndex = 0;
  Timer? _heroTimer;

  final List<Map<String, String>> _heroBanners = [
    {
      'image':
          'https://images.unsplash.com/photo-1695049918857-1e27d67782e5?q=80&w=686&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'subtitle': 'NEW ARRIVAL',
      'title': 'The Wedding\nEdit',
      'description':
          'Experience the timeless elegance of\nRajasthan\'s artisanal, handcrafted for\nthe Indian bride.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1651160670627-2896ddf7822f?q=80&w=1968&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'subtitle': 'LIMITED EDITION',
      'title': 'Royal\nHeritage',
      'description':
          'Discover the ancient beauty of\nKundan and Polki, restored for\nthe modern queen.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600&auto=format&fit=crop',
      'subtitle': 'MASTERPIECE',
      'title': 'Temple\nCollection',
      'description':
          'Divine inspirations crafted in gold.\nEmbrace the spiritual aura of\nour exquisite temple jewelry.',
    },
  ];

  final List<Map<String, String>> _categories = [
    {
      'label': 'BANGLES',
      'image': 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=400&auto=format&fit=crop',
    },
    {
      'label': 'EARRINGS',
      'image': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=400&auto=format&fit=crop',
    },
    {
      'label': 'PENDANTS',
      'image': 'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=400&auto=format&fit=crop',
    },
    {
      'label': 'CHAINS',
      'image': 'https://images.unsplash.com/photo-1515562141207-7a8ef0f1db55?q=80&w=400&auto=format&fit=crop',
    },
    {
      'label': 'NECKLACES',
      'image': 'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=400&auto=format&fit=crop',
    },
    {
      'label': 'RINGS',
      'image': 'https://images.unsplash.com/photo-1605100804763-247f67b254a4?q=80&w=400&auto=format&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    final productBloc = context.read<ProductBloc>();
    if (productBloc.state is ProductInitial) {
      productBloc.add(const FetchProducts());
    }

    _heroTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextIndex = _currentHeroIndex + 1;
        if (nextIndex >= _heroBanners.length) {
          nextIndex = 0;
        }
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(context),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _buildFeaturedSection(context, state.featuredProducts),
                    const SizedBox(height: AppSpacing.massive),
                    _buildBrowseCollection(context),
                    const SizedBox(height: AppSpacing.massive),
                    _buildLimitedEditionCard(context),
                    const SizedBox(height: AppSpacing.huge),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Failed to load products.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Adaptive height based on screen size and orientation
    final heroHeight = screenWidth > 800 ? screenHeight * 0.8 : 600.0;

    return Stack(
      children: [
        SizedBox(
          height: heroHeight.clamp(500.0, 900.0),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentHeroIndex = index;
              });
            },
            itemCount: _heroBanners.length,
            itemBuilder: (context, index) {
              final banner = _heroBanners[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(banner['image']!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.8),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: AppSpacing.xxl,
                    right: AppSpacing.xxl,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          banner['subtitle']!,
                          style: AppTypography.labelMedium(
                            color: AppColors.primary,
                            letterSpacing: AppTypography.letterSpacingXXWide,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          banner['title']!,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayHero(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          banner['description']!,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall(
                            color: AppColors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryWarm,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.xsBorder,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'EXPLORE COLLECTION',
                              style: AppTypography.bodySmall(
                                fontWeight: FontWeight.bold,
                                letterSpacing: AppTypography.letterSpacingWide,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _heroBanners.length,
              (index) => _buildDot(index == _currentHeroIndex),
            ),
          ),
        ),
        // Top App Bar Elements
        const BrandAppBar(isTransparent: true),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      width: isActive ? 24 : 8,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.white24,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    );
  }

  Widget _buildFeaturedSection(
    BuildContext context,
    List<Product> featuredProducts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Featured\nMasterpieces',
                style: AppTypography.displaySmall(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OffersScreen()),
                  );
                },
                child: Text(
                  'VIEW\nALL >',
                  textAlign: TextAlign.right,
                  style: AppTypography.labelSmall(
                    color: AppColors.primaryMuted,
                    letterSpacing: AppTypography.letterSpacingNormal,
                  ).copyWith(height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: AppSpacing.screenH,
          child: Container(width: 40, height: 1, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        SizedBox(
          height: 300,
          child: ListView.separated(
            padding: AppSpacing.screenH,
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.lg),
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return SizedBox(
                width: 180,
                child: _FeaturedProductCard(
                  product: product,
                  currencyFormatter: _currencyFormatter,
                  badgeText: index % 2 == 0 ? '20% OFF' : 'NEW',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrowseCollection(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Browse the Collection',
            textAlign: TextAlign.center,
            style: AppTypography.displaySmall(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Explore our curated selections by jewellery\ntype',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(color: AppColors.white70),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Categories Grid
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _CategoryCard(
                    label: category['label']!,
                    imageUrl: category['image']!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitedEditionCard(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: AppSpacing.screenH,
          child: Container(
            padding: AppSpacing.cardLarge,
            decoration: BoxDecoration(
              borderRadius: AppRadius.lgBorder,
              gradient: LinearGradient(
                colors: [AppColors.surfaceGoldDark, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.borderGold),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1599643478524-fb66f70d00f7?q=80&w=600&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 10),
                    const SizedBox(width: 6),
                    Text(
                      'LIMITED EDITION',
                      style: AppTypography.labelMedium(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: AppTypography.letterSpacingXWide,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: AppColors.primary, size: 10),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Royal\nTreasures &',
                  style: AppTypography.display(),
                ),
                Text(
                  'Exclusive Offers',
                  style: AppTypography.display(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Unlock access to our premium\nevents and limited discount\npieces as an exclusive patron.\nElevate your lifestyle.',
                  style: AppTypography.labelLarge(
                    color: AppColors.white70,
                  ).copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.xxl),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OffersScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.xsBorder,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'VIEW ALL OFFERS',
                        style: AppTypography.labelMedium(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: AppTypography.letterSpacingWide,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.arrow_forward_ios, size: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final String imageUrl;

  const _CategoryCard({
    required this.label,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdBorder,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.bodySmall(
          fontWeight: FontWeight.bold,
          letterSpacing: AppTypography.letterSpacingXWide,
        ),
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  final Product product;
  final NumberFormat currencyFormatter;
  final String badgeText;
  final VoidCallback onTap;

  const _FeaturedProductCard({
    required this.product,
    required this.currencyFormatter,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppRadius.mdBorder,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.9,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: AppRadius.topMd,
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWarm,
                        borderRadius: AppRadius.lgBorder,
                      ),
                      child: Text(
                        badgeText,
                        style: AppTypography.caption(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall(
                      color: AppColors.white70,
                      letterSpacing: AppTypography.letterSpacingNormal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${currencyFormatter.format(product.price)}',
                        style: AppTypography.bodyMedium(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '₹${currencyFormatter.format(product.originalPrice)}',
                        style: AppTypography.labelMedium(
                          color: AppColors.white30,
                        ).copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
