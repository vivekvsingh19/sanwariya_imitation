import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../../core/constants/colors.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

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
      backgroundColor: Colors.black, // Dark luxury background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'EXCLUSIVE HISTORY',
              style: GoogleFonts.inter(
                color: const Color(0xFFD4AF37), // Gold
                fontSize: 10,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'My Orders',
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 1,
              color: const Color(0xFFD4AF37).withOpacity(0.5), // Tiny gold divider
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Custom TabBar
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFD4AF37),
            indicatorWeight: 2,
            labelColor: const Color(0xFFD4AF37),
            unselectedLabelColor: Colors.white54,
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
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
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                } else if (state is OrderLoaded) {
                  if (state.orders.isEmpty) {
                    return _buildEmptyState();
                  }

                  // To match design we'll reverse orders to show newest first
                  final currentOrders = state.orders.reversed.toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Current Orders Tab
                      _buildOrdersList(currentOrders),
                      
                      // Archive Tab (Empty for now)
                      _buildEmptyState(message: 'No archived orders.'),
                      
                      // Wishlist Tab (Empty for now)
                      _buildEmptyState(message: 'Your wishlist is empty.'),
                    ],
                  );
                }
                return const Center(child: Text('Failed to load orders.', style: TextStyle(color: Colors.white)));
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'CURATING EXCELLENCE SINCE 1992',
              style: GoogleFonts.inter(
                color: Colors.white24,
                letterSpacing: 2.0,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String message = 'No orders currently in progress.'}) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.playfairDisplay(color: Colors.white54, fontSize: 18),
      ),
    );
  }

  Widget _buildOrdersList(List<dynamic> orders) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        // If order has no items, we won't show it (safety check)
        final order = orders[index];
        if (order.items.isEmpty) return const SizedBox.shrink();
        
        // Display the first item in the order as the representative "Product"
        final mainItem = order.items.first;
        final product = mainItem.product;

        // Custom status map from typical states to visually distinct ones based on ID/index for mock purposes
        // Since we don't have direct access to "shipped" vs "in production", we mock visual states.
        String visualStatus = order.status.toUpperCase();
        if (visualStatus == 'PROCESSING') visualStatus = 'IN PRODUCTION';

        return _buildOrderCard(order, product, visualStatus);
      },
    );
  }

  Widget _buildOrderCard(dynamic order, dynamic product, String status) {
    // Determine card specific styles based on status
    final isDelivered = status == 'DELIVERED';
    final isShipped = status == 'SHIPPED';
    final isInProduction = status == 'IN PRODUCTION';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark rounded card
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Hero section with Order ID Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.black26),
                    errorWidget: (context, url, _) => Container(color: Colors.black26),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#${order.id.substring(0, 8).toUpperCase()}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD4AF37),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Title & Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _currencyFormat.format(order.totalAmount),
                style: GoogleFonts.inter(
                  color: const Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            product.description ?? 'Beautiful handcrafted jewelry piece featuring exquisite design and premium stones.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Status and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.calendar, color: Colors.white54, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM dd, yyyy').format(order.date).toUpperCase(),
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isDelivered ? LucideIcons.checkCircle2 : (isShipped ? LucideIcons.truck : LucideIcons.settings),
                    color: isDelivered ? Colors.white54 : const Color(0xFFD4AF37),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      color: isDelivered ? Colors.white54 : const Color(0xFFD4AF37),
                      fontSize: 10,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          _buildActionButtons(order, isInProduction, isShipped, isDelivered),
        ],
      ),
    );
  }

  Widget _buildActionButtons(dynamic order, bool isInProduction, bool isShipped, bool isDelivered) {
    if (isDelivered) {
      return Row(
        children: [
          _buildTextButton('VIEW RECEIPT', () {}),
          const SizedBox(width: 24),
          _buildTextButton('WRITE REVIEW', () {}),
        ],
      );
    }
    
    // For Production or Shipped
    return SizedBox(
      width: isInProduction ? null : double.infinity,
      child: isInProduction 
        ? ElevatedButton(
            onPressed: () => _navigateToTracking(order),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A347), // Solid warm gold
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: _buildTrackJourneyContent(true),
          )
        : OutlinedButton(
            onPressed: () => _navigateToTracking(order),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD4A347),
              side: const BorderSide(color: Color(0xFFD4A347)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
          style: GoogleFonts.inter(
            color: isSolid ? Colors.black87 : const Color(0xFFD4A347),
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          LucideIcons.map, // Representing journey/map
          color: isSolid ? Colors.black87 : const Color(0xFFD4A347),
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
            style: GoogleFonts.inter(
              color: const Color(0xFFD4A347),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 1,
            width: text.length * 5.0, // rough underline size based on text
            color: const Color(0xFFD4A347).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  void _navigateToTracking(dynamic order) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
    );
  }
}
