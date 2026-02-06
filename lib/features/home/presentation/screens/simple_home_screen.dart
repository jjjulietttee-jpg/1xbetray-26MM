import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryDark.withValues(alpha: 0.7),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                final buttonWidth = screenWidth * 0.85; // 85% of screen width
                
                return Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const CustomText.title(
                        'NEON VAULT',
                        glowColor: AppTheme.neonPurple,
                      ),
                    ),
                    
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            
                            const CustomText.large(
                              'NEON VAULT',
                              glowColor: AppTheme.neonPurple,
                              glowRadius: 20,
                            ),
                            
                            SizedBox(height: screenHeight * 0.08),
                            
                            // Main PLAY button (Game Modes)
                            SizedBox(
                              width: buttonWidth.clamp(250.0, 400.0),
                              child: CustomElevatedButton(
                                text: 'PLAY',
                                height: 80,
                                backgroundColor: AppTheme.neonCyan,
                                onPressed: () {
                                  context.go('/game-modes');
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Secondary buttons row
                            Row(
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    text: 'Profile',
                                    backgroundColor: AppTheme.neonPurple,
                                    onPressed: () {
                                      context.go('/profile');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomElevatedButton(
                                    text: 'Achievements',
                                    backgroundColor: AppTheme.neonBlue,
                                    onPressed: () {
                                      context.go('/achievements');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                            
                            TextButton(
                              onPressed: () {
                                context.go('/onboarding');
                              },
                              child: const CustomText.body(
                                'Back to Introduction',
                                glowColor: AppTheme.textGray,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}