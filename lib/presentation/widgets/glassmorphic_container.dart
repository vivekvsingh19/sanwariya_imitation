import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassmorphicContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.5),
             blurRadius: 10,
             offset: const Offset(0, 4),
          )
        ]
      ),
      child: child,
    );
  }
}
