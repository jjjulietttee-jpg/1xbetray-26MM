import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/models/mystery_card.dart';
import '../../domain/enums/card_result.dart';
import '../../../../core/models/game_session.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';

class ResultOverlay extends StatefulWidget {
  final MysteryCard selectedCard;
  final GameSession gameSession;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const ResultOverlay({
    super.key,
    required this.selectedCard,
    required this.gameSession,
    required this.onPlayAgain,
    required this.onClose,
  });

  @override
  State<ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<ResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _resultColor {
    switch (widget.selectedCard.result) {
      case CardResult.win:
        return AppTheme.neonCyan;
      case CardResult.bonus:
        return AppTheme.neonPurple;
      case CardResult.multiplier:
        return AppTheme.neonBlue;
      case CardResult.extraLife:
        return Colors.red;
      case CardResult.timeBonus:
        return Colors.orange;
      case CardResult.coinBonus:
        return Colors.yellow;
      case CardResult.trap:
        return Colors.red;
      case CardResult.mystery:
        return Colors.purple;
      case CardResult.empty:
        return AppTheme.textGray;
    }
  }

  String get _resultMessage {
    switch (widget.selectedCard.result) {
      case CardResult.win:
        return 'Congratulations!\nYou won the game!';
      case CardResult.bonus:
        return 'Great job!\nYou earned bonus points!';
      case CardResult.multiplier:
        return 'Awesome!\nYour multiplier increased!';
      case CardResult.extraLife:
        return 'Lucky you!\nYou gained an extra life!';
      case CardResult.timeBonus:
        return 'Time bonus!\nExtra seconds added!';
      case CardResult.coinBonus:
        return 'Coin bonus!\nExtra coins earned!';
      case CardResult.trap:
        return 'Oh no!\nYou hit a trap!';
      case CardResult.mystery:
        return 'Mystery card!\nRandom effect activated!';
      case CardResult.empty:
        return 'Better luck next time!\nTry again to win!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            color: Colors.black.withValues(alpha: 0.8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildResultCard(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.9;
        
        return Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth.clamp(300.0, 500.0),
            minHeight: 200,
          ),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryDark,
                AppTheme.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: _resultColor.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _resultColor.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Result emoji
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _resultColor.withValues(alpha: 0.2),
                          border: Border.all(
                            color: _resultColor.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.selectedCard.result.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Result title
                      CustomText.heading(
                        widget.selectedCard.result.displayText,
                        glowColor: _resultColor,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Result message
                      Text(
                        _resultMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textWhite,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Game stats
                      _buildGameStats(),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _resultColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomText.title(
            'Game Summary',
            glowColor: _resultColor,
          ),
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Score', widget.gameSession.score.toString(), Icons.star),
              _buildStatItem('XP', widget.gameSession.xp.toString(), Icons.trending_up),
              _buildStatItem('Coins', widget.gameSession.coins.toString(), Icons.monetization_on),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Mode', widget.gameSession.gameMode.name, Icons.gamepad),
              _buildStatItem('Time', '${widget.gameSession.gameDuration.inSeconds}s', Icons.timer),
              _buildStatItem('Result', widget.gameSession.isWon ? 'WIN' : 'LOSS', 
                  widget.gameSession.isWon ? Icons.check_circle : Icons.cancel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: _resultColor,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: _resultColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGray,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(
            text: 'Play Again',
            icon: Icons.refresh,
            backgroundColor: _resultColor,
            onPressed: widget.onPlayAgain,
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: CustomElevatedButton(
            text: 'Game Modes',
            icon: Icons.gamepad,
            backgroundColor: AppTheme.textGray,
            onPressed: widget.onClose,
          ),
        ),
      ],
    );
  }
}