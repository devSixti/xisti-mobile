import 'package:flutter/material.dart';

import 'primary_action_button.dart';

/// Deprecated: slide-to-confirm replaced by static [PrimaryActionButton].
class SliderAnimationButton extends StatelessWidget {
  final bool setProgress;
  final String text;
  final Function() onAction;

  const SliderAnimationButton({
    super.key,
    this.setProgress = false,
    required this.text,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      context: context,
      text: text,
      setProgress: setProgress,
      onPressed: onAction,
    );
  }
}
