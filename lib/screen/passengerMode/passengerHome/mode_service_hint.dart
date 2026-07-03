import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_service_mode_presentation.dart';
import '../../../utils/xisti_ui_tokens.dart';

/// One-line mode hint below the context strip (legal / guidance copy).
class ModeServiceHint extends StatelessWidget {
  final String? mode;
  final String? apiDisclaimer;

  const ModeServiceHint({
    super.key,
    required this.mode,
    this.apiDisclaimer,
  });

  @override
  Widget build(BuildContext context) {
    final hint = XistiServiceModePresentation.hintForMode(mode, apiDisclaimer: apiDisclaimer);
    if (hint == null || hint.isEmpty) return const SizedBox.shrink();

    final accent = XistiUiTokens.accentForMode(mode);
    final needsSubcategoryGap = ServiceModeKind.isSharedRideMode(mode);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        top: 2.h,
        bottom: needsSubcategoryGap ? 12.h : 6.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 2.h),
            child: Icon(Icons.info_outline, size: 14.sp, color: accent.withValues(alpha: 0.85)),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              hint,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyText(
                context: context,
                fontSize: textSize10px,
                textColor: getCurrentTheme(context).colorTextLight,
              ).copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
