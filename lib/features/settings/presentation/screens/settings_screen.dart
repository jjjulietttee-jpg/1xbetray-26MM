import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedDifficulty = 'normal';
  double _animationSpeed = 1.0;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    UserPreferences.unlockAchievement('settings_explorer');
    StorageService.addAchievementCompleted('settings_explorer');
  }

  void _loadSettings() {
    setState(() {
      _selectedDifficulty = UserPreferences.gameDifficulty;
      _animationSpeed = UserPreferences.cardAnimationSpeed;
      _soundEnabled = UserPreferences.soundEnabled;
      _vibrationEnabled = UserPreferences.vibrationEnabled;
    });
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
                            'Settings',
                            glowColor: AppTheme.neonPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                
                // Settings content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game Settings Section
                        _buildSectionHeader('Game Settings', Icons.games),
                        const SizedBox(height: 16),
                        
                        _buildSettingsCard([
                          _buildDifficultySelector(),
                          const Divider(color: AppTheme.textGray),
                          _buildAnimationSpeedSlider(),
                        ]),
                        
                        const SizedBox(height: 24),
                        
                        // Audio & Haptics Section
                        _buildSectionHeader('Audio & Haptics', Icons.volume_up),
                        const SizedBox(height: 16),
                        
                        _buildSettingsCard([
                          _buildSwitchTile(
                            'Sound Effects',
                            'Enable game sound effects',
                            Icons.volume_up,
                            _soundEnabled,
                            (value) async {
                              setState(() {
                                _soundEnabled = value;
                              });
                              await UserPreferences.setSoundEnabled(value);
                            },
                          ),
                          const Divider(color: AppTheme.textGray),
                          _buildSwitchTile(
                            'Vibration',
                            'Enable haptic feedback',
                            Icons.vibration,
                            _vibrationEnabled,
                            (value) async {
                              setState(() {
                                _vibrationEnabled = value;
                              });
                              await UserPreferences.setVibrationEnabled(value);
                            },
                          ),
                        ]),
                        
                        const SizedBox(height: 24),
                        
                        // About Section
                        _buildSectionHeader('About', Icons.info),
                        const SizedBox(height: 16),
                        
                        _buildSettingsCard([
                          _buildInfoTile('Version', '1.0.0', Icons.info),
                          const Divider(color: AppTheme.textGray),
                          _buildInfoTile('Developer', 'Neon Games', Icons.code),
                        ]),
                        
                        const SizedBox(height: 40),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.neonCyan,
          size: 24,
        ),
        const SizedBox(width: 12),
        CustomText.title(
          title,
          glowColor: AppTheme.neonCyan,
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune,
                color: AppTheme.neonPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              const CustomText.body('Game Difficulty'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDifficultyChip('Easy', 'easy'),
              const SizedBox(width: 8),
              _buildDifficultyChip('Normal', 'normal'),
              const SizedBox(width: 8),
              _buildDifficultyChip('Hard', 'hard'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String label, String value) {
    final isSelected = _selectedDifficulty == value;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _selectedDifficulty = value;
          });
          await UserPreferences.setGameDifficulty(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.neonPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.neonPurple,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryDark : AppTheme.neonPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationSpeedSlider() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.speed,
                color: AppTheme.neonBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              const CustomText.body('Animation Speed'),
              const Spacer(),
              CustomText.body(
                '${(_animationSpeed * 100).round()}%',
                glowColor: AppTheme.neonBlue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.neonBlue,
              inactiveTrackColor: AppTheme.textGray.withValues(alpha: 0.3),
              thumbColor: AppTheme.neonBlue,
              overlayColor: AppTheme.neonBlue.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _animationSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              onChanged: (value) {
                setState(() {
                  _animationSpeed = value;
                });
              },
              onChangeEnd: (value) async {
                await UserPreferences.setCardAnimationSpeed(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.neonCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.body(title),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textGray.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.neonCyan,
            activeTrackColor: AppTheme.neonCyan.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textGray,
            inactiveTrackColor: AppTheme.textGray.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.neonPurple,
            size: 20,
          ),
          const SizedBox(width: 12),
          CustomText.body(title),
          const Spacer(),
          CustomText.body(
            value,
            glowColor: AppTheme.neonPurple,
          ),
        ],
      ),
    );
  }
}