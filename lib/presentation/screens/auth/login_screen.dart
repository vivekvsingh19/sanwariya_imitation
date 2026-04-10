import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: const TextStyle(color: AppColors.textWhite)),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.0,
                colors: [
                  AppColors.surfaceHighlight,
                  AppColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sectionGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.massive),
                    // Top header
                    Text(
                      'SANWARIYA  IMITATION',
                      style: AppTypography.brandTitle(
                        fontSize: AppTypography.fontSizeXS,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.giant),
                    // Title
                    Text(
                      'Welcome to\nSanwariya Imitation',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayLarge(),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Subtitle
                    Text(
                      'AUTHENTICATE TO VIEW OUR PRIVATE\nCURATIONS',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelMedium(
                        letterSpacing: AppTypography.letterSpacingXWide,
                      ).copyWith(height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.colossal),
                    
                    // Form
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MOBILE IDENTITY',
                        style: AppTypography.labelMedium(
                          fontWeight: FontWeight.bold,
                          letterSpacing: AppTypography.letterSpacingXWide,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '+91',
                          style: AppTypography.headingMedium(
                            fontWeight: FontWeight.normal,
                          ).copyWith(letterSpacing: AppTypography.letterSpacingNormal),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: AppTypography.headingMedium(
                              fontWeight: FontWeight.normal,
                            ).copyWith(letterSpacing: AppTypography.letterSpacingUltra),
                            decoration: InputDecoration(
                              hintText: 'O O O O O  O O O O O',
                              hintStyle: AppTypography.headingSmall(
                                color: AppColors.white24,
                              ).copyWith(letterSpacing: AppTypography.letterSpacingUltra),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.white24, height: 1),
                    const SizedBox(height: AppSpacing.massive),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  const LoginRequested('test@example.com', 'password'),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdBorder,
                          ),
                          elevation: 0,
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                              )
                            : Text(
                                'REQUEST SECURE ACCESS',
                                style: AppTypography.bodySmall(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: AppTypography.letterSpacingWide,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.giant),
                    // Divider OR
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.white12)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          child: Text(
                            'OR AUTHENTICATE VIA',
                            style: AppTypography.labelMedium(
                              letterSpacing: AppTypography.letterSpacingWide,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.white12)),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.sectionGap),
                    
                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialBtn(
                          iconWidget: _buildGoogleIcon(),
                          label: 'GOOGLE',
                        ),
                        const SizedBox(width: AppSpacing.xxl),
                        _buildSocialBtn(
                          iconWidget: const Icon(Icons.apple, color: AppColors.textWhite, size: 20),
                          label: 'IOS',
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.massive),
                    
                    // Bottom Terms
                    Text(
                      'BY ENTERING, YOU AGREE TO OUR',
                      style: AppTypography.labelMedium(
                        letterSpacing: AppTypography.letterSpacingWide,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RichText(
                      text: TextSpan(
                        style: AppTypography.labelMedium(
                          color: AppColors.primary,
                          letterSpacing: AppTypography.letterSpacingNormal,
                        ),
                        children: [
                          const TextSpan(text: 'PRIVACY MANDATE'),
                          TextSpan(text: ' & ', style: TextStyle(color: AppColors.textMuted)),
                          const TextSpan(text: 'TERMS OF ACCESS'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.textWhite,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: AppTypography.fontSizeSM,
        ),
      ),
    );
  }

  Widget _buildSocialBtn({required Widget iconWidget, required String label}) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.white12),
          borderRadius: AppRadius.pillBorder,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypography.labelLarge(
                letterSpacing: AppTypography.letterSpacingXWide,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
