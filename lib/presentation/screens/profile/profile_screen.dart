import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/auth/auth_event.dart';
import '../auth/login_screen.dart';
import '../../widgets/brand_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: BrandAppBar(useSafeArea: false, showSearch: false),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: AppSpacing.cardLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar with Royal Badge
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300&auto=format&fit=crop',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: AppRadius.xxlBorder,
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.secondary,
                                size: 10,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ROYAL\nTIER MEMBER',
                                textAlign: TextAlign.center,
                                style:
                                    AppTypography.caption(
                                      color: AppColors.secondary,
                                    ).copyWith(
                                      letterSpacing:
                                          AppTypography.letterSpacingWide,
                                      height: 1.2,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Name and Patron status
                  Text(
                    state.user.name.isEmpty
                        ? 'Vaidehi Sharma'
                        : state.user.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.displaySmall(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Patron since 2021',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.massive),

                  // Menu Options
                  _buildProfileOption(
                    icon: LucideIcons.truck,
                    title: 'MY PRIVATE SUITE',
                    subtitle: 'Track your acquisitions',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: LucideIcons.gem,
                    title: 'THE WISHLIST',
                    subtitle: 'Your curated desires',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: LucideIcons.mapPin,
                    title: 'DELIVERY RESIDENCIES',
                    subtitle: 'Manage secure locations',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: LucideIcons.wallet,
                    title: 'PAYMENT PRIVILEGES',
                    subtitle: 'Vaulted cards & methods',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: LucideIcons.headphones,
                    title: 'CONCIERGE SUPPORT',
                    subtitle: 'Direct concierge access',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildProfileOption(
                    icon: LucideIcons.settings,
                    title: 'SETTINGS',
                    subtitle: 'Preferences & security',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.huge),

                  // Logout Button
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    child: Text(
                      'L O G O U T',
                      style: AppTypography.bodySmall(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: AppTypography.letterSpacingUltra,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xlBorder,
        child: Container(
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.xlBorder,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelLarge(
                        fontWeight: FontWeight.bold,
                        letterSpacing: AppTypography.letterSpacingTight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.labelMedium(
                        color: AppColors.textMuted.withValues(alpha: 0.8),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
