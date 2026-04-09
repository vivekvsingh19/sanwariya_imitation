import 'package:flutter/material.dart';
import '../../../../domain/entities/order.dart';
import '../../../core/constants/colors.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER TRACKING'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('The Journey of Your Masterpiece', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('ORDER #${order.id.substring(0, 8).toUpperCase()}', style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 48),
            
            _buildTimelineStep(
              title: 'Order Initiated',
              subtitle: 'Your masterpiece is being verified to your exact requirements.',
              isActive: true,
              isFirst: true,
            ),
            _buildTimelineStep(
              title: 'Artisan Quality Check',
              subtitle: 'Our master craftsmen are meticulously inspecting the piece.',
              isActive: true,
            ),
            _buildTimelineStep(
              title: 'In Transit via Royal Secure',
              subtitle: 'Your possession is on its way through our secured courier network.',
              isActive: order.status == 'Shipped' || order.status == 'Delivered',
            ),
            _buildTimelineStep(
              title: 'Delivered',
              subtitle: 'Safely delivered to you.',
              isActive: order.status == 'Delivered',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isActive,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst) Container(height: 20, width: 2, color: isActive ? AppColors.primary : AppColors.surface),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.primary : AppColors.surface,
                    border: Border.all(color: isActive ? AppColors.primary : AppColors.textMuted),
                  ),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: isActive ? AppColors.primary : AppColors.surface)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.white : AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Text(subtitle, style: TextStyle(color: isActive ? Colors.white70 : AppColors.surface)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
