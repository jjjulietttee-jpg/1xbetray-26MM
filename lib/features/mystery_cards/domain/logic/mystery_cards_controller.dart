import 'dart:math';
import '../models/mystery_card.dart';
import '../enums/card_result.dart';

class MysteryCardsController {
  static const int defaultCardCount = 3;
  static const int maxCardCount = 5;
  static const int minCardCount = 3;

  final Random _random = Random();

  /// Generates a new set of mystery cards with randomized results
  List<MysteryCard> generateCards({int cardCount = defaultCardCount}) {
    // Validate card count
    if (cardCount < minCardCount || cardCount > maxCardCount) {
      throw ArgumentError('Card count must be between $minCardCount and $maxCardCount');
    }

    // Create results list: 1 win, 1 bonus, rest empty
    final List<CardResult> results = [
      CardResult.win,
      CardResult.bonus,
      ...List.filled(cardCount - 2, CardResult.empty),
    ];

    // Shuffle results to randomize positions
    results.shuffle(_random);

    // Create cards with shuffled results
    return List.generate(
      cardCount,
      (index) => MysteryCard(
        id: index,
        result: results[index],
      ),
    );
  }

  /// Selects a card and returns updated cards list
  List<MysteryCard> selectCard(List<MysteryCard> cards, int cardId) {
    return cards.map((card) {
      if (card.id == cardId) {
        return card.copyWith(isSelected: true, isRevealed: true);
      }
      return card;
    }).toList();
  }

  /// Reveals all cards (for end game state)
  List<MysteryCard> revealAllCards(List<MysteryCard> cards) {
    return cards.map((card) => card.copyWith(isRevealed: true)).toList();
  }

  /// Gets the selected card from the list
  MysteryCard? getSelectedCard(List<MysteryCard> cards) {
    try {
      return cards.firstWhere((card) => card.isSelected);
    } catch (e) {
      return null;
    }
  }

  /// Checks if any card is selected
  bool hasSelectedCard(List<MysteryCard> cards) {
    return cards.any((card) => card.isSelected);
  }

  /// Validates if card selection is allowed
  bool canSelectCard(List<MysteryCard> cards, GameState gameState) {
    return gameState == GameState.idle && !hasSelectedCard(cards);
  }

  /// Resets all cards to initial state
  List<MysteryCard> resetCards(List<MysteryCard> cards) {
    return cards.map((card) => card.copyWith(
      isRevealed: false,
      isSelected: false,
    )).toList();
  }
}