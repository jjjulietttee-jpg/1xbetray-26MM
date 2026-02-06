import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  final ProfileEntity profile;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPurple.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.neonPurple, AppTheme.neonCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPurple.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 50, color: AppTheme.textWhite),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.neonCyan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryDark, width: 2),
                  ),
                  child: Text(
                    '${profile.level}',
                    style: const TextStyle(
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: CustomText.heading(
                  profile.playerName,
                  glowColor: AppTheme.neonCyan,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEditTap,
                child: Icon(
                  Icons.edit,
                  color: AppTheme.neonCyan.withValues(alpha: 0.8),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.neonPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.5)),
            ),
            child: Text(
              profile.rankTitle,
              style: const TextStyle(
                color: AppTheme.neonPurple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level ${profile.level}', style: const TextStyle(color: AppTheme.neonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Level ${profile.level + 1}', style: const TextStyle(color: AppTheme.neonCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: profile.levelProgress,
                backgroundColor: AppTheme.textGray.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.xpInCurrentLevel}/100 XP',
                style: TextStyle(color: AppTheme.textGray.withValues(alpha: 0.8), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
