import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../screens/cart/cart_screen.dart';

class BrandAppBar extends StatelessWidget {
  final bool showSearch;
  final bool showMenu;
  final bool showCart;
  final int cartCount;
  final bool isTransparent;
  final bool useSafeArea;
  final Color? backgroundColor;

  const BrandAppBar({
    super.key,
    this.showSearch = true,
    this.showMenu = true,
    this.showCart = true,
    this.cartCount = 0,
    this.isTransparent = true,
    this.useSafeArea = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showMenu)
            const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 24,
            )
          else
            const SizedBox(width: 24),
          Expanded(
            child: Center(
              child: Text(
                'SANWARIYA  IMITATION',
                textAlign: TextAlign.center,
                style: AppTypography.brandTitle(
                  fontSize: AppTypography.fontSizeSM,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showSearch) ...[
                const Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              if (showCart)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      if (cartCount >= 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cartCount.toString(),
                              style: AppTypography.caption(color: Colors.black),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (!showCart && !showSearch) const SizedBox(width: 24),
            ],
          ),
        ],
      ),
    );

    if (useSafeArea) {
      content = SafeArea(bottom: false, child: content);
    }

    return Container(
      color: isTransparent
          ? Colors.transparent
          : (backgroundColor ?? AppColors.backgroundDark),
      child: content,
    );
  }
}
