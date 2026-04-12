import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';
import '../../core/theme/app_theme.dart';

/// A premium vertical product card used for displaying jewelry items in grids.
///
/// Features include:
/// - Aspect ratio optimized for jewelry photography (0.8)
/// - Custom badge support (e.g., 'SALE', 'NEW')
/// - 'In Stock' status indicator
/// - Wishlist favorite button
/// - Professional currency formatting
class VerticalProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final String? badgeText;

  const VerticalProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'en_IN');

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
                  if (badgeText != null)
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
                          badgeText!,
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
