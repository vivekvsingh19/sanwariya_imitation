import 'package:flutter/material.dart';
import '../../../../domain/entities/order.dart';
import '../../../core/theme/app_theme.dart';

enum StepStatus { done, current, pending }

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    int currentIndex = _getCurrentIndex();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'The Journey of Your\nMasterpiece',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'ORDER ID: #${order.id.substring(0, 8).toUpperCase()}',
                style: TextStyle(
                  color: AppColors.textSubtle,
                  fontSize: AppTypography.fontSizeXS,
                  letterSpacing: AppTypography.letterSpacingWide,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // Product Card
              Container(
                padding: AppSpacing.card,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.lgBorder,
                  border: Border.all(color: AppColors.textWhite.withOpacity(0.05)),
                  boxShadow: [AppShadows.elevated],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Product Image
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAccent,
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.mdBorder,
                        child: order.items.isNotEmpty
                            ? Image.network(
                                order.items.first.product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    const SizedBox(),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT\nACQUISITION',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: AppTypography.fontSizeMicro,
                              fontWeight: FontWeight.bold,
                              letterSpacing: AppTypography.letterSpacingXWide,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  order.items.isNotEmpty
                                      ? order.items.first.product.title
                                      : 'Unknown Product',
                                  style: TextStyle(
                                    color: AppColors.textWhite,
                                    fontSize: AppTypography.fontSizeBase,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '₹${order.totalAmount.toInt()}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: AppTypography.fontSizeSM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Handcrafted in 22kt Gold Finish',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: AppTypography.fontSizeXXS,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.massive),

              // Timeline
              _buildTimeline(currentIndex),

              const SizedBox(height: AppSpacing.huge),

              // Bottom Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdBorder,
                    ),
                    elevation: 10,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: Text(
                    'SUPPORT & HELP',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: AppTypography.letterSpacingWide,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex() {
    switch (order.status.toLowerCase()) {
      case 'processing':
        return 2;
      case 'shipped':
        return 3;
      case 'delivered':
        return 4;
      default:
        return 2;
    }
  }

  Widget _buildTimeline(int currentIndex) {
    final stages = [
      {
        'title': 'Creation Initiated',
        'subtitle':
            'The artisans have begun crafting your unique piece in our Jaipur atelier.',
        'date': 'OCT 12, 10:30 AM',
      },
      {
        'title': 'Heritage Certification',
        'subtitle':
            'Authenticity documents and hallmark certification processed.',
        'date': 'OCT 14, 02:15 PM',
      },
      {
        'title': 'Artisan Quality Check',
        'subtitle':
            'Final inspection under the loupe to ensure every gemstone is perfectly seated.',
      },
      {
        'title': 'In Transit via Royal Courier',
        'subtitle':
            'Your treasure will be dispatched in our signature velvet-lined vault packaging.',
      },
      {
        'title': 'Delivered',
        'subtitle':
            'Final presentation at your doorstep with secure verification.',
      },
    ];

    return Column(
      children: List.generate(stages.length, (index) {
        final isLast = index == stages.length - 1;
        StepStatus status;
        if (index < currentIndex) {
          status = StepStatus.done;
        } else if (index == currentIndex) {
          status = StepStatus.current;
        } else {
          status = StepStatus.pending;
        }

        return _buildTimelineStep(
          title: stages[index]['title']!,
          subtitle: stages[index]['subtitle']!,
          date: stages[index]['date'],
          status: status,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    String? date,
    required StepStatus status,
    required bool isLast,
  }) {
    Color titleColor;
    Color subtitleColor;

    switch (status) {
      case StepStatus.done:
        titleColor = AppColors.primary.withOpacity(0.9);
        subtitleColor = AppColors.primary.withOpacity(0.4);
        break;
      case StepStatus.current:
        titleColor = AppColors.textWhite;
        subtitleColor = AppColors.white70;
        break;
      case StepStatus.pending:
        titleColor = AppColors.white24;
        subtitleColor = AppColors.white12;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                _buildNodeIcon(status),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: status == StepStatus.done
                          ? AppColors.primary
                          : AppColors.white10,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: AppTypography.fontSizeBase,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: AppTypography.fontSizeXS,
                      height: 1.4,
                    ),
                  ),
                  if (date != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      date,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.6),
                        fontSize: AppTypography.fontSizeTiny,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                  if (status == StepStatus.current) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'IN PROGRESS',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppTypography.fontSizeTiny,
                            letterSpacing: AppTypography.letterSpacingWide,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeIcon(StepStatus status) {
    if (status == StepStatus.done) {
      return Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 12, color: Colors.black),
      );
    } else if (status == StepStatus.current) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.white10,
          shape: BoxShape.circle,
        ),
      );
    }
  }
}
