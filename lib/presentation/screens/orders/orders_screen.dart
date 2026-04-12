import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/brand_app_bar.dart';

import '../../../core/theme/app_theme.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/product.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  List<Order> get _mockOrders => [
        Order(
          id: 'SR-9928410',
          status: 'Processing',
          totalAmount: 145000,
          date: DateTime(2023, 10, 12),
          items: [
            CartItem(
              id: '1',
              product: Product(
                id: 'p1',
                title: 'The Maharani Choker',
                description: 'Handcrafted in 22kt Gold Finish',
                price: 145000,
                originalPrice: 165000,
                imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb6664536694?q=80&w=800',
                category: 'Necklace',
                rating: 4.8,
              ),
              quantity: 1,
            ),
          ],
        ),
        Order(
          id: 'SR-10255-XX',
          status: 'Shipped',
          totalAmount: 24900,
          date: DateTime(2023, 10, 18),
          items: [
            CartItem(
              id: '2',
              product: Product(
                id: 'p2',
                title: 'Noorani Kundan Bangles',
                description: 'Set of 4 traditional bridal bangles featuring high-quality imitation kundan stones and red meenakari work.',
                price: 24900,
                originalPrice: 29900,
                imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=800',
                category: 'Bangles',
                rating: 4.5,
              ),
              quantity: 1,
            ),
          ],
        ),
      ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<OrderBloc>().add(LoadOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: BrandAppBar(
          useSafeArea: false,
          showSearch: false,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Text(
              'My Orders',
              style: AppTypography.displayXL(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              'EXCLUSIVE HISTORY',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    letterSpacing: AppTypography.letterSpacingXXWide,
                    fontSize: AppTypography.fontSizeXXS,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg + 2),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.white54,
            labelStyle: AppTypography.bodySmall(
              fontWeight: FontWeight.w600,
              letterSpacing: AppTypography.letterSpacingWide,
            ),
            unselectedLabelStyle: AppTypography.bodySmall(
              fontWeight: FontWeight.w500,
              letterSpacing: AppTypography.letterSpacingWide,
            ),
            tabs: const [
              Tab(text: 'CURRENT ORDERS'),
              Tab(text: 'ARCHIVE'),
              Tab(text: 'WISHLIST'),
            ],
          ),

          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is OrderLoaded) {
                  final currentOrders = state.orders.isEmpty
                      ? _mockOrders
                      : state.orders.reversed.toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrdersList(currentOrders),
                      _buildEmptyState(message: 'No archived orders.'),
                      _buildEmptyState(message: 'Your wishlist is empty.'),
                    ],
                  );
                }
                return const Center(
                  child: Text(
                    'Failed to load orders.',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    String message = 'No orders currently in progress.',
  }) {
    return Center(
      child: Text(
        message,
        style: AppTypography.headingSmall(color: AppColors.white54),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.screenPaddingV,
        AppSpacing.screenPaddingH,
        AppSpacing.massive,
      ),
      itemCount: orders.length + 1,
      separatorBuilder: (_, index) => SizedBox(
        height: index == orders.length - 1 ? AppSpacing.giant : AppSpacing.xxl,
      ),
      itemBuilder: (context, index) {
        if (index == orders.length) {
          return Center(
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'CURATING EXCELLENCE SINCE 1992',
                style: AppTypography.labelMedium(
                  color: AppColors.white12,
                  letterSpacing: AppTypography.letterSpacingXXWide,
                ),
              ),
            ),
          );
        }

        final order = orders[index];
        if (order.items.isEmpty) return const SizedBox.shrink();

        final mainItem = order.items.first;
        final product = mainItem.product;

        String visualStatus = order.status.toUpperCase();
        if (visualStatus == 'PROCESSING') visualStatus = 'IN PRODUCTION';

        return _buildOrderCard(order, product, visualStatus);
      },
    );
  }

  Widget _buildOrderCard(Order order, Product product, String status) {
    final isDelivered = status == 'DELIVERED';
    final isShipped = status == 'SHIPPED';
    final isInProduction = status == 'IN PRODUCTION';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.xlBorder,
      ),
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Hero section with Order ID Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadius.lgBorder,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.black26),
                    errorWidget: (context, url, _) =>
                        Container(color: AppColors.black26),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: AppRadius.xsBorder,
                  ),
                  child: Text(
                    '#${order.id.substring(0, 8).toUpperCase()}',
                    style: AppTypography.labelMedium(
                      color: AppColors.primary,
                      letterSpacing: AppTypography.letterSpacingNormal,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Title & Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: AppTypography.headingMedium(),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Text(
                _currencyFormat.format(order.totalAmount),
                style: AppTypography.headingSmall(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Description
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall(
              color: AppColors.white54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Status and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    color: AppColors.white54,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, yyyy').format(order.date).toUpperCase(),
                    style: AppTypography.labelMedium(
                      color: AppColors.white54,
                      letterSpacing: AppTypography.letterSpacingNormal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isDelivered
                        ? LucideIcons.checkCircle2
                        : (isShipped
                            ? LucideIcons.truck
                            : LucideIcons.settings),
                    color: isDelivered
                        ? AppColors.white54
                        : AppColors.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: AppTypography.labelMedium(
                      color: isDelivered
                          ? AppColors.white54
                          : AppColors.primary,
                      letterSpacing: AppTypography.letterSpacingNormal,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Action Buttons
          _buildActionButtons(order, isInProduction, isShipped, isDelivered),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    Order order,
    bool isInProduction,
    bool isShipped,
    bool isDelivered,
  ) {
    if (isDelivered) {
      return Row(
        children: [
          _buildTextButton('VIEW RECEIPT', () {}),
          const SizedBox(width: AppSpacing.xxl),
          _buildTextButton('WRITE REVIEW', () {}),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _navigateToTracking(order),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryWarm,
          side: BorderSide(color: AppColors.primaryWarm),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.smBorder,
          ),
        ),
        child: _buildTrackJourneyContent(false),
      ),
    );
  }

  Widget _buildTrackJourneyContent(bool isSolid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TRACK JOURNEY',
          style: AppTypography.labelLarge(
            color: isSolid ? AppColors.black87 : AppColors.primaryWarm,
            fontWeight: FontWeight.bold,
            letterSpacing: AppTypography.letterSpacingWide,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(
          LucideIcons.map,
          color: isSolid ? AppColors.black87 : AppColors.primaryWarm,
          size: 14,
        ),
      ],
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppTypography.labelMedium(
              color: AppColors.primaryWarm,
              letterSpacing: AppTypography.letterSpacingNormal,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            height: 1,
            width: text.length * 5.0,
            color: AppColors.primaryWarm.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  void _navigateToTracking(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
    );
  }
}
