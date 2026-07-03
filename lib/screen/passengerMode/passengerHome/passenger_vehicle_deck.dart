import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bottomSheet/vehicle_information_sheet.dart';
import '../../../commonView/xisti_vehicle_image.dart';
import '../../../utils/custom_icons.dart';
import '../../../utils/service_mode_util.dart';
import '../../../utils/utils.dart';
import '../../../utils/xisti_ui_tokens.dart';
import 'passenger_home_dl.dart';
import 'xisti_section_label.dart';

/// XISTI vehicle picker — spotlight carousel, no bordered tiles (distinct from ZIMO).
class PassengerVehicleDeck extends StatefulWidget {
  final List<ServiceTypeItem> vehicles;
  final ServiceTypeItem? selected;
  final String? serviceMode;
  final ValueChanged<int> onSelect;
  final String? sectionLabel;

  const PassengerVehicleDeck({
    super.key,
    required this.vehicles,
    required this.selected,
    required this.onSelect,
    this.serviceMode,
    this.sectionLabel,
  });

  @override
  State<PassengerVehicleDeck> createState() => _PassengerVehicleDeckState();
}

class _PassengerVehicleDeckState extends State<PassengerVehicleDeck> {
  late final PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _page = _indexOfSelected();
    _pageController = PageController(viewportFraction: 0.42, initialPage: _page);
  }

  @override
  void didUpdateWidget(covariant PassengerVehicleDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _indexOfSelected();
    if (next != _page && _pageController.hasClients) {
      _page = next;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  int _indexOfSelected() {
    if (widget.selected == null) return 0;
    final idx = widget.vehicles.indexWhere((v) => v.matchesSelection(widget.selected));
    return idx >= 0 ? idx : 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicles.isEmpty) return const SizedBox.shrink();

    final theme = getCurrentTheme(context);
    final accent = XistiUiTokens.accentForMode(widget.serviceMode);
    final active = widget.vehicles[_page.clamp(0, widget.vehicles.length - 1)];
    final textOnly = ServiceModeKind.isAcarreosMode(widget.serviceMode);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: commonHorizontalPadding,
              end: commonHorizontalPadding,
              bottom: 4.h,
            ),
            child: XistiSectionLabel(
              label: widget.sectionLabel ?? (textOnly ? 'Tipo de carga' : 'Elige tu medio'),
              accent: accent,
              trailing: active.matchesSelection(widget.selected)
                  ? GestureDetector(
                      onTap: () => _openInfo(context, active),
                      child: Icon(CustomIcons.information, size: 18.sp, color: accent),
                    )
                  : null,
            ),
          ),
          SizedBox(
            height: textOnly ? 72.h : 118.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.vehicles.length,
              onPageChanged: (i) {
                setState(() => _page = i);
                widget.onSelect(i);
              },
              itemBuilder: (context, index) {
                final item = widget.vehicles[index];
                final isActive = index == _page;
                return AnimatedScale(
                  scale: isActive ? 1.0 : 0.78,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: isActive ? 1 : 0.45,
                    duration: const Duration(milliseconds: 220),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isActive)
                            Container(
                              width: textOnly ? 40.w : 56.w,
                              height: 3.h,
                              margin: EdgeInsetsDirectional.only(bottom: 6.h),
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(2.r),
                                boxShadow: textOnly
                                    ? null
                                    : [
                                        BoxShadow(
                                          color: accent.withValues(alpha: 0.55),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                              ),
                            )
                          else
                            SizedBox(height: 9.h),
                          if (textOnly)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                item.serviceName ?? '-',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: bodyText(
                                  context: context,
                                  textColor: isActive ? accent : theme.colorTextCommon,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: textSize14px,
                                ),
                              ),
                            )
                          else
                            XistiVehicleImage(
                              imagePath: item.serviceIcon,
                              size: isActive ? 88.w : 64.w,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (textOnly)
            const SizedBox.shrink()
          else
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: commonHorizontalPadding),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  active.serviceName ?? '-',
                  key: ValueKey(active.serviceName),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodyText(
                    context: context,
                    textColor: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: textSize14px,
                  ),
                ),
              ),
            ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.vehicles.length, (i) {
              final on = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
                width: on ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: on ? accent : theme.colorIndicatorOff,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _openInfo(BuildContext context, ServiceTypeItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VehicleInformationSheet(
        serviceName: item.serviceName ?? '',
        serviceIcon: item.serviceIcon ?? '',
        serviceDescription: item.serviceDescription ?? '',
      ),
    );
  }
}
