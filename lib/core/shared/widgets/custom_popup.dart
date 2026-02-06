import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'custom_elevated_button.dart';
import 'custom_text.dart';

class CustomPopup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final bool barrierDismissible;

  const CustomPopup({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.barrierDismissible = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => CustomPopup(
        title: title,
        subtitle: subtitle,
        content: content,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.secondaryDark,
              AppTheme.secondaryDark.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.neonPurple.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonPurple.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppTheme.neonBlue.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.title(title),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                CustomText.body(subtitle!),
              ],
              if (content != null) ...[
                const SizedBox(height: 20),
                content!,
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NameInputPopup extends StatefulWidget {
  final String? initialName;
  final Function(String) onNameSubmitted;

  const NameInputPopup({
    super.key,
    this.initialName,
    required this.onNameSubmitted,
  });

  @override
  State<NameInputPopup> createState() => _NameInputPopupState();
}

class _NameInputPopupState extends State<NameInputPopup> {
  late TextEditingController _controller;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _isValid = _controller.text.trim().isNotEmpty;
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isValid = _controller.text.trim().isNotEmpty;
    });
  }

  void _submit() {
    if (_isValid) {
      widget.onNameSubmitted(_controller.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      title: widget.initialName == null ? 'Welcome!' : 'Change Name',
      subtitle: widget.initialName == null 
          ? 'Enter your name to start playing'
          : 'Enter a new name',
      barrierDismissible: widget.initialName != null,
      content: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid ? AppTheme.neonCyan : AppTheme.textGray,
                width: 2,
              ),
            ),
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                hintText: 'Your name',
                hintStyle: TextStyle(color: AppTheme.textGray),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
        ],
      ),
      actions: [
        if (widget.initialName != null)
          CustomElevatedButton(
            text: 'Cancel',
            backgroundColor: AppTheme.textGray,
            width: 120,
            height: 50,
            onPressed: () => Navigator.of(context).pop(),
          ),
        CustomElevatedButton(
          text: widget.initialName == null ? 'Start' : 'Save',
          width: 120,
          height: 50,
          onPressed: _isValid ? _submit : null,
        ),
      ],
    );
  }
}