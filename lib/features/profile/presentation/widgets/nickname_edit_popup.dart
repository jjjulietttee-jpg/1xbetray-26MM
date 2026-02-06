import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';

/// Popup to edit nickname. [onSave] is awaited before closing — данные сохраняются сразу.
class NicknameEditPopup extends StatefulWidget {
  const NicknameEditPopup({
    super.key,
    required this.initialName,
    required this.onSave,
    this.onSkip,
    this.title = 'Change nickname',
    this.subtitle = 'Enter your player name',
  });

  final String initialName;
  final Future<void> Function(String name) onSave;
  final VoidCallback? onSkip;
  final String title;
  final String subtitle;

  @override
  State<NicknameEditPopup> createState() => _NicknameEditPopupState();
}

class _NicknameEditPopupState extends State<NicknameEditPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  final TextEditingController _text = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final name = widget.initialName.trim();
    _text.text = (name.isEmpty || name == 'Player') ? '' : name;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final n = _text.text.trim();
    if (n.isEmpty) return;
    if (!mounted) return;
    setState(() => _loading = true);
    await widget.onSave(n);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _loading = false);
      if (!mounted) return;
      await _controller.reverse();
      if (!mounted) return;
      if (!context.mounted) return;
      Navigator.of(context).pop();
    });
  }

  Future<void> _skip() async {
    await _controller.reverse();
    if (!mounted) return;
    widget.onSkip?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: Opacity(
                  opacity: _opacity.value,
                  child: child,
                ),
              );
            },
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
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.neonPurple, AppTheme.neonCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.person, color: AppTheme.textWhite, size: 32),
                  ),
                  const SizedBox(height: 16),
                  CustomText.heading(widget.title, glowColor: AppTheme.neonPurple),
                  const SizedBox(height: 8),
                  CustomText.body(widget.subtitle, glowColor: AppTheme.neonCyan),
                  const SizedBox(height: 20),
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
                      controller: _text,
                      style: const TextStyle(color: AppTheme.textWhite, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Nickname',
                        hintStyle: TextStyle(color: AppTheme.textGray.withValues(alpha: 0.7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      maxLength: 24,
                      textAlign: TextAlign.center,
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (widget.onSkip != null) ...[
                        Expanded(
                          child: CustomElevatedButton(
                            text: 'Skip',
                            backgroundColor: AppTheme.textGray,
                            onPressed: _loading ? null : _skip,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: CustomElevatedButton(
                          text: _loading ? 'Saving...' : 'Save',
                          backgroundColor: AppTheme.neonPurple,
                          onPressed: _loading ? null : _submit,
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
}
