import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../commonView/custom_rounded_button.dart';
import '../../../commonView/xisti_bottom_sheet_shell.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/shared_ride_kind.dart';
import '../../../utils/utils.dart';
import '../../passengerMode/passengerHome/passenger_home_repo.dart';
import '../../passengerMode/passengerHome/shared_ride_fields.dart';
import '../../passengerMode/passengerHome/shared_ride_kind_selector.dart';

/// Driver-only sheet to publish ciudad↔municipio shared rides (XISTI styling).
class SharedRideCreateSheet extends StatefulWidget {
  const SharedRideCreateSheet({super.key});

  @override
  State<SharedRideCreateSheet> createState() => _SharedRideCreateSheetState();
}

class _SharedRideCreateSheetState extends State<SharedRideCreateSheet> {
  final _repo = PassengerHomeRepo();
  String _kind = SharedRideKind.defaultKind;
  DateTime? _tripDate;
  final _originTEC = TextEditingController();
  final _destinationTEC = TextEditingController();
  final _seatsTEC = TextEditingController(text: '3');
  final _fareTEC = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _originTEC.dispose();
    _destinationTEC.dispose();
    _seatsTEC.dispose();
    _fareTEC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final origin = _originTEC.text.trim();
    final destination = _destinationTEC.text.trim();
    final seats = int.tryParse(_seatsTEC.text.trim()) ?? 0;
    if (origin.isEmpty || destination.isEmpty) {
      openSimpleSnackbar(context, SharedRideKind.destinationRequiredMessage(_kind));
      return;
    }
    if (_tripDate == null) {
      openSimpleSnackbar(context, languages.selectSharedRideDate);
      return;
    }
    if (seats < 1 || seats > 8) {
      openSimpleSnackbar(context, languages.selectSeatsAvailable);
      return;
    }
    final fare = double.tryParse(_fareTEC.text.trim().replaceAll(',', '.')) ?? -1;
    if (fare < 0) {
      openSimpleSnackbar(context, languages.selectContributionAmount);
      return;
    }
    if (!await isNetworkConnected(onRetryPressedCallApi: _submit)) return;
    setState(() => _loading = true);
    try {
      final dateStr =
          '${_tripDate!.year}-${_tripDate!.month.toString().padLeft(2, '0')}-${_tripDate!.day.toString().padLeft(2, '0')}';
      final raw = await _repo.sharedRideCreateOffer(
        tripKind: _kind,
        originTown: origin,
        destinationTown: destination,
        tripDate: dateStr,
        seatsTotal: seats,
        farePerPerson: fare,
      );
      final status = int.tryParse('${raw['status']}') ?? 0;
      final message = raw['message']?.toString() ?? '';
      if (!mounted) return;
      if (status == 1) {
        openSimpleSnackbar(context, message);
        Navigator.pop(context, true);
      } else {
        openSimpleSnackbar(context, message);
      }
    } catch (e) {
      if (mounted) openSimpleSnackbar(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = XistiUiTokens.accentForMode(ServiceModeKind.expreso);
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: XistiBottomSheetShell(
        title: languages.createSharedRide,
        onClose: () => Navigator.pop(context),
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
            child: Text(
              languages.serviceModeShareSubtitle,
              style: bodyText(context: context, fontSize: textSize12px),
            ),
          ),
          SharedRideKindSelector(
            selectedKind: _kind,
            onKindChanged: (k) => setState(() => _kind = k),
          ),
          SharedRideFields(
            tripKind: _kind,
            originController: _originTEC,
            destinationController: _destinationTEC,
            fareController: _fareTEC,
            tripDate: _tripDate,
            onDateChanged: (d) => setState(() => _tripDate = d),
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
            child: TextField(
              controller: _seatsTEC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: languages.availableSeats),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
            child: CustomRoundedButton(
              context,
              languages.publishRide,
              _loading ? null : _submit,
              setProgress: _loading,
            ),
          ),
        ],
      ),
    );
  }
}
