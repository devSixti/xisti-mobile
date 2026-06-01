import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'custom_rounded_button.dart';

/// Large static CTA for driver flows (replaces slide-to-confirm).
class PrimaryActionButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final VoidCallback onPressed;
  final bool setProgress;
  final bool requireConfirmation;

  const PrimaryActionButton({
    super.key,
    required this.context,
    required this.text,
    required this.onPressed,
    this.setProgress = false,
    this.requireConfirmation = true,
  });

  Future<void> _handleTap() async {
    if (!requireConfirmation) {
      onPressed();
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(languages.confirm),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(languages.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(languages.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRoundedButton(
      context,
      text,
      setProgress ? null : () => _handleTap(),
      setProgress: setProgress,
      minHeight: accessibleActionButtonHeight,
      textSize: accessibleTitleSize,
      fontWeight: FontWeight.w700,
      padding: EdgeInsetsDirectional.symmetric(vertical: 14.h, horizontal: 20.w),
    );
  }
}
