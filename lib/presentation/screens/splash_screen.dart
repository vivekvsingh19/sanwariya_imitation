import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'SANWARIYA',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(letterSpacing: 4),
              ),
              Text(
                'IMITATION',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(letterSpacing: 8, color: AppColors.secondary),
              ),
              const SizedBox(height: 24),
              Text(
                'elegant & luxury',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
