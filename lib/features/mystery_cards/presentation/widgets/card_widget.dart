import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/mystery_card.dart';
import '../../domain/enums/card_result.dart';
import '../../../../core/theme/app_theme.dart';

class CardWidget extends StatefulWidget {
  final MysteryCard card;
  final VoidCallback? onTap;
  final bool isInputBlocked;
  final bool shouldAnimateOthers;

  const CardWidget({
    super.key,
    required this.card,
    this.onTap,
    this.isInputBlocked = false,
    this.shouldAnimateOthers = false,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _scaleController;
  late AnimationController _opacityController;
  
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: Curves.easeInOut,
    ));

    // Set initial values
    _scaleController.value = 1.0;
    _opacityController.value = 1.0;
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle flip animation when card is revealed
    if (!oldWidget.card.isRevealed && widget.card.isRevealed) {
      _flipController.forward();
      
      // Trigger haptic feedback for selected card
      if (widget.card.isSelected) {
        HapticFeedback.mediumImpact();
      }
    }
    
    // Handle other cards animation when one is selected
    if (!oldWidget.shouldAnimateOthers && widget.shouldAnimateOthers && !widget.card.isSelected) {
      _scaleController.forward();
      _opacityController.forward();
    }
    
    // Reset animations for new game
    if (oldWidget.card.isRevealed && !widget.card.isRevealed) {
      _flipController.reset();
      _scaleController.reset();
      _opacityController.reset();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isInputBlocked || widget.card.isRevealed) return;
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _flipAnimation,
            _scaleAnimation,
            _opacityAnimation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: AspectRatio(
                  aspectRatio: 0.7, // Card aspect ratio
                  child: GestureDetector(
                    onTap: _handleTap,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 48, // Minimum touch area
                      ),
                      child: _buildCard(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard() {
    final isShowingBack = _flipAnimation.value > 0.5;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_flipAnimation.value * 3.14159),
      child: isShowingBack ? _buildCardBack() : _buildCardFront(),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.neonPurple, AppTheme.neonBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPurple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.help_outline,
                size: 48,
                color: AppTheme.textWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    final result = widget.card.result;
    Color backgroundColor;
    Color glowColor;
    
    switch (result) {
      case CardResult.win:
        backgroundColor = AppTheme.neonCyan;
        glowColor = AppTheme.neonCyan;
        break;
      case CardResult.bonus:
        backgroundColor = AppTheme.neonPurple;
        glowColor = AppTheme.neonPurple;
        break;
      case CardResult.multiplier:
        backgroundColor = AppTheme.neonBlue;
        glowColor = AppTheme.neonBlue;
        break;
      case CardResult.extraLife:
        backgroundColor = Colors.red;
        glowColor = Colors.red;
        break;
      case CardResult.timeBonus:
        backgroundColor = Colors.orange;
        glowColor = Colors.orange;
        break;
      case CardResult.coinBonus:
        backgroundColor = Colors.yellow;
        glowColor = Colors.yellow;
        break;
      case CardResult.trap:
        backgroundColor = Colors.red.shade800;
        glowColor = Colors.red.shade800;
        break;
      case CardResult.mystery:
        backgroundColor = Colors.purple;
        glowColor = Colors.purple;
        break;
      case CardResult.empty:
        backgroundColor = AppTheme.textGray;
        glowColor = AppTheme.textGray;
        break;
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159), // Flip back side
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    result.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.displayText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textWhite,
                      shadows: [
                        Shadow(
                          color: glowColor.withValues(alpha: 0.8),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}