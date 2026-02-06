import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/game_mode.dart';
import '../../../../core/services/simple_game_manager.dart';

class GameModesScreen extends StatefulWidget {
  const GameModesScreen({super.key});

  @override
  State<GameModesScreen> createState() => _GameModesScreenState();
}

class _GameModesScreenState extends State<GameModesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  GameMode? _selectedMode;
  int _selectedCardCount = 5;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectMode(GameMode mode) {
    setState(() {
      _selectedMode = mode;
      _selectedCardCount = mode.minCards;
    });
  }

  void _startGame() {
    if (_selectedMode == null) return;

    final gameManager = SimpleGameManager();
    gameManager.startNewGame(_selectedMode!, _selectedCardCount);
    
    context.go('/mystery-cards');
  }

  @override
  Widget build(BuildContext context) {
    final gameModes = GameMode.getAllModes();

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
            color: AppTheme.primaryDark.withValues(alpha: 0.7),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textWhite,
                          size: 28,
                        ),
                        onPressed: () => context.go('/home'),
                      ),
                      const Expanded(
                        child: Center(
                          child: CustomText.heading(
                            'Game Modes',
                            glowColor: AppTheme.neonPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Game modes list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Mode selection
                        ...gameModes.asMap().entries.map((entry) {
                          final index = entry.key;
                          final mode = entry.value;
                          
                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final animationValue = Curves.easeOutBack.transform(
                                (_animationController.value - (index * 0.1)).clamp(0.0, 1.0),
                              ).clamp(0.0, 1.0); // Clamp the result to ensure valid opacity range
                              
                              return Transform.translate(
                                offset: Offset(0, 50 * (1 - animationValue)),
                                child: Opacity(
                                  opacity: animationValue,
                                  child: _buildModeCard(mode),
                                ),
                              );
                            },
                          );
                        }),

                        const SizedBox(height: 20),

                        // Card count selector (if mode selected)
                        if (_selectedMode != null) ...[
                          _buildCardCountSelector(),
                          const SizedBox(height: 20),
                        ],

                        // Start game button
                        if (_selectedMode != null)
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final animationValue = Curves.elasticOut.transform(
                                (_animationController.value - 0.8).clamp(0.0, 1.0),
                              ).clamp(0.0, 1.0); // Clamp to ensure valid scale range
                              
                              return Transform.scale(
                                scale: animationValue,
                                child: CustomElevatedButton(
                                  text: 'Start Game',
                                  backgroundColor: _selectedMode!.color,
                                  onPressed: _startGame,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(GameMode mode) {
    final isSelected = _selectedMode?.type == mode.type;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _selectMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.secondaryDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? mode.color
                  : mode.color.withValues(alpha: 0.3),
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: mode.color.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: mode.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: mode.color,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      mode.icon,
                      color: mode.color,
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          mode.name,
                          glowColor: isSelected ? mode.color : null,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mode.description,
                          style: TextStyle(
                            color: AppTheme.textGray.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: mode.color,
                      size: 24,
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Mode features
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFeatureChip(
                    '${mode.minCards}-${mode.maxCards} Cards',
                    Icons.style,
                    mode.color,
                  ),
                  if (mode.hasTimer)
                    _buildFeatureChip(
                      '${mode.timeLimit}s Timer',
                      Icons.timer,
                      mode.color,
                    ),
                  if (mode.hasMultiplier)
                    _buildFeatureChip(
                      'Multipliers',
                      Icons.trending_up,
                      mode.color,
                    ),
                  if (mode.hasSequence)
                    _buildFeatureChip(
                      'Sequence',
                      Icons.format_list_numbered,
                      mode.color,
                    ),
                  _buildFeatureChip(
                    '${mode.baseXP} XP',
                    Icons.star,
                    mode.color,
                  ),
                  _buildFeatureChip(
                    '${mode.baseCoins} Coins',
                    Icons.monetization_on,
                    mode.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCountSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedMode!.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                color: _selectedMode!.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              CustomText.title(
                'Number of Cards',
                glowColor: _selectedMode!.color,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: List.generate(
              _selectedMode!.maxCards - _selectedMode!.minCards + 1,
              (index) {
                final count = _selectedMode!.minCards + index;
                final isSelected = _selectedCardCount == count;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCardCount = count;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedMode!.color : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedMode!.color,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? AppTheme.primaryDark : _selectedMode!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}