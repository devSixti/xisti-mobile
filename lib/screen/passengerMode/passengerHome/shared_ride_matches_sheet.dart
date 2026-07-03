import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_rounded_button.dart';
import '../../../utils/shared_ride_kind.dart';
import '../../../utils/utils.dart';

class SharedRideMatchesSheet extends StatelessWidget {
  final String message;
  final bool scheduled;
  final List<Map<String, dynamic>> matches;
  final Future<void> Function(int offerId) onJoin;

  const SharedRideMatchesSheet({
    super.key,
    required this.message,
    required this.scheduled,
    required this.matches,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getCurrentTheme(context);
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight * 0.75),
      decoration: BoxDecoration(
        color: theme.colorScaffoldBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        top: 16.h,
        bottom: getBottomMargin() + 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            scheduled ? languages.scheduledRequest : languages.availableSharedRides,
            style: headerText(context: context, fontSize: textSize18px),
          ),
          SizedBox(height: 8.h),
          Text(message, style: bodyText(context: context, textColor: theme.colorTextLight)),
          SizedBox(height: 16.h),
          if (matches.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                languages.sharedRideMatchNotifyWhenAvailable,
                textAlign: TextAlign.center,
                style: bodyText(context: context),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: matches.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final m = matches[index];
                  final offerId = int.tryParse('${m['offer_id']}') ?? 0;
                  final date = m['trip_date']?.toString() ?? '';
                  final seats = m['seats_available']?.toString() ?? '0';
                  final driverName = m['driver_name']?.toString() ?? languages.driver;
                  final kind = SharedRideKind.label(m['trip_kind']?.toString() ?? '');
                  final fareRaw = m['fare_per_person'];
                  final fare = fareRaw is num
                      ? fareRaw.toDouble()
                      : double.tryParse('$fareRaw') ?? 0;
                  final fareLabel = fare > 0
                      ? '${getAmountWithCurrency(fare, numberAfterPoint: 0)} ${languages.perPersonSuffix}'
                      : languages.contributionToAgree;
                  return Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorTextFieldBorder),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driverName, style: bodyText(context: context, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4.h),
                        Text(
                          '${m['origin_town']} → ${m['destination_town']}',
                          style: bodyText(context: context, textColor: theme.colorTextLight),
                        ),
                        SizedBox(height: 4.h),
                        Text('$kind · $date · $seats ${languages.seatsAvailableSuffix}', style: bodyText(context: context, fontSize: textSize12px)),
                        SizedBox(height: 4.h),
                        Text(
                          fareLabel,
                          style: bodyText(
                            context: context,
                            fontSize: textSize13px,
                            fontWeight: FontWeight.w600,
                            textColor: theme.colorPrimary,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomRoundedButton(
                          context,
                          languages.joinRide,
                          offerId > 0 ? () => onJoin(offerId) : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 12.h),
          CustomRoundedButton(context, languages.close, () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
