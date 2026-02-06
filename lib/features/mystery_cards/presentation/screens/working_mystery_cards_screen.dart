import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/services/simple_game_manager.dart';
import '../../../../core/models/game_session.dart';

class WorkingMysteryCardsScreen extends StatefulWidget {
  const WorkingMysteryCardsScreen({super.key});

  @override
  State<WorkingMysteryCardsScreen> createState() =>
      _WorkingMysteryCardsScreenState();
}

class _WorkingMysteryCardsScreenState extends State<WorkingMysteryCardsScreen>
    with TickerProviderStateMixin {
  late SimpleGameManager _gameManager;
  GameSession? _currentSession;
  late AnimationController _animationController;
  late AnimationController _cardFlipController;
  bool _isGameFinished = false;
  int? _selectedCardIndex;
  bool _showCardResult = false;
  bool _showResultOverlay = false;
  List<String> _cardResults = [];
  final Set<int> _revealedCardIndices = {};
  String? _gameEndResult;

  @override
  void initState() {
    super.initState();
    _gameManager = SimpleGameManager();
    _currentSession = _gameManager.currentSession;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardFlipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    if (_currentSession == null) {
      // If no session exists, go back to game modes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/game-modes');
      });
      return;
    }

    // Initialize card results (simplified version)
    _initializeCards();
    _animationController.forward();
  }

  void _initializeCards() {
    final cardCount = _currentSession?.cardCount ?? 5;
    _cardResults = List.generate(cardCount, (index) => 'empty');

    // Set one WIN card and one BONUS card, rest are EMPTY
    final winIndex = (cardCount * 0.3).round();
    final bonusIndex = (cardCount * 0.7).round();

    _cardResults[winIndex] = 'win';
    _cardResults[bonusIndex] = 'bonus';

    // Shuffle the results
    _cardResults.shuffle();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardFlipController.dispose();
    super.dispose();
  }

  void _selectCard(int index) {
    if (_isGameFinished ||
        _selectedCardIndex != null ||
        _revealedCardIndices.contains(index)) return;

    setState(() {
      _selectedCardIndex = index;
    });

    _cardFlipController.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _showCardResult = true;
        _revealedCardIndices.add(index);
      });

      Future.delayed(const Duration(milliseconds: 800), () async {
        if (!mounted) return;
        final result = _cardResults[_selectedCardIndex!];
        final session = _currentSession!;
        final baseXP = session.gameMode.baseXP;

        if (result == 'win') {
          session.score += 100;
          await _gameManager.completeCurrentGame(
              isWon: true, score: session.score, xp: baseXP);
          if (!mounted) return;
          setState(() {
            _gameEndResult = 'win';
            _isGameFinished = true;
            _showResultOverlay = true;
          });
          return;
        }

        if (result == 'empty') {
          session.lives = (session.lives - 1).clamp(0, 10);
          if (session.lives <= 0) {
            await _gameManager.completeCurrentGame(
              isWon: false,
              score: session.score,
              xp: (baseXP * 0.3).round(),
            );
            if (!mounted) return;
            setState(() {
              _gameEndResult = 'lose';
              _isGameFinished = true;
              _showResultOverlay = true;
            });
            return;
          }
        } else if (result == 'bonus') {
          session.score += 50;
        }

        if (!mounted) return;
        setState(() {
          _selectedCardIndex = null;
          _showCardResult = false;
        });
        _cardFlipController.reset();
      });
    });
  }

  void _startNewGame() {
    if (_currentSession == null) return;

    final newSession = _gameManager.startNewGame(
      _currentSession!.gameMode,
      _currentSession!.cardCount,
    );

    setState(() {
      _currentSession = newSession;
      _isGameFinished = false;
      _selectedCardIndex = null;
      _showCardResult = false;
      _showResultOverlay = false;
      _revealedCardIndices.clear();
      _gameEndResult = null;
    });

    _initializeCards();
    _animationController.reset();
    _cardFlipController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSession == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.neonPurple),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                _currentSession!.gameMode.color.withValues(alpha: 0.3),
                AppTheme.primaryDark.withValues(alpha: 0.8),
              ],
              center: Alignment.center,
              radius: 1.2,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Main game content
                _buildGameContent(),

                // Result overlay
                if (_showResultOverlay) _buildResultOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    return Column(
      children: [
        // Header
        _buildHeader(),

        // Game stats
        _buildGameStats(),

        // Game area
        Expanded(
          child: _buildGameArea(),
        ),

        // Instructions
        _buildInstructions(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textWhite,
              size: 28,
            ),
            onPressed: () => context.go('/game-modes'),
          ),
          Expanded(
            child: Column(
              children: [
                CustomText.heading(
                  _currentSession!.gameMode.name,
                  glowColor: _currentSession!.gameMode.color,
                ),
                const SizedBox(height: 4),
                Text(
                  _currentSession!.gameMode.description,
                  style: const TextStyle(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGameStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentSession!.gameMode.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Score', _currentSession!.score.toString(), Icons.star),
          _buildStatItem(
              'Lives', _currentSession!.lives.toString(), Icons.favorite),
          _buildStatItem('Multiplier', '${_currentSession!.multiplier}x',
              Icons.trending_up),
          _buildStatItem('Coins', _currentSession!.coins.toString(),
              Icons.monetization_on),
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
          color: _currentSession!.gameMode.color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: _currentSession!.gameMode.color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildGameArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth * 0.9;
          final maxH = constraints.maxHeight * 0.95;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
                child: _buildCardsGrid(maxWidth: maxW, maxHeight: maxH),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardsGrid({double maxWidth = 400, double maxHeight = 400}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return _buildCardsLayout(maxWidth: maxWidth, maxHeight: maxHeight);
      },
    );
  }

  Widget _buildCardsLayout({double maxWidth = 400, double maxHeight = 400}) {
    final cardCount = _cardResults.length;
    const rowSpacing = 16.0;
    const minCardHeight = 80.0;

    if (cardCount <= 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(cardCount, (index) {
          return Flexible(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: (maxWidth / cardCount).clamp(60.0, 120.0)),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildAnimatedCard(index, null),
            ),
          );
        }),
      );
    } else if (cardCount <= 6) {
      final topRowCount = (cardCount / 2).ceil();
      final bottomRowCount = cardCount - topRowCount;
      final maxCardsPerRow =
          topRowCount > bottomRowCount ? topRowCount : bottomRowCount;
      final cardHeight = (maxHeight - rowSpacing) / 2;
      final effectiveCardHeight = cardHeight.clamp(minCardHeight, 140.0);
      final cardWidth = (maxWidth / maxCardsPerRow).clamp(50.0, 100.0);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(topRowCount, (index) {
              return Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildAnimatedCard(index, effectiveCardHeight),
                ),
              );
            }),
          ),
          SizedBox(height: rowSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(bottomRowCount, (index) {
              final cardIndex = index + topRowCount;
              return Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildAnimatedCard(cardIndex, effectiveCardHeight),
                ),
              );
            }),
          ),
        ],
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: cardCount,
        itemBuilder: (context, index) {
          return _buildAnimatedCard(index, null);
        },
      );
    }
  }

  Widget _buildAnimatedCard(int index, double? cardHeight) {
    final animationValue = Curves.easeOutBack
        .transform(
          (_animationController.value - (index * 0.1)).clamp(0.0, 1.0),
        )
        .clamp(0.0, 1.0);

    final isSelected = _selectedCardIndex == index;
    final isRevealed =
        _revealedCardIndices.contains(index) || (isSelected && _showCardResult);
    final wasRevealedEarlier =
        _revealedCardIndices.contains(index) && !isSelected;

    Widget cardBody;
    if (wasRevealedEarlier) {
      cardBody = _buildRevealedCardFace(index, cardHeight);
    } else {
      cardBody = AnimatedBuilder(
        animation: _cardFlipController,
        builder: (context, child) {
          final flipValue = isSelected ? _cardFlipController.value : 0.0;
          final isShowingFront = flipValue < 0.5;
          const pi = 3.14159265359;
          double rotationY = flipValue * pi;
          Matrix4 transform = Matrix4.identity()..setEntry(3, 2, 0.001);
          Widget cardContent;
          if (isShowingFront) {
            transform.rotateY(rotationY);
            cardContent = Icon(
              Icons.help_outline,
              size: 40,
              color: AppTheme.textWhite.withValues(alpha: 0.7),
            );
          } else {
            transform.rotateY(rotationY + pi);
            cardContent = isRevealed
                ? _buildCardContent(index)
                : Icon(
                    Icons.help_outline,
                    size: 40,
                    color: AppTheme.textWhite.withValues(alpha: 0.7),
                  );
          }
          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              height: cardHeight ?? 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isSelected
                      ? [
                          _currentSession!.gameMode.color,
                          _currentSession!.gameMode.color.withValues(alpha: 0.7)
                        ]
                      : [AppTheme.secondaryDark, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isSelected
                      ? _currentSession!.gameMode.color
                      : AppTheme.textGray.withValues(alpha: 0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _currentSession!.gameMode.color
                              .withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Center(child: cardContent),
            ),
          );
        },
      );
    }

    return Transform.translate(
      offset: Offset(0, 50 * (1 - animationValue)),
      child: Opacity(
        opacity: animationValue,
        child: GestureDetector(
          onTap: _revealedCardIndices.contains(index)
              ? null
              : () => _selectCard(index),
          child: cardBody,
        ),
      ),
    );
  }

  Widget _buildRevealedCardFace(int index, double? cardHeight) {
    return Container(
      height: cardHeight ?? 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            _currentSession!.gameMode.color.withValues(alpha: 0.6),
            _currentSession!.gameMode.color.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: _currentSession!.gameMode.color.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: _buildCardContent(index, forceRevealed: true)),
    );
  }

  Widget _buildCardContent(int index, {bool forceRevealed = false}) {
    final result = _cardResults[index];
    final revealed = forceRevealed || _showCardResult;

    return AnimatedScale(
      scale: revealed ? 1.0 : 0.8,
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      child: AnimatedOpacity(
        opacity: revealed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: _getCardResultWidget(result),
      ),
    );
  }

  Widget _getCardResultWidget(String result) {
    switch (result) {
      case 'win':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonCyan.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppTheme.neonCyan,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.emoji_events,
                size: 32,
                color: AppTheme.neonCyan,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.neonCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.neonCyan.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                'WIN!',
                style: TextStyle(
                  color: AppTheme.neonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: AppTheme.neonCyan,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 'bonus':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neonPurple.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppTheme.neonPurple,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.star,
                size: 32,
                color: AppTheme.neonPurple,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.neonPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.neonPurple.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                'BONUS',
                style: TextStyle(
                  color: AppTheme.neonPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: AppTheme.neonPurple,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.textGray.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppTheme.textGray,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.close,
                size: 32,
                color: AppTheme.textGray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.textGray.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.textGray.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Text(
                'EMPTY',
                style: TextStyle(
                  color: AppTheme.textGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildInstructions() {
    String instructionText;
    Color instructionColor;

    if (_isGameFinished) {
      instructionText = 'Game finished! Check your result above.';
      instructionColor = AppTheme.neonBlue;
    } else {
      instructionText = 'Pick cards until you find WIN or run out of lives!';
      instructionColor = _currentSession!.gameMode.color;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomText.title(
            instructionText,
            textAlign: TextAlign.center,
            glowColor: instructionColor,
          ),
          if (!_isGameFinished) ...[
            const SizedBox(height: 16),
            Text(
              '1 WIN • 1 BONUS • EMPTY = lose 1 life',
              style: const TextStyle(
                color: AppTheme.textGray,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultOverlay() {
    final result = _gameEndResult ?? _cardResults[_selectedCardIndex ?? 0];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      color: Colors.black.withValues(alpha: _showResultOverlay ? 0.8 : 0.0),
      child: Center(
        child: AnimatedScale(
          scale: _showResultOverlay ? 1.0 : 0.8,
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          child: AnimatedOpacity(
            opacity: _showResultOverlay ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _currentSession!.gameMode.color.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        _currentSession!.gameMode.color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Result icon and text
                  _buildResultContent(result),

                  const SizedBox(height: 30),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'Play Again',
                          backgroundColor: _currentSession!.gameMode.color,
                          onPressed: _startNewGame,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'Game Modes',
                          backgroundColor: AppTheme.textGray,
                          onPressed: () => context.go('/game-modes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultContent(String result) {
    switch (result) {
      case 'win':
        return Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 80,
              color: AppTheme.neonCyan,
            ),
            const SizedBox(height: 20),
            const CustomText.heading(
              'Congratulations!',
              glowColor: AppTheme.neonCyan,
            ),
            const SizedBox(height: 10),
            const Text(
              'You won the game!',
              style: TextStyle(
                color: AppTheme.textWhite,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 'lose':
        return Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppTheme.textGray,
            ),
            const SizedBox(height: 20),
            const CustomText.heading(
              'Game Over',
              glowColor: AppTheme.textGray,
            ),
            const SizedBox(height: 10),
            const Text(
              'You ran out of lives. Try again!',
              style: TextStyle(
                color: AppTheme.textWhite,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 'bonus':
        return Column(
          children: [
            Icon(
              Icons.star,
              size: 80,
              color: AppTheme.neonPurple,
            ),
            const SizedBox(height: 20),
            const CustomText.heading(
              'Great Job!',
              glowColor: AppTheme.neonPurple,
            ),
            const SizedBox(height: 10),
            const Text(
              'You earned bonus points!',
              style: TextStyle(
                color: AppTheme.textWhite,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return Column(
          children: [
            Icon(
              Icons.sentiment_neutral,
              size: 80,
              color: AppTheme.textGray,
            ),
            const SizedBox(height: 20),
            const CustomText.heading(
              'Better Luck Next Time!',
              glowColor: AppTheme.textGray,
            ),
            const SizedBox(height: 10),
            const Text(
              'Try again to win!',
              style: TextStyle(
                color: AppTheme.textWhite,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }
}
