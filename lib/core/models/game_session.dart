import 'dart:math';
import '../models/game_mode.dart';
import '../../features/mystery_cards/domain/enums/card_result.dart';
import '../../features/mystery_cards/domain/models/mystery_card.dart';

class GameSession {
  final GameMode gameMode;
  final int cardCount;
  final DateTime startTime;
  
  List<MysteryCard> cards = [];
  int score = 0;
  int coins = 0;
  int xp = 0;
  int lives = 3;
  int multiplier = 1;
  int timeRemaining = 0;
  bool isGameOver = false;
  bool isWon = false;
  int streak = 0;
  List<String> achievements = [];
  
  GameSession({
    required this.gameMode,
    required this.cardCount,
  }) : startTime = DateTime.now() {
    _initializeGame();
  }

  void _initializeGame() {
    timeRemaining = gameMode.timeLimit ?? 0;
    _generateCards();
  }

  void _generateCards() {
    cards.clear();
    final random = Random();
    
    // Create cards based on game mode
    List<CardResult> results = [];
    
    switch (gameMode.type) {
      case GameModeType.classic:
        results = _generateClassicResults();
        break;
      case GameModeType.timeAttack:
        results = _generateTimeAttackResults();
        break;
      case GameModeType.memory:
        results = _generateMemoryResults();
        break;
      case GameModeType.sequence:
        results = _generateSequenceResults();
        break;
      case GameModeType.multiplier:
        results = _generateMultiplierResults();
        break;
    }
    
    // Shuffle results
    results.shuffle(random);
    
    // Create cards
    for (int i = 0; i < cardCount; i++) {
      cards.add(MysteryCard(
        id: i,
        result: results[i],
        isRevealed: false,
        isSelected: false,
      ));
    }
  }

  List<CardResult> _generateClassicResults() {
    List<CardResult> results = [];
    
    // Always have at least 1 win and 1 bonus
    results.add(CardResult.win);
    results.add(CardResult.bonus);
    
    // Fill the rest with empty cards and occasional special cards
    final random = Random();
    for (int i = 2; i < cardCount; i++) {
      if (random.nextDouble() < 0.1) {
        results.add(CardResult.coinBonus);
      } else {
        results.add(CardResult.empty);
      }
    }
    
    return results;
  }

  List<CardResult> _generateTimeAttackResults() {
    List<CardResult> results = [];
    final random = Random();
    
    // More variety in time attack
    results.add(CardResult.win);
    results.add(CardResult.timeBonus);
    
    for (int i = 2; i < cardCount; i++) {
      final chance = random.nextDouble();
      if (chance < 0.15) {
        results.add(CardResult.bonus);
      } else if (chance < 0.25) {
        results.add(CardResult.timeBonus);
      } else if (chance < 0.35) {
        results.add(CardResult.trap);
      } else {
        results.add(CardResult.empty);
      }
    }
    
    return results;
  }

  List<CardResult> _generateMemoryResults() {
    List<CardResult> results = [];
    final random = Random();
    
    results.add(CardResult.win);
    results.add(CardResult.extraLife);
    
    for (int i = 2; i < cardCount; i++) {
      final chance = random.nextDouble();
      if (chance < 0.2) {
        results.add(CardResult.bonus);
      } else if (chance < 0.3) {
        results.add(CardResult.mystery);
      } else {
        results.add(CardResult.empty);
      }
    }
    
    return results;
  }

  List<CardResult> _generateSequenceResults() {
    List<CardResult> results = [];
    
    // Sequence mode has specific pattern
    results.add(CardResult.win);
    results.add(CardResult.bonus);
    results.add(CardResult.multiplier);
    
    for (int i = 3; i < cardCount; i++) {
      results.add(CardResult.empty);
    }
    
    return results;
  }

  List<CardResult> _generateMultiplierResults() {
    List<CardResult> results = [];
    final random = Random();
    
    results.add(CardResult.win);
    results.add(CardResult.multiplier);
    results.add(CardResult.multiplier);
    
    for (int i = 3; i < cardCount; i++) {
      final chance = random.nextDouble();
      if (chance < 0.2) {
        results.add(CardResult.bonus);
      } else if (chance < 0.3) {
        results.add(CardResult.coinBonus);
      } else {
        results.add(CardResult.empty);
      }
    }
    
    return results;
  }

