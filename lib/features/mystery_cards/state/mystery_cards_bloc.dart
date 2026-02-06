import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/mystery_card.dart';
import '../domain/enums/card_result.dart';
import '../domain/logic/mystery_cards_controller.dart';

// Events
abstract class MysteryCardsEvent {}

class StartNewGame extends MysteryCardsEvent {
  final int cardCount;
  StartNewGame({this.cardCount = 3});
}

class SelectCard extends MysteryCardsEvent {
  final int cardId;
  SelectCard(this.cardId);
}

class RevealAllCards extends MysteryCardsEvent {}

class ResetGame extends MysteryCardsEvent {}

// State
class MysteryCardsState {
  final List<MysteryCard> cards;
  final GameState gameState;
  final MysteryCard? selectedCard;
  final bool isInputBlocked;

  const MysteryCardsState({
    this.cards = const [],
    this.gameState = GameState.idle,
    this.selectedCard,
    this.isInputBlocked = false,
  });

  MysteryCardsState copyWith({
    List<MysteryCard>? cards,
    GameState? gameState,
    MysteryCard? selectedCard,
    bool? isInputBlocked,
  }) {
    return MysteryCardsState(
      cards: cards ?? this.cards,
      gameState: gameState ?? this.gameState,
      selectedCard: selectedCard ?? this.selectedCard,
      isInputBlocked: isInputBlocked ?? this.isInputBlocked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MysteryCardsState &&
        other.cards == cards &&
        other.gameState == gameState &&
        other.selectedCard == selectedCard &&
        other.isInputBlocked == isInputBlocked;
  }

  @override
  int get hashCode {
    return cards.hashCode ^
        gameState.hashCode ^
        selectedCard.hashCode ^
        isInputBlocked.hashCode;
  }
}

// Bloc
class MysteryCardsBloc extends Bloc<MysteryCardsEvent, MysteryCardsState> {
  final MysteryCardsController _controller = MysteryCardsController();

  MysteryCardsBloc() : super(const MysteryCardsState()) {
    on<StartNewGame>(_onStartNewGame);
    on<SelectCard>(_onSelectCard);
    on<RevealAllCards>(_onRevealAllCards);
    on<ResetGame>(_onResetGame);
  }

  void _onStartNewGame(StartNewGame event, Emitter<MysteryCardsState> emit) {
    try {
      final cards = _controller.generateCards(cardCount: event.cardCount);
      emit(state.copyWith(
        cards: cards,
        gameState: GameState.idle,
        selectedCard: null,
        isInputBlocked: false,
      ));
    } catch (e) {
      // Handle error - emit current state or error state
      emit(state);
    }
  }

  void _onSelectCard(SelectCard event, Emitter<MysteryCardsState> emit) {
    // Check if selection is allowed
    if (!_controller.canSelectCard(state.cards, state.gameState)) {
      return;
    }

    // Block input during animation
    emit(state.copyWith(
      isInputBlocked: true,
      gameState: GameState.revealing,
    ));

    // Select the card
    final updatedCards = _controller.selectCard(state.cards, event.cardId);
    final selectedCard = _controller.getSelectedCard(updatedCards);

    emit(state.copyWith(
      cards: updatedCards,
      selectedCard: selectedCard,
    ));
  }

  void _onRevealAllCards(RevealAllCards event, Emitter<MysteryCardsState> emit) {
    final revealedCards = _controller.revealAllCards(state.cards);
    emit(state.copyWith(
      cards: revealedCards,
      gameState: GameState.finished,
      isInputBlocked: false,
    ));
  }

  void _onResetGame(ResetGame event, Emitter<MysteryCardsState> emit) {
    emit(const MysteryCardsState());
  }
}