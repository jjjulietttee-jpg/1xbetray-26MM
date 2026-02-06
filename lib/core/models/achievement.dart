import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int requiredValue;
  final String type; // 'games', 'wins', 'streak', 'special'

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requiredValue,
    required this.type,
  });

  static List<Achievement> getAllAchievements() {
    return [
      // Beginner achievements
      const Achievement(
        id: 'first_game',
        title: 'First Steps',
        description: 'Play your first game',
        icon: Icons.play_arrow,
        color: AppTheme.neonCyan,
        requiredValue: 1,
        type: 'games',
      ),
      const Achievement(
        id: 'first_win',
        title: 'Lucky Winner',
        description: 'Win your first game',
        icon: Icons.star,
        color: AppTheme.neonPurple,
        requiredValue: 1,
        type: 'wins',
      ),
      
      // Progress achievements
      const Achievement(
        id: 'games_10',
        title: 'Getting Started',
        description: 'Play 10 games',
        icon: Icons.games,
        color: AppTheme.neonBlue,
        requiredValue: 10,
        type: 'games',
      ),
      const Achievement(
        id: 'games_50',
        title: 'Dedicated Player',
        description: 'Play 50 games',
        icon: Icons.emoji_events,
        color: AppTheme.neonCyan,
        requiredValue: 50,
        type: 'games',
      ),
      const Achievement(
        id: 'games_100',
        title: 'Centurion',
        description: 'Play 100 games',
        icon: Icons.military_tech,
        color: AppTheme.neonPurple,
        requiredValue: 100,
        type: 'games',
      ),
      
      // Win achievements
      const Achievement(
        id: 'wins_5',
        title: 'Lucky Streak',
        description: 'Win 5 games',
        icon: Icons.local_fire_department,
        color: AppTheme.neonBlue,
        requiredValue: 5,
        type: 'wins',
      ),
      const Achievement(
        id: 'wins_25',
        title: 'Master Player',
        description: 'Win 25 games',
        icon: Icons.workspace_premium,
        color: AppTheme.neonCyan,
        requiredValue: 25,
        type: 'wins',
      ),
      const Achievement(
        id: 'wins_50',
        title: 'Champion',
        description: 'Win 50 games',
        icon: Icons.military_tech,
        color: AppTheme.neonPurple,
        requiredValue: 50,
        type: 'wins',
      ),
      
      // Special achievements
      const Achievement(
        id: 'profile_setup',
        title: 'Personal Touch',
        description: 'Set up your profile',
        icon: Icons.person,
        color: AppTheme.neonBlue,
        requiredValue: 1,
        type: 'special',
      ),
      const Achievement(
        id: 'settings_explorer',
        title: 'Customizer',
        description: 'Visit the settings screen',
        icon: Icons.settings,
        color: AppTheme.neonCyan,
        requiredValue: 1,
        type: 'special',
      ),
    ];
  }
}