  void selectCard(int cardId) {
    if (isGameOver) return;
    
    final cardIndex = cards.indexWhere((c) => c.id == cardId);
    if (cardIndex == -1) return;
    
    final card = cards[cardIndex];
    cards[cardIndex] = card.copyWith(isSelected: true, isRevealed: true);
    
    _processCardResult(card.result);
    _checkGameEnd();
  }

  void _processCardResult(CardResult result) {
    switch (result) {
      case CardResult.win:
        isWon = true;
        score += 100 * multiplier;
        xp += gameMode.baseXP * multiplier;
        coins += gameMode.baseCoins * multiplier;
        streak++;
        _checkAchievements();
        break;
        
      case CardResult.bonus:
        score += 50 * multiplier;
        xp += (gameMode.baseXP * 0.5).round() * multiplier;
        coins += (gameMode.baseCoins * 0.5).round() * multiplier;
        break;
        
      case CardResult.multiplier:
        multiplier = (multiplier * 2).clamp(1, 8);
        score += 25;
        break;
        
      case CardResult.extraLife:
        lives = (lives + 1).clamp(1, 5);
        score += 30;
        break;
        
      case CardResult.timeBonus:
        if (gameMode.hasTimer) {
          timeRemaining += 5;
        }
        score += 40;
        break;
        
      case CardResult.coinBonus:
        coins += 20 * multiplier;
        score += 35;
        break;
        
      case CardResult.trap:
        lives = (lives - 1).clamp(0, 5);
        score = (score - 25).clamp(0, score);
        if (lives <= 0) {
          isGameOver = true;
        }
        break;
        
      case CardResult.mystery:
        _processMysteryCard();
        break;
        
      case CardResult.empty:
        // No effect, but reset streak
        streak = 0;
        break;
    }
  }

  void _processMysteryCard() {
    final random = Random();
    final effects = [
      () => score += 75,
      () => coins += 15,
      () => xp += 20,
      () => multiplier = (multiplier + 1).clamp(1, 8),
      () => lives = (lives + 1).clamp(1, 5),
      () => timeRemaining += 3,
    ];
    
    final effect = effects[random.nextInt(effects.length)];
    effect();
  }

  void _checkGameEnd() {
    if (lives <= 0) {
      isGameOver = true;
      return;
    }
    
    // Check if all cards are revealed or win condition met
    final revealedCards = cards.where((c) => c.isRevealed).length;
    if (revealedCards >= cardCount || isWon) {
      isGameOver = true;
    }
  }

  void _checkAchievements() {
    // Check for various achievements
    if (score >= 500 && !achievements.contains('high_scorer')) {
      achievements.add('high_scorer');
    }
    
    if (multiplier >= 4 && !achievements.contains('multiplier_master')) {
      achievements.add('multiplier_master');
    }
    
    if (streak >= 3 && !achievements.contains('streak_master')) {
      achievements.add('streak_master');
    }
    
    if (coins >= 100 && !achievements.contains('coin_collector')) {
      achievements.add('coin_collector');
    }
  }

  void revealAllCards() {
    for (int i = 0; i < cards.length; i++) {
      cards[i] = cards[i].copyWith(isRevealed: true);
    }
    isGameOver = true;
  }

  Duration get gameDuration => DateTime.now().difference(startTime);
  
  double get accuracy => cards.isEmpty ? 0.0 : 
      cards.where((c) => c.isSelected && (c.result == CardResult.win || c.result == CardResult.bonus)).length / 
      cards.where((c) => c.isSelected).length;

  Map<String, dynamic> getGameSummary() {
    return {
      'mode': gameMode.name,
      'score': score,
      'coins': coins,
      'xp': xp,
      'duration': gameDuration.inSeconds,
      'accuracy': accuracy,
      'streak': streak,
      'multiplier': multiplier,
      'achievements': achievements,
      'isWon': isWon,
    };
  }
}