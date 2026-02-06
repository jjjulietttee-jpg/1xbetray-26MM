import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? glowColor;
  final double? glowRadius;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.glowColor,
    this.glowRadius,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  const CustomText.heading(
    this.text, {
    super.key,
    this.glowColor = AppTheme.neonPurple,
    this.glowRadius = 8.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppTheme.textWhite,
          height: 1.2,
        );

  const CustomText.title(
    this.text, {
    super.key,
    this.glowColor = AppTheme.neonBlue,
    this.glowRadius = 6.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppTheme.textWhite,
          height: 1.2,
        );

  const CustomText.body(
    this.text, {
    super.key,
    this.glowColor,
    this.glowRadius = 2.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = const TextStyle(
          fontSize: 20,
          color: AppTheme.textWhite,
          height: 1.4,
        );

  const CustomText.large(
    this.text, {
    super.key,
    this.glowColor = AppTheme.neonCyan,
    this.glowRadius = 12.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: AppTheme.textWhite,
          height: 1.2,
        );

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    
    return Text(
      text,
      style: effectiveStyle.copyWith(
        shadows: [
          if (glowColor != null && glowRadius != null)
            Shadow(
              offset: const Offset(0, 0),
              blurRadius: glowRadius!,
              color: glowColor!.withValues(alpha: 0.8),
            ),
          Shadow(
            offset: Offset(0, effectiveStyle.fontSize! * 0.05),
            blurRadius: effectiveStyle.fontSize! * 0.1,
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ],
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}