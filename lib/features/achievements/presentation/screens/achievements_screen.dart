import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/achievements_cubit.dart';
import '../widgets/achievement_card.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AchievementsCubit>().load();
    });
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
            color: AppTheme.primaryDark.withValues(alpha: 0.7),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BlocBuilder<AchievementsCubit, AchievementsState>(
                    builder: (context, state) {
                      if (state is AchievementsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.neonCyan,
                          ),
                        );
                      }
                      if (state is AchievementsError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText.body(state.message),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () =>
                                      context.read<AchievementsCubit>().load(),
                                  child: const CustomText.body(
                                    'Retry',
                                    glowColor: AppTheme.neonCyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (state is AchievementsLoaded) {
                        return _buildContent(context, state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite, size: 28),
            onPressed: () => context.go('/profile'),
          ),
          const Expanded(
            child: Center(
              child: CustomText.heading(
                'Achievements',
                glowColor: AppTheme.neonPurple,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AchievementsLoaded state) {
    final items = state.items;
    final unlocked = items.where((i) => i.isCompleted).length;
    final total = items.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: AppTheme.neonCyan, size: 32),
                    const SizedBox(width: 12),
                    CustomText.heading(
                      '$unlocked/$total',
                      glowColor: AppTheme.neonCyan,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CustomText.body(
                  'Achievements Unlocked',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: total > 0 ? unlocked / total : 0,
                  backgroundColor: AppTheme.textGray.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((i) => AchievementCard(key: ValueKey(i.achievement.id), item: i)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
