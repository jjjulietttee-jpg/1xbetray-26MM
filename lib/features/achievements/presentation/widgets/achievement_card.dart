import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/achievement_with_progress.dart';

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key, required this.item});

  final AchievementWithProgress item;

  @override
  Widget build(BuildContext context) {
    final a = item.achievement;
    final isUnlocked = item.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? a.color.withValues(alpha: 0.5)
              : AppTheme.textGray.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: a.color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? a.color
                    : AppTheme.textGray.withValues(alpha: 0.3),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: a.color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                a.icon,
                color: isUnlocked ? AppTheme.textWhite : AppTheme.textGray,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText.title(
                          a.title,
                          glowColor: isUnlocked ? a.color : null,
                        ),
                      ),
                      if (isUnlocked)
                        Icon(Icons.check_circle, color: a.color, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.description,
                    style: TextStyle(
                      color: AppTheme.textGray.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  if (!isUnlocked && a.type != 'special') ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: item.progress,
                            backgroundColor:
                                AppTheme.textGray.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(a.color),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.currentValue}/${a.requiredValue}',
                          style: TextStyle(
                            color: a.color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
