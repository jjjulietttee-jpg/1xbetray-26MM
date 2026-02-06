import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileRankSection extends StatelessWidget {
  const ProfileRankSection({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.military_tech, color: AppTheme.neonBlue, size: 24),
              const SizedBox(width: 8),
              const CustomText.title('Player stats', glowColor: AppTheme.neonBlue),
            ],
          ),
          const SizedBox(height: 16),
          _StatRow(label: 'Best score', value: '${profile.bestScore}'),
          const SizedBox(height: 8),
          _StatRow(label: 'Win rate', value: '${(profile.winRate * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.body(label),
        CustomText.title(value, glowColor: AppTheme.neonCyan),
      ],
    );
  }
}
