import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CardWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool showGlow;

  const CardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.showGlow = true,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      // _isHovered = isHovered; // Removed unused field
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin ?? const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.backgroundColor ?? AppTheme.secondaryDark,
                  (widget.backgroundColor ?? AppTheme.secondaryDark).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor ?? 
                    AppTheme.neonPurple.withOpacity(_glowAnimation.value),
                width: 2,
              ),
              boxShadow: widget.showGlow
                  ? [
                      BoxShadow(
                        color: (widget.borderColor ?? AppTheme.neonPurple)
                            .withOpacity(_glowAnimation.value * 0.5),
                        blurRadius: 12 + (8 * _glowAnimation.value),
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: (widget.borderColor ?? AppTheme.neonPurple)
                            .withOpacity(_glowAnimation.value * 0.3),
                        blurRadius: 20 + (10 * _glowAnimation.value),
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onHover: _onHover,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      borderColor: isUnlocked ? AppTheme.neonCyan : AppTheme.textGray,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isUnlocked 
                  ? AppTheme.neonCyan.withOpacity(0.2)
                  : AppTheme.textGray.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isUnlocked ? AppTheme.neonCyan : AppTheme.textGray,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? AppTheme.textWhite : AppTheme.textGray,
                    shadows: isUnlocked
                        ? [
                            const Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: AppTheme.neonCyan,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked 
                        ? AppTheme.textGray 
                        : AppTheme.textGray.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(
              Icons.check_circle,
              color: AppTheme.neonCyan,
              size: 24,
            ),
        ],
      ),
    );
  }
}