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
                content: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.textWhite),
                ),
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
                colors: [AppColors.surfaceHighlight, AppColors.background],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sectionGap,
                  ),
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
                        'SIGN IN TO VIEW OUR JEWELRY',
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
                          'PHONE NUMBER',
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
                            style:
                                AppTypography.headingMedium(
                                  fontWeight: FontWeight.normal,
                                ).copyWith(
                                  letterSpacing:
                                      AppTypography.letterSpacingNormal,
                                ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style:
                                  AppTypography.headingMedium(
                                    fontWeight: FontWeight.normal,
                                  ).copyWith(
                                    letterSpacing:
                                        AppTypography.letterSpacingUltra,
                                  ),
                              decoration: InputDecoration(
                                hintText: 'O O O O O  O O O O O',
                                hintStyle:
                                    AppTypography.headingSmall(
                                      color: AppColors.white24,
                                    ).copyWith(
                                      letterSpacing:
                                          AppTypography.letterSpacingUltra,
                                    ),
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
                                    const LoginRequested(
                                      'test@example.com',
                                      'password',
                                    ),
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
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'LOG IN',
                                  style: AppTypography.bodySmall(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing:
                                        AppTypography.letterSpacingWide,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.giant),

                      // Bottom Terms
                      Text(
                        'BY CONTINUING, YOU AGREE TO OUR',
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
                            const TextSpan(text: 'PRIVACY POLICY'),
                            TextSpan(
                              text: ' & ',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            const TextSpan(text: 'TERMS OF USE'),
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
}
