import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GameModeType {
  classic,
  timeAttack,
  memory,
  sequence,
  multiplier,
}

class GameMode {
  final GameModeType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int minCards;
  final int maxCards;
  final bool hasTimer;
  final int? timeLimit; // seconds
  final bool hasMultiplier;
  final bool hasSequence;
  final int baseXP;
  final int baseCoins;

  const GameMode({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.minCards,
    required this.maxCards,
    required this.hasTimer,
    this.timeLimit,
    required this.hasMultiplier,
    required this.hasSequence,
    required this.baseXP,
    required this.baseCoins,
  });

  static List<GameMode> getAllModes() {
    return [
      const GameMode(
        type: GameModeType.classic,
        name: 'Classic',
        description: 'Traditional mystery cards game',
        icon: Icons.style,
        color: AppTheme.neonPurple,
        minCards: 3,
        maxCards: 7,
        hasTimer: false,
        hasMultiplier: false,
        hasSequence: false,
        baseXP: 10,
        baseCoins: 5,
      ),
      const GameMode(
        type: GameModeType.timeAttack,
        name: 'Time Attack',
        description: 'Quick decisions under pressure',
        icon: Icons.timer,
        color: AppTheme.neonBlue,
        minCards: 5,
        maxCards: 9,
        hasTimer: true,
        timeLimit: 10,
        hasMultiplier: false,
        hasSequence: false,
        baseXP: 20,
        baseCoins: 10,
      ),
      const GameMode(
        type: GameModeType.memory,
        name: 'Memory Challenge',
        description: 'Remember the pattern and choose wisely',
        icon: Icons.psychology,
        color: AppTheme.neonCyan,
        minCards: 4,
        maxCards: 8,
        hasTimer: false,
        hasMultiplier: false,
        hasSequence: true,
        baseXP: 25,
        baseCoins: 15,
      ),
      const GameMode(
        type: GameModeType.sequence,
        name: 'Sequence Master',
        description: 'Find the correct order',
        icon: Icons.format_list_numbered,
        color: AppTheme.neonPurple,
        minCards: 3,
        maxCards: 6,
        hasTimer: false,
        hasMultiplier: false,
        hasSequence: true,
        baseXP: 30,
        baseCoins: 20,
      ),
      const GameMode(
        type: GameModeType.multiplier,
        name: 'Multiplier Madness',
        description: 'Chain wins for massive rewards',
        icon: Icons.trending_up,
        color: AppTheme.neonCyan,
        minCards: 5,
        maxCards: 7,
        hasTimer: false,
        hasMultiplier: true,
        hasSequence: false,
        baseXP: 15,
        baseCoins: 8,
      ),
    ];
  }
}