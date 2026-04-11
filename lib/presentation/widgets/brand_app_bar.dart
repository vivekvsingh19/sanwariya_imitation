import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../screens/cart/cart_screen.dart';

class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showSearch;
  final bool showMenu;
  final bool showCart;
  final bool showBackButton;
  final int cartCount;
  final bool isTransparent;
  final bool useSafeArea;
  final Color? backgroundColor;

  const BrandAppBar({
    super.key,
    this.title,
    this.showSearch = true,
    this.showMenu = true,
    this.showCart = true,
    this.showBackButton = false,
    this.cartCount = 0,
    this.isTransparent = true,
    this.useSafeArea = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

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
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.primary, size: 20),
              onPressed: () => Navigator.pop(context),
            )
          else if (showMenu)
            const Icon(
              Icons.menu,
              color: AppColors.primary,
              size: 24,
            ),
          Expanded(
            child: Center(
              child: Text(
                title ?? 'SANWARIYA  IMITATION',
                textAlign: TextAlign.center,
                style: title != null
                    ? AppTypography.headingMedium(color: AppColors.primary)
                    : AppTypography.brandTitle(
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
