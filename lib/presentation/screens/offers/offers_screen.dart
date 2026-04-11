import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/brand_app_bar.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(
        title: 'Exclusive Privileges',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _OffersHeader(),
            const SizedBox(height: 24),
            _buildOfferCards(context),
            const SizedBox(height: 40),
            const _FooterInfoSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _OfferCard(
            imageUrl:
                'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=1000&auto=format&fit=crop',
            badge: 'LIMITED ORDERS',
            title: '15% OFF\nIMITATION\nWELCOME',
            details: const [
              _OfferDetail(
                icon: LucideIcons.checkCircle2,
                label: 'VALID CATEGORIES',
                value: 'Heritage Bridal & Polki Collection',
              ),
              _OfferDetail(
                icon: LucideIcons.banknote,
                label: 'MINIMUM PURCHASE',
                value: '₹15,000 and above',
              ),
              _OfferDetail(
                icon: LucideIcons.clock,
                label: 'EXPIRY',
                value: 'Valid until October 31, 2025',
              ),
            ],
            buttonLabel: 'SHOP NOW',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          _OfferCard(
            title: '₹5,000 SAVINGS',
            subtitle: 'On handcrafted Kundan sets over ₹25,000',
            badge: 'THE RAJPUTANA SERIES',
            isCompact: true,
            icon: LucideIcons.trophy,
            tag: 'RAJPUTANA5K',
            footerText: 'EXPIRES IN 12 DAYS',
            buttonLabel: 'SHOP NOW',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          _OfferCard(
            title: 'FREE Jhumka Pair',
            subtitle:
                'With any purchase from the "Modern Rani" bridal collection',
            badge: 'COMPLIMENTARY CURATION',
            isCompact: true,
            icon: LucideIcons.sparkles,
            tag: 'RARE GIFT',
            footerText: 'EXCLUSIVE TO MEMBERSHIP',
            buttonLabel: 'SHOP NOW',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          _OfferCard(
            imageUrl:
                'https://images.unsplash.com/photo-1547996160-81dfa63595dd?q=80&w=1000&auto=format&fit=crop',
            badge: 'FIRST ACQUISITION',
            title: '10% OFF YOUR\nFIRST CURATION',
            description:
                'Start your journey with Sanwariya Imitation. Apply this privilege at any full-price handcrafted piece from our permanent collection.',
            tag: 'JOURNEY10',
            buttonLabel: 'ACTIVATE PRIVILEGE',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _OffersHeader extends StatelessWidget {
  const _OffersHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        children: [
          Text(
            'SANWARIYA IMITATION',
            style: AppTypography.brandSubtitle(
              fontSize: 12,
              letterSpacing: 4.0,
              color: AppColors.primaryMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exclusive Privileges',
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium(color: AppColors.primary)
                .copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to the inner circle of Sanwariya Imitation. Explore curated acquisition benefits reserved solely for our distinguished patrons.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String? imageUrl;
  final String badge;
  final String title;
  final String? subtitle;
  final String? description;
  final List<_OfferDetail>? details;
  final String? tag;
  final String? footerText;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool isCompact;
  final IconData? icon;

  const _OfferCard({
    this.imageUrl,
    required this.badge,
    required this.title,
    this.subtitle,
    this.description,
    this.details,
    this.tag,
    this.footerText,
    required this.buttonLabel,
    required this.onPressed,
    this.isCompact = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceDark.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderGold.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: AppColors.surfaceHighlight,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: AppColors.surfaceHighlight,
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.primary,
                ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBadge,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryMuted,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        badge,
                        style: AppTypography.labelSmall(
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    if (icon != null)
                      Icon(icon, color: AppColors.primaryMuted, size: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: AppTypography.displaySmall(
                    color: AppColors.textWhite,
                  ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMedium(color: AppColors.textMuted),
                  ),
                ],
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    description!,
                    style: AppTypography.bodySmall(
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
                if (details != null) ...[
                  const SizedBox(height: 20),
                  ...details!.map(
                    (detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: detail,
                    ),
                  ),
                ],
                if (tag != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.white12),
                    ),
                    child: Center(
                      child: Text(
                        tag!,
                        style: AppTypography.labelLarge(
                          color: AppColors.primaryLight,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: AppTypography.labelLarge(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                if (footerText != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        footerText!,
                        style: AppTypography.labelSmall(
                          color: AppColors.textSubtle,
                        ),
                      ),
                      TextButton(
                        onPressed: onPressed,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'SHOP NOW',
                          style: AppTypography.labelSmall(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OfferDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall(
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodySmall(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterInfoSection extends StatelessWidget {
  const _FooterInfoSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
            'Taxes & Fees',
            'VAT may apply to products depending on shipping destination, calculated based on the full value of each item. Cannot be combined with active festive offers.',
          ),
          const SizedBox(height: 24),
          _buildInfoItem(
            'Shipping & Delivery',
            'All Sanwariya Pieces always include complimentary insured shipping, special jewelry boxes will make your gift even more memorable.',
          ),
          const SizedBox(height: 24),
          _buildInfoItem(
            'Return Policy',
            'Items acquired through our exclusive curation are eligible for exchange within 7 days, provided the seal remains intact on the jewelry box.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headingSmall(color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTypography.bodySmall(
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
