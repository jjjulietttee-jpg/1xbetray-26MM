import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/card_widget.dart';
import '../../../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryDark,
              AppTheme.secondaryDark.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            transform: GradientRotation(_scrollOffset * 0.001),
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonPurple.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, _scrollOffset * 0.3),
                      child: const CustomText.large(
                        'NEON VAULT',
                        glowColor: AppTheme.neonPurple,
                        glowRadius: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main Play Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: CustomElevatedButton(
                          text: 'ИГРАТЬ',
                          icon: Icons.play_arrow,
                          width: 280,
                          height: 80,
                          backgroundColor: AppTheme.neonCyan,
                          onPressed: () => context.go('/game'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Quick Access Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomText.heading(
                        'Быстрый доступ',
                        glowColor: AppTheme.neonBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CardWidget(
                            height: 120,
                            borderColor: AppTheme.neonPurple,
                            onTap: () => context.go('/profile'),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppTheme.neonPurple,
                                ),
                                SizedBox(height: 8),
                                CustomText.title(
                                  'Профиль',
                                  glowColor: AppTheme.neonPurple,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CardWidget(
                            height: 120,
                            borderColor: AppTheme.neonCyan,
                            onTap: () => context.go('/profile'),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  size: 40,
                                  color: AppTheme.neonCyan,
                                ),
                                SizedBox(height: 8),
                                CustomText.title(
                                  'Достижения',
                                  glowColor: AppTheme.neonCyan,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Game Stats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomText.heading(
                        'Статистика',
                        glowColor: AppTheme.neonCyan,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CardWidget(
                      child: Column(
                        children: [
                          _buildStatRow('Игр сыграно', '0', Icons.games),
                          const Divider(color: AppTheme.textGray),
                          _buildStatRow('Лучший результат', '0', Icons.star),
                          const Divider(color: AppTheme.textGray),
                          _buildStatRow('Достижений', '0/10', Icons.emoji_events),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Activity
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomText.heading(
                        'Последняя активность',
                        glowColor: AppTheme.neonPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CardWidget(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: AppTheme.textGray.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              CustomText.body(
                                'Пока нет активности',
                                glowColor: AppTheme.textGray.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              const CustomText.body(
                                'Начните играть, чтобы увидеть статистику!',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.neonBlue,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomText.body(label),
          ),
          CustomText.title(
            value,
            glowColor: AppTheme.neonCyan,
          ),
        ],
      ),
    );
  }
}