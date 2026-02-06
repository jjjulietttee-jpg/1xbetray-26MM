import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/username_popup.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/game_manager.dart';

class SimpleProfileScreen extends StatefulWidget {
  const SimpleProfileScreen({super.key});

  @override
  State<SimpleProfileScreen> createState() => _SimpleProfileScreenState();
}

class _SimpleProfileScreenState extends State<SimpleProfileScreen> {
  bool _showUsernamePopup = false;
  late GameManager _gameManager;
  
  // Demo profile data (since UserProfile is temporarily disabled)
  String _username = 'Demo Player';
  int _level = 8;
  int _xp = 750;
  int _gamesPlayed = 45;
  int _gamesWon = 32;
  int _coins = 450;
  int _highestScore = 850;
  int _currentStreak = 3;
  int _longestStreak = 7;
  int _totalPlayTime = 5400; // in seconds

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager();
    
    // Load demo data for testing
    _gameManager.loadDemoData();
    
    _checkFirstTime();
  }

  void _checkFirstTime() {
    // Show username popup if username is still default
    if (_username == 'Player' || _username == 'Demo Player') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showUsernamePopup = true;
        });
      });
    }
  }

  void _onUsernamePopupComplete() {
    setState(() {
      _showUsernamePopup = false;
      // Update username from popup if needed
      _username = 'Player'; // This would be updated from the popup
    });
  }

  // Computed properties (mimicking UserProfile)
  int get _xpForCurrentLevel => (_level - 1) * 100;
  int get _xpForNextLevel => _level * 100;
  int get _currentLevelXP => _xp - _xpForCurrentLevel;
  int get _xpToNextLevel => _xpForNextLevel - _xp;
  double get _levelProgress => _currentLevelXP / 100.0;
  double get _winRate => _gamesPlayed > 0 ? _gamesWon / _gamesPlayed : 0.0;
  
  String get _rankTitle {
    if (_level < 5) return 'Novice';
    if (_level < 10) return 'Explorer';
    if (_level < 20) return 'Adventurer';
    if (_level < 35) return 'Expert';
    if (_level < 50) return 'Master';
    if (_level < 75) return 'Legend';
    return 'Grandmaster';
  }

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppTheme.textWhite,
                            ),
                            onPressed: () => context.go('/home'),
                          ),
                          const Expanded(
                            child: Center(
                              child: CustomText.title(
                                'Profile',
                                glowColor: AppTheme.neonPurple,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: AppTheme.textWhite,
                            ),
                            onPressed: () => context.go('/settings'),
                          ),
                        ],
                      ),
                    ),
                    
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Profile Header
                            _buildProfileHeader(),
                            
                            const SizedBox(height: 20),
                            
                            // Stats Grid
                            _buildStatsGrid(),
                            
                            const SizedBox(height: 20),
                            
                            // Rank and Progress
                            _buildRankSection(),
                            
                            const SizedBox(height: 30),
                            
                            // Action buttons
                            _buildActionButtons(),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Username popup overlay
                if (_showUsernamePopup)
                  UsernamePopup(
                    onComplete: _onUsernamePopupComplete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonPurple.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPurple.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with rank indicator
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonPurple,
                      AppTheme.neonCyan,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPurple.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppTheme.textWhite,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.neonCyan,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryDark, width: 2),
                  ),
                  child: Text(
                    '$_level',
                    style: const TextStyle(
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Username with edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: CustomText.heading(
                  _username,
                  glowColor: AppTheme.neonCyan,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showUsernamePopup = true;
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: AppTheme.neonCyan.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Rank title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.neonPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.neonPurple.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              _rankTitle,
              style: const TextStyle(
                color: AppTheme.neonPurple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // XP Progress bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $_level',
                    style: const TextStyle(
                      color: AppTheme.neonCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Level ${_level + 1}',
                    style: const TextStyle(
                      color: AppTheme.neonCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: _levelProgress,
                backgroundColor: AppTheme.textGray.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              Text(
                '$_currentLevelXP / 100 XP ($_xpToNextLevel to next level)',
                style: TextStyle(
                  color: AppTheme.textGray.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Games Played',
          _gamesPlayed.toString(),
          Icons.gamepad,
          AppTheme.neonBlue,
        ),
        _buildStatCard(
          'Games Won',
          _gamesWon.toString(),
          Icons.emoji_events,
          AppTheme.neonCyan,
        ),
        _buildStatCard(
          'Win Rate',
          '${(_winRate * 100).toStringAsFixed(1)}%',
          Icons.trending_up,
          AppTheme.neonPurple,
        ),
        _buildStatCard(
          'Coins',
          _coins.toString(),
          Icons.monetization_on,
          Colors.yellow,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          CustomText.title(
            value,
            glowColor: color,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textGray,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRankSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.military_tech,
                color: AppTheme.neonBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              const CustomText.title(
                'Player Stats',
                glowColor: AppTheme.neonBlue,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildStatRow('Highest Score', _highestScore.toString()),
          const SizedBox(height: 8),
          _buildStatRow('Current Streak', _currentStreak.toString()),
          const SizedBox(height: 8),
          _buildStatRow('Longest Streak', _longestStreak.toString()),
          const SizedBox(height: 8),
          _buildStatRow('Total XP', _xp.toString()),
          const SizedBox(height: 8),
          _buildStatRow('Play Time', '${(_totalPlayTime / 60).toStringAsFixed(1)} min'),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomElevatedButton(
          text: 'View Statistics',
          backgroundColor: AppTheme.neonBlue,
          onPressed: () => context.go('/statistics'),
        ),
        
        const SizedBox(height: 16),
        
        CustomElevatedButton(
          text: 'View Achievements',
          backgroundColor: AppTheme.neonCyan,
          onPressed: () => context.go('/achievements'),
        ),
        
        const SizedBox(height: 16),
        
        CustomElevatedButton(
          text: 'Settings',
          backgroundColor: AppTheme.neonPurple,
          onPressed: () => context.go('/settings'),
        ),
        
        const SizedBox(height: 16),
        
        CustomElevatedButton(
          text: 'Back to Home',
          backgroundColor: AppTheme.textGray,
          onPressed: () => context.go('/home'),
        ),
      ],
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.body(label),
        CustomText.title(
          value,
          glowColor: AppTheme.neonCyan,
        ),
      ],
    );
  }
}
