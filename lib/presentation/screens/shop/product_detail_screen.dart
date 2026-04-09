import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/custom_button.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: CustomButton(
            text: 'ADD TO CART',
            onPressed: () {
              context.read<CartBloc>().add(
                AddItemToCart(CartItem(
                  id: DateTime.now().toString(),
                  product: product,
                  quantity: 1,
                )),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to Cart', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_${product.id}',
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 450,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.category.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, letterSpacing: 2)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 18),
                          const SizedBox(width: 4),
                          Text('${product.rating}', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(product.title, style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('₹${product.price.toStringAsFixed(0)}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primary)),
                      const SizedBox(width: 12),
                      Text('₹${product.originalPrice.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(decoration: TextDecoration.lineThrough, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Artisan Notes', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(product.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                  const SizedBox(height: 32),
                  _buildFeatureRow(Icons.diamond_outlined, 'Heritage Certified', 'Guaranteed authentic materials'),
                  const SizedBox(height: 16),
                  _buildFeatureRow(Icons.local_shipping_outlined, 'Insured Delivery', 'Fully secure to your doorstep'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        )
      ],
    );
  }
}
