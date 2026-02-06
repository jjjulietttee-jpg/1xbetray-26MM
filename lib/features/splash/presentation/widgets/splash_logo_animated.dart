import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';

/// Animated logo: fade, scale, subtle slide over [duration].
class SplashLogoAnimated extends StatefulWidget {
  const SplashLogoAnimated({
    super.key,
    this.duration = const Duration(seconds: 2),
  });

  final Duration duration;

  @override
  State<SplashLogoAnimated> createState() => _SplashLogoAnimatedState();
}

class _SplashLogoAnimatedState extends State<SplashLogoAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 24),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText.large(
            'NEON VAULT',
            glowColor: AppTheme.neonPurple,
            glowRadius: 20,
          ),
          const SizedBox(height: 12),
          CustomText.body(
            'Ready to play',
            glowColor: AppTheme.neonCyan,
            glowRadius: 4,
          ),
        ],
      ),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: SlideTransition(
              position: _slide,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
