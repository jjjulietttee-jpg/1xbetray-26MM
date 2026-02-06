enum CardResult {
  win,
  bonus,
  empty,
  multiplier,
  extraLife,
  timeBonus,
  coinBonus,
  trap,
  mystery;

  String get displayText {
    switch (this) {
      case CardResult.win:
        return 'WIN!';
      case CardResult.bonus:
        return 'BONUS!';
      case CardResult.empty:
        return 'TRY AGAIN';
      case CardResult.multiplier:
        return 'MULTIPLIER!';
      case CardResult.extraLife:
        return 'EXTRA LIFE!';
      case CardResult.timeBonus:
        return 'TIME BONUS!';
      case CardResult.coinBonus:
        return 'COIN BONUS!';
      case CardResult.trap:
        return 'TRAP!';
      case CardResult.mystery:
        return 'MYSTERY!';
    }
  }

  String get emoji {
    switch (this) {
      case CardResult.win:
        return '🏆';
      case CardResult.bonus:
        return '💎';
      case CardResult.empty:
        return '💔';
      case CardResult.multiplier:
        return '⚡';
      case CardResult.extraLife:
        return '❤️';
      case CardResult.timeBonus:
        return '⏰';
      case CardResult.coinBonus:
        return '🪙';
      case CardResult.trap:
        return '💀';
      case CardResult.mystery:
        return '❓';
    }
  }

  String get description {
    switch (this) {
      case CardResult.win:
        return 'You won the game!';
      case CardResult.bonus:
        return 'Bonus points earned!';
      case CardResult.empty:
        return 'Better luck next time!';
      case CardResult.multiplier:
        return 'Next win counts double!';
      case CardResult.extraLife:
        return 'You get another chance!';
      case CardResult.timeBonus:
        return 'Extra time added!';
      case CardResult.coinBonus:
        return 'Bonus coins earned!';
      case CardResult.trap:
        return 'You lose points!';
      case CardResult.mystery:
        return 'Random effect activated!';
    }
  }
}

enum GameState {
  idle,
  revealing,
  finished;
}