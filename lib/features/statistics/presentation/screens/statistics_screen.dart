import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/user_preferences.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _gamesPlayed = 0;
  int _wins = 0;
  int _level = 1;
  int _xp = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _gamesPlayed = UserPreferences.gamesPlayed;
      _wins = UserPreferences.wins;
      _level = UserPreferences.level;
      _xp = UserPreferences.xp;
    });
  }

  double get _winRate => _gamesPlayed > 0 ? (_wins / _gamesPlayed) : 0.0;
  int get _losses => _gamesPlayed - _wins;

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
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textWhite,
                          size: 28,
                        ),
                        onPressed: () => context.go('/profile'),
                      ),
                      const Expanded(
                        child: Center(
                          child: CustomText.heading(
                            'Statistics',
                            glowColor: AppTheme.neonPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Statistics content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Overview cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Games Played',
                                _gamesPlayed.toString(),
                                Icons.games,
                                AppTheme.neonBlue,
                                0,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Wins',
                                _wins.toString(),
                                Icons.emoji_events,
                                AppTheme.neonCyan,
                                1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Losses',
                                _losses.toString(),
                                Icons.close,
                                AppTheme.neonPurple,
                                2,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Level',
                                _level.toString(),
                                Icons.star,
                                AppTheme.neonCyan,
                                3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Win rate chart
                        _buildWinRateCard(),

                        const SizedBox(height: 24),

                        // Progress card
                        _buildProgressCard(),

                        const SizedBox(height: 24),

                        // Detailed stats
                        _buildDetailedStatsCard(),
                      ],
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = Curves.easeOutBack.transform(
          (_animationController.value - (index * 0.1)).clamp(0.0, 1.0),
        ).clamp(0.0, 1.0); // Clamp to ensure valid opacity range

        return Transform.translate(
          offset: Offset(0, 30 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  CustomText.heading(
                    value,
                    glowColor: color,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.textGray.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWinRateCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - 0.4).clamp(0.0, 1.0),
        );

        return Opacity(
          opacity: animationValue,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.neonPurple.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppTheme.neonPurple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const CustomText.title(
                      'Win Rate',
                      glowColor: AppTheme.neonPurple,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Circular progress indicator
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _winRate * animationValue,
                            strokeWidth: 8,
                            backgroundColor: AppTheme.textGray.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonPurple),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText.heading(
                              '${(_winRate * 100 * animationValue).toInt()}%',
                              glowColor: AppTheme.neonPurple,
                            ),
                            Text(
                              'Win Rate',
                              style: TextStyle(
                                color: AppTheme.textGray.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressCard() {
    final currentLevelXP = _xp - ((_level - 1) * 100);
    final progressValue = currentLevelXP / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: AppTheme.neonCyan,
                size: 24,
              ),
              const SizedBox(width: 12),
              const CustomText.title(
                'Level Progress',
                glowColor: AppTheme.neonCyan,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.body('Level $_level'),
              CustomText.body('$currentLevelXP / 100 XP'),
            ],
          ),
          
          const SizedBox(height: 8),
          
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final animationValue = Curves.easeOut.transform(
                (_animationController.value - 0.6).clamp(0.0, 1.0),
              );
              
              return LinearProgressIndicator(
                value: progressValue * animationValue,
                backgroundColor: AppTheme.textGray.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
                minHeight: 8,
              );
            },
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Next level: ${100 - currentLevelXP} XP to go',
            style: TextStyle(
              color: AppTheme.textGray.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics,
                color: AppTheme.neonBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              const CustomText.title(
                'Detailed Statistics',
                glowColor: AppTheme.neonBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildDetailRow('Total Games', _gamesPlayed.toString()),
          _buildDetailRow('Wins', _wins.toString()),
          _buildDetailRow('Losses', _losses.toString()),
          _buildDetailRow('Win Rate', '${(_winRate * 100).toStringAsFixed(1)}%'),
          _buildDetailRow('Current Level', _level.toString()),
          _buildDetailRow('Total XP', _xp.toString()),
          _buildDetailRow('Average XP per Game', 
              _gamesPlayed > 0 ? (_xp / _gamesPlayed).toStringAsFixed(1) : '0'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText.body(label),
          CustomText.body(
            value,
            glowColor: AppTheme.neonBlue,
          ),
        ],
      ),
    );
  }
}