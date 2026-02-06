import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _rotationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    
    _glowController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

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
            gradient: RadialGradient(
              colors: [
                AppTheme.secondaryDark.withValues(alpha: 0.6),
                AppTheme.primaryDark.withValues(alpha: 0.8),
              ],
              center: Alignment.center,
              radius: 1.5,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar with back button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textWhite,
                          size: 28,
                        ),
                        onPressed: () => context.go('/home'),
                      ),
                      const Expanded(
                        child: Center(
                          child: CustomText.title(
                            'Game Zone',
                            glowColor: AppTheme.neonPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),

                // Main game area - make it scrollable and adaptive
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenHeight = MediaQuery.of(context).size.height;
                        final screenWidth = constraints.maxWidth;
                        final availableHeight = screenHeight - 200; // Account for app bar and safe area
                        
                        // Adaptive sizing based on screen size
                        final iconSize = (screenWidth * 0.3).clamp(100.0, 180.0);
                        final buttonWidth = (screenWidth * 0.85).clamp(250.0, 350.0);
                        final spacing = (availableHeight * 0.03).clamp(15.0, 30.0);
                        
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: availableHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Top spacer
                                SizedBox(height: spacing * 0.5),
                                
                                // Animated game icon
                                AnimatedBuilder(
                                  animation: Listenable.merge([_glowAnimation, _rotationAnimation]),
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _rotationAnimation.value * 2 * 3.14159,
                                      child: Container(
                                        width: iconSize,
                                        height: iconSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.neonPurple.withValues(alpha: _glowAnimation.value),
                                              AppTheme.neonBlue.withValues(alpha: _glowAnimation.value),
                                              AppTheme.neonCyan.withValues(alpha: _glowAnimation.value),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.neonPurple.withValues(alpha: _glowAnimation.value * 0.8),
                                              blurRadius: 40,
                                              offset: const Offset(0, 0),
                                            ),
                                            BoxShadow(
                                              color: AppTheme.neonBlue.withValues(alpha: _glowAnimation.value * 0.6),
                                              blurRadius: 60,
                                              offset: const Offset(0, 0),
                                            ),
                                            BoxShadow(
                                              color: AppTheme.neonCyan.withValues(alpha: _glowAnimation.value * 0.4),
                                              blurRadius: 80,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.games,
                                          size: iconSize * 0.5,
                                          color: AppTheme.textWhite,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(height: spacing),

                                // Main game text
                                const CustomText.large(
                                  'GAME COMING SOON',
                                  textAlign: TextAlign.center,
                                  glowColor: AppTheme.neonCyan,
                                  glowRadius: 15,
                                ),

                                SizedBox(height: spacing * 0.7),

                                // Subtitle
                                const CustomText.title(
                                  'Game logic will be implemented\nin the next development phase',
                                  textAlign: TextAlign.center,
                                  glowColor: AppTheme.neonBlue,
                                ),

                                SizedBox(height: spacing),

                                // Game action buttons - responsive and adaptive
                                Column(
                                  children: [
                                    SizedBox(
                                      width: buttonWidth,
                                      child: CustomElevatedButton(
                                        text: 'Mystery Cards',
                                        backgroundColor: AppTheme.neonPurple,
                                        height: 60,
                                        onPressed: () {
                                          context.go('/mystery-cards');
                                        },
                                      ),
                                    ),

                                    SizedBox(height: spacing * 0.7),

                                    SizedBox(
                                      width: buttonWidth,
                                      child: CustomElevatedButton(
                                        text: 'Game Settings',
                                        backgroundColor: AppTheme.neonBlue,
                                        height: 60,
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const CustomText.body(
                                                'Settings will be available later!',
                                              ),
                                              backgroundColor: AppTheme.secondaryDark,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(height: spacing * 0.7),

                                    SizedBox(
                                      width: buttonWidth,
                                      child: CustomElevatedButton(
                                        text: 'Leaderboard',
                                        backgroundColor: AppTheme.neonCyan,
                                        height: 60,
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const CustomText.body(
                                                'Leaderboard will appear with game logic!',
                                              ),
                                              backgroundColor: AppTheme.secondaryDark,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: spacing),

                                // Back to home button
                                TextButton(
                                  onPressed: () => context.go('/home'),
                                  child: const CustomText.body(
                                    'Back to Home',
                                    glowColor: AppTheme.textGray,
                                  ),
                                ),
                                
                                // Bottom spacer
                                SizedBox(height: spacing * 0.5),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}