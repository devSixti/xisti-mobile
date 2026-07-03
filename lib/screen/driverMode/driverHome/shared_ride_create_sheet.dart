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
  Map<String, dynamic>? _fareEstimate;

  @override
  void initState() {
    super.initState();
    for (final c in [_originTEC, _destinationTEC, _seatsTEC]) {
      c.addListener(_scheduleFareEstimate);
    }
  }

  @override
  void dispose() {
    for (final c in [_originTEC, _destinationTEC, _seatsTEC]) {
      c.removeListener(_scheduleFareEstimate);
    }
    _originTEC.dispose();
    _destinationTEC.dispose();
    _seatsTEC.dispose();
    _fareTEC.dispose();
    super.dispose();
  }

  void _scheduleFareEstimate() {
    if (!mounted) return;
    final origin = _originTEC.text.trim();
    final destination = _destinationTEC.text.trim();
    final seats = int.tryParse(_seatsTEC.text.trim()) ?? 0;
    if (origin.length < 3 || destination.length < 3 || seats < 1) {
      setState(() => _fareEstimate = null);
      return;
    }
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (_originTEC.text.trim() != origin || _destinationTEC.text.trim() != destination) return;
      _loadFareEstimate(origin, destination, seats);
    });
  }

  Future<void> _loadFareEstimate(String origin, String destination, int seats) async {
    try {
      final raw = await _repo.sharedRideFareEstimate(
        originTown: origin,
        destinationTown: destination,
        seatsTotal: seats,
        isWeekend: _tripDate != null &&
            (_tripDate!.weekday == DateTime.saturday || _tripDate!.weekday == DateTime.sunday),
      );
      if (!mounted || (raw['status'] ?? 0) != 1) return;
      final estimate = Map<String, dynamic>.from(raw['estimate'] as Map? ?? {});
      setState(() => _fareEstimate = estimate);
      final recommended = (estimate['recommended_fare_per_person'] as num?)?.toDouble();
      if (recommended != null && recommended > 0 && _fareTEC.text.trim().isEmpty) {
        _fareTEC.text = recommended.toStringAsFixed(0);
      }
    } catch (_) {}
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

  Widget _fareHint(BuildContext context) {
    final estimate = _fareEstimate;
    if (estimate == null) return const SizedBox.shrink();
    final accent = XistiUiTokens.accentForMode(ServiceModeKind.expreso);
    final km = (estimate['distance_km'] as num?)?.toDouble() ?? 0;
    final tolls = (estimate['tolls_estimate'] as num?)?.toDouble() ?? 0;
    final min = (estimate['min_fare_per_person'] as num?)?.toDouble() ?? 0;
    final rec = (estimate['recommended_fare_per_person'] as num?)?.toDouble() ?? 0;
    final max = (estimate['max_fare_per_person'] as num?)?.toDouble() ?? 0;

    return Container(
      margin: EdgeInsetsDirectional.only(
        start: commonHorizontalPadding,
        end: commonHorizontalPadding,
        bottom: 10.h,
      ),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarifa sugerida por persona',
            style: bodyText(context: context, fontWeight: FontWeight.w700, fontSize: textSize13px),
          ),
          SizedBox(height: 6.h),
          Text(
            '~${km.toStringAsFixed(0)} km · peajes est. ${getAmountWithCurrency(tolls)}',
            style: bodyText(context: context, fontSize: textSize12px, textColor: getCurrentTheme(context).colorTextLight),
          ),
          SizedBox(height: 4.h),
          Text(
            'Rango: ${getAmountWithCurrency(min)} – ${getAmountWithCurrency(max)} · sugerido ${getAmountWithCurrency(rec)}',
            style: bodyText(context: context, fontSize: textSize12px, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
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
            onDateChanged: (d) {
              setState(() => _tripDate = d);
              _scheduleFareEstimate();
            },
          ),
          _fareHint(context),
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
