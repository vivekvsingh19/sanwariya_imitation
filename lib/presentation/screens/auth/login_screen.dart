import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../../core/constants/colors.dart';
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
              SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
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
                  const Color(0xFF2A2A2A), // Soft highlight behind text
                  AppColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Top header
                    Text(
                      'S A N W A R I Y A   I M I T A T I O N',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        letterSpacing: 4.0,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 64),
                    // Title
                    Text(
                      'Welcome to\nSanwariya Imitation',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.primary,
                        fontSize: 36,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Subtitle
                    Text(
                      'AUTHENTICATE TO VIEW OUR PRIVATE\nCURATIONS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        letterSpacing: 2.0,
                        fontSize: 10,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 80),
                    
                    // Form
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MOBILE IDENTITY',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '+91',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 20, letterSpacing: 4.0),
                            decoration: InputDecoration(
                              hintText: 'O O O O O  O O O O O',
                              hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 18, letterSpacing: 4.0),
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
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 48),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                // Defaulting bypass logic to satisfy block
                                context.read<AuthBloc>().add(
                                  const LoginRequested('test@example.com', 'password'),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary, // Slightly lighter gold
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 64),
                    // Divider OR
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white12)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR AUTHENTICATE VIA',
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white12)),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialBtn(
                          iconWidget: _buildGoogleIcon(),
                          label: 'GOOGLE',
                        ),
                        const SizedBox(width: 24),
                        _buildSocialBtn(
                          iconWidget: const Icon(Icons.apple, color: Colors.white, size: 20),
                          label: 'IOS',
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),
                    
                    // Bottom Terms
                    Text(
                      'BY ENTERING, YOU AGREE TO OUR',
                      style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(fontSize: 10, letterSpacing: 1.0, color: AppColors.primary),
                        children: const [
                          TextSpan(text: 'PRIVACY MANDATE'),
                          TextSpan(text: ' & ', style: TextStyle(color: AppColors.textMuted)),
                          TextSpan(text: 'TERMS OF ACCESS'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSocialBtn({required Widget iconWidget, required String label}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 11, letterSpacing: 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
