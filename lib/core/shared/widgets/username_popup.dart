import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/game_manager.dart';
import 'custom_text.dart';
import 'custom_elevated_button.dart';

class UsernamePopup extends StatefulWidget {
  final VoidCallback onComplete;

  const UsernamePopup({
    super.key,
    required this.onComplete,
  });

  @override
  State<UsernamePopup> createState() => _UsernamePopupState();
}

class _UsernamePopupState extends State<UsernamePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  final TextEditingController _usernameController = TextEditingController();
  late GameManager _gameManager;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
    
    // Pre-fill with current username if exists
    _usernameController.text = 'Player'; // _gameManager.userProfile.username;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Update username in GameManager
    _gameManager.updateUsername(username);
    
    // Unlock profile setup achievement
    // _gameManager.userProfile.unlockAchievement('profile_setup');

    setState(() {
      _isLoading = false;
    });

    // Close popup with animation
    await _animationController.reverse();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.neonPurple.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.neonPurple.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
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
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_add,
                            size: 40,
                            color: AppTheme.textWhite,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Title
                        const CustomText.heading(
                          'Welcome to Neon Vault!',
                          textAlign: TextAlign.center,
                          glowColor: AppTheme.neonPurple,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Subtitle
                        const CustomText.body(
                          'Choose your player name to get started',
                          textAlign: TextAlign.center,
                          glowColor: AppTheme.neonCyan,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Username input
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.neonCyan.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: AppTheme.textWhite,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your username',
                              hintStyle: TextStyle(
                                color: AppTheme.textGray.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: AppTheme.neonCyan,
                              ),
                            ),
                            maxLength: 20,
                            textAlign: TextAlign.center,
                            onSubmitted: (_) => _saveUsername(),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                text: 'Skip',
                                backgroundColor: AppTheme.textGray,
                                onPressed: _isLoading ? null : () async {
                                  await _animationController.reverse();
                                  widget.onComplete();
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomElevatedButton(
                                text: _isLoading ? 'Saving...' : 'Save',
                                backgroundColor: AppTheme.neonPurple,
                                onPressed: _isLoading ? null : _saveUsername,
                                icon: _isLoading ? null : Icons.check,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}