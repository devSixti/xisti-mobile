import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = kMinInteractiveDimension;
double _kDenseButtonHeight = 30.h;
EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 15.w);

/// A builder to customize the selected menu item.
typedef SelectedMenuItemBuilder = Widget Function(BuildContext context, Widget child);

/// Signature for the callback that's called when when the dropdown menu opens or closes.
typedef OnMenuStateChangeFn = void Function(bool isOpen);

/// Signature for the callback for the match function used for searchable dropdowns.
typedef SearchMatchFn<T> = bool Function(DropdownItem<T> item, String searchValue);

/// A Material Design button for selecting from a list of items.
///
/// A dropdown button lets the user select from a number of items. The button
/// shows the currently selected item as well as an arrow that opens a menu for
/// selecting another item.
///
/// One ancestor must be a [Material] widget and typically this is
/// provided by the app's [Scaffold].
///
/// The type `T` is the type of the [value] that each dropdown item represents.
/// All the entries in a given menu must represent values with consistent types.
/// Typically, an enum is used. Each [DropdownItem] in [items] must be
/// specialized with that same type argument.
///
/// The [onChanged] callback should update a state variable that defines the
/// dropdown's value. It should also call [State.setState] to rebuild the
/// dropdown with the new value.
///
/// If the [onChanged] callback is null or the list of [items] is null
/// then the dropdown button will be disabled, i.e. its arrow will be
/// displayed in grey and it will not respond to input. A disabled button
/// will display the [disabledHint] widget if it is non-null. However, if
/// [disabledHint] is null and [hint] is non-null, the [hint] widget will
/// instead be displayed.
///
/// See also:
///
///  * [DropdownButtonFormField2], which integrates with the [Form] widget.
///  * [DropdownItem], the class used to represent the [items].
///  * [DropdownButtonHideUnderline], which prevents its descendant dropdown buttons
///    from displaying their underlines.
///  * [ElevatedButton], [TextButton], ordinary buttons that trigger a single action.
///  * <https://material.io/design/components/menus.html#dropdown-menu>
class DropdownButton2<T> extends StatefulWidget {
  /// Creates a DropdownButton2.
  /// It's customizable DropdownButton with steady dropdown menu and many other features.
  ///
  /// The [items] must have distinct values. If [value] isn't null then it
  /// must be equal to one of the [DropdownItem] values. If [items] or
  /// [onChanged] is null, the button will be disabled, the down arrow
  /// will be greyed out.
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed
  /// if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed
  /// if it is non-null. If [disabledHint] is null, then [hint] will be displayed
  /// if it is non-null.
  DropdownButton2({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onMenuStateChange,
    this.style,
    this.underline,
    this.isDense = false,
    this.isExpanded = false,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.buttonStyleData,
    this.iconStyleData = const IconStyleData(),
    this.dropdownStyleData = const DropdownStyleData(),
    this.menuItemStyleData = const MenuItemStyleData(),
    this.dropdownSearchData,
    this.dropdownSeparator,
    this.customButton,
    this.openWithLongPress = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    // When adding new arguments, consider adding similar arguments to
    // DropdownButtonFormField.
  }) : assert(
         items == null ||
             items.isEmpty ||
             value == null ||
             items.where((DropdownItem<T> item) {
                   return item.value == value;
                 }).length ==
                 1,
         "There should be exactly one item with [DropdownButton]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownItem]s were detected '
         'with the same value',
       ),
       _inputDecoration = null,
       _isEmpty = false,
       _isFocused = false;

  DropdownButton2._formField({
    super.key,
    required this.items,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onMenuStateChange,
    this.style,
    this.underline,
    this.isDense = false,
    this.isExpanded = false,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.buttonStyleData,
    required this.iconStyleData,
    required this.dropdownStyleData,
    required this.menuItemStyleData,
    this.dropdownSearchData,
    this.dropdownSeparator,
    this.customButton,
    this.openWithLongPress = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    required InputDecoration inputDecoration,
    required bool isEmpty,
    required bool isFocused,
  }) : assert(
         items == null ||
             items.isEmpty ||
             value == null ||
             items.where((DropdownItem<T> item) {
                   return item.value == value;
                 }).length ==
                 1,
         "There should be exactly one item with [DropdownButtonFormField]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownItem]s were detected '
         'with the same value',
       ),
       _inputDecoration = inputDecoration,
       _isEmpty = isEmpty,
       _isFocused = isFocused;

  /// The list of items the user can select.
  ///
  /// If the [onChanged] callback is null or the list of items is null
  /// then the dropdown button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input.
  final List<DropdownItem<T>>? items;

  /// A builder to customize the dropdown buttons corresponding to the
  /// [DropdownItem]s in [items].
  ///
  /// When a [DropdownItem] is selected, the widget that will be displayed
  /// from the list corresponds to the [DropdownItem] of the same index
  /// in [items].
  ///
  /// {@tool dartpad}
  /// This sample shows a [DropdownButton] with a button with [Text] that
  /// corresponds to but is unique from [DropdownItem].
  ///
  /// ** See code in examples/api/lib/material/dropdown/dropdown_button.selected_item_builder.0.dart **
  /// {@end-tool}
  ///
  /// If this callback is null, the [DropdownItem] from [items]
  /// that matches [value] will be displayed.
  final DropdownButtonBuilder? selectedItemBuilder;

  /// The value of the currently selected [DropdownItem].
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed
  /// if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed
  /// if it is non-null. If [disabledHint] is null, then [hint] will be displayed
  /// if it is non-null.
  final T? value;

  /// A placeholder widget that is displayed by the dropdown button.
  ///
  /// If [value] is null and the dropdown is enabled ([items] and [onChanged] are non-null),
  /// this widget is displayed as a placeholder for the dropdown button's value.
  ///
  /// If [value] is null and the dropdown is disabled and [disabledHint] is null,
  /// this widget is used as the placeholder.
  final Widget? hint;

  /// A preferred placeholder widget that is displayed when the dropdown is disabled.
  ///
  /// If [value] is null, the dropdown is disabled ([items] or [onChanged] is null),
  /// this widget is displayed as a placeholder for the dropdown button's value.
  final Widget? disabledHint;

  /// {@template flutter.material.dropdownButton.onChanged}
  /// Called when the user selects an item.
  ///
  /// If the [onChanged] callback is null or the list of [DropdownButton2.items]
  /// is null then the dropdown button will be disabled, i.e. its arrow will be
  /// displayed in grey and it will not respond to input. A disabled button
  /// will display the [DropdownButton2.disabledHint] widget if it is non-null.
  /// If [DropdownButton2.disabledHint] is also null but [DropdownButton2.hint] is
  /// non-null, [DropdownButton2.hint] will instead be displayed.
  /// {@endtemplate}
  final ValueChanged<T?>? onChanged;

  /// Called when the dropdown menu opens or closes.
  final OnMenuStateChangeFn? onMenuStateChange;

  /// The text style to use for text in the dropdown button and the dropdown
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the dropdown button, consider using [selectedItemBuilder].
  ///
  /// {@tool dartpad}
  /// This sample shows a `DropdownButton` with a dropdown button text style
  /// that is different than its menu items.
  ///
  /// ** See code in examples/api/lib/material/dropdown/dropdown_button.style.0.dart **
  /// {@end-tool}
  ///
  /// Defaults to the [TextTheme.titleMedium] value of the current
  /// [ThemeData.textTheme] of the current [Theme].
  final TextStyle? style;

  /// The widget to use for drawing the drop-down button's underline.
  ///
  /// Defaults to a 0.0 width bottom border with color 0xFFBDBDBD.
  final Widget? underline;

  /// Reduce the button's height.
  ///
  /// By default this button's height is the same as its menu items' heights.
  /// If isDense is true, the button's height is reduced by about half. This
  /// can be useful when the button is embedded in a container that adds
  /// its own decorations, like [InputDecorator].
  final bool isDense;

  /// Set the dropdown's inner contents to horizontally fill its parent.
  ///
  /// By default this button's inner width is the minimum size of its contents.
  /// If [isExpanded] is true, the inner width is expanded to fill its
  /// surrounding container.
  final bool isExpanded;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// By default, platform-specific feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// Defines how the hint or the selected item is positioned within the button.
  ///
  /// This property must not be null. It defaults to [AlignmentDirectional.centerStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// Used to configure the theme of the button
  final ButtonStyleData? buttonStyleData;

  /// Used to configure the theme of the button's icon
  final IconStyleData iconStyleData;

  /// Used to configure the theme of the dropdown menu
  final DropdownStyleData dropdownStyleData;

  /// Used to configure the theme of the dropdown menu items
  final MenuItemStyleData menuItemStyleData;

  /// Used to configure searchable dropdowns
  final DropdownSearchData<T>? dropdownSearchData;

  /// Adds separator widget to the dropdown menu.
  ///
  /// Defaults to null.
  final DropdownSeparator<T>? dropdownSeparator;

  /// Uses custom widget like icon,image,etc.. instead of the default button
  final Widget? customButton;

  /// Opens the dropdown menu on long-pressing instead of tapping
  final bool openWithLongPress;

  /// Whether you can dismiss this route by tapping the modal barrier.
  final bool barrierDismissible;

  /// The color to use for the modal barrier. If this is null, the barrier will
  /// be transparent.
  final Color? barrierColor;

  /// The semantic label used for a dismissible barrier.
  ///
  /// If the barrier is dismissible, this label will be read out if
  /// accessibility tools (like VoiceOver on iOS) focus on the barrier.
  final String? barrierLabel;

  final InputDecoration? _inputDecoration;

  final bool _isEmpty;

  final bool _isFocused;

  @override
  State<DropdownButton2<T>> createState() => DropdownButton2State<T>();
}

// ignore: public_member_api_docs
class DropdownButton2State<T> extends State<DropdownButton2<T>> with WidgetsBindingObserver {
  int? _selectedIndex;
  _DropdownRoute<T>? _dropdownRoute;
  Orientation? _lastOrientation;
  FocusNode? _internalNode;

  ButtonStyleData? get _buttonStyle => widget.buttonStyleData;

  IconStyleData get _iconStyle => widget.iconStyleData;

  DropdownStyleData get _dropdownStyle => widget.dropdownStyleData;

  MenuItemStyleData get _menuItemStyle => widget.menuItemStyleData;

  DropdownSearchData<T>? get _searchData => widget.dropdownSearchData;

  FocusNode get _focusNode => widget.focusNode ?? _internalNode!;

  late Map<Type, Action<Intent>> _actionMap;

  // Using ValueNotifier for tracking when menu is open/close to update the button icon.
  final ValueNotifier<bool> _isMenuOpen = ValueNotifier<bool>(false);

  // Using ValueNotifier for the Rect of DropdownButton so the dropdown menu listen and
  // update its position if DropdownButton's position has changed, as when keyboard open.
  final ValueNotifier<Rect?> _rect = ValueNotifier<Rect?>(null);

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSelectedIndex();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (ActivateIntent intent) => _handleTap()),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(onInvoke: (ButtonActivateIntent intent) => _handleTap()),
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    _internalNode?.dispose();
    _isMenuOpen.dispose();
    _rect.dispose();
    super.dispose();
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  @override
  void didUpdateWidget(DropdownButton2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null && widget.items!.where((DropdownItem<T> item) => item.enabled && item.value == widget.value).isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!.where((DropdownItem<T> item) => item.value == widget.value).length == 1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  @override
  void didChangeMetrics() {
    //This fix the bug of calling didChangeMetrics() on iOS when app starts
    if (_rect.value == null) {
      return;
    }
    final Rect newRect = _getRect();
    //This avoid unnecessary rebuilds if _rect position hasn't changed
    if (_rect.value!.top == newRect.top) {
      return;
    }
    _rect.value = newRect;
  }

  TextStyle? get _textStyle => widget.style ?? Theme.of(context).textTheme.titleMedium;

  Rect _getRect() {
    final TextDirection? textDirection = Directionality.maybeOf(context);
    const EdgeInsetsGeometry menuMargin = EdgeInsets.zero;
    final NavigatorState navigator = Navigator.of(context, rootNavigator: _dropdownStyle.useRootNavigator);

    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;

    return menuMargin.resolve(textDirection).inflateRect(itemRect);
  }

  void _handleTap() {
    final NavigatorState navigator = Navigator.of(context, rootNavigator: _dropdownStyle.useRootNavigator);

    final items = widget.items!;
    final separator = widget.dropdownSeparator;
    _rect.value = _getRect();

    assert(_dropdownRoute == null);
    _dropdownRoute = _DropdownRoute<T>(
      items: items,
      buttonRect: _rect,
      selectedIndex: _selectedIndex ?? 0,
      isNoSelectedItem: _selectedIndex == null,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierDismissible: widget.barrierDismissible,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
      parentFocusNode: _focusNode,
      enableFeedback: widget.enableFeedback ?? true,
      dropdownStyle: _dropdownStyle,
      menuItemStyle: _menuItemStyle,
      searchData: _searchData,
      dropdownSeparator: separator,
    );

    _isMenuOpen.value = true;
    _focusNode.requestFocus();
    // This is a temporary fix for the "dropdown menu steal the focus from the
    // underlying button" issue, until share focus is fixed in flutter (#106923).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dropdownRoute?._childNode.requestFocus();
    });
    navigator.push(_dropdownRoute!).then<void>((_DropdownRouteResult<T>? newValue) {
      _removeDropdownRoute();
      _isMenuOpen.value = false;
      widget.onMenuStateChange?.call(false);
      if (!mounted || newValue == null) {
        return;
      }
      widget.onChanged?.call(newValue.result);
    });

    widget.onMenuStateChange?.call(true);
  }

  /// Exposes the _handleTap() to Allow opening the button programmatically using GlobalKey.
  // Note: DropdownButton2State should be public as we need typed access to it through key.
  void callTap() => _handleTap();

  // When isDense is true, reduce the height of this button from _kMenuItemHeight to
  // _kDenseButtonHeight, but don't make it smaller than the text that it contains.
  // Similarly, we don't reduce the height of the button so much that its icon
  // would be clipped.
  double get _denseButtonHeight {
    // ignore: deprecated_member_use
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final double fontSize = _textStyle!.fontSize ?? Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize = textScaleFactor * fontSize;
    return math.max(scaledFontSize, math.max(_iconStyle.iconSize, _kDenseButtonHeight));
  }

  Color get _iconColor {
    // These colors are not defined in the Material Design spec.
    if (_enabled) {
      if (_iconStyle.iconEnabledColor != null) {
        return _iconStyle.iconEnabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade700;
        case Brightness.dark:
          return Colors.white70;
      }
    } else {
      if (_iconStyle.iconDisabledColor != null) {
        return _iconStyle.iconDisabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade400;
        case Brightness.dark:
          return Colors.white10;
      }
    }
  }

  bool get _enabled => widget.items != null && widget.items!.isNotEmpty && widget.onChanged != null;

  Orientation _getOrientation(BuildContext context) {
    Orientation? result = MediaQuery.maybeOf(context)?.orientation;
    if (result == null) {
      // If there's no MediaQuery, then use the window aspect to determine
      // orientation.

      final Size size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
      result = size.width > size.height ? Orientation.landscape : Orientation.portrait;
    }
    return result;
  }

  BorderRadius? _getButtonBorderRadius(BuildContext context) {
    final buttonRadius = _buttonStyle?.decoration?.borderRadius ?? _buttonStyle?.foregroundDecoration?.borderRadius;
    if (buttonRadius != null) {
      return buttonRadius.resolve(Directionality.of(context));
    }

    final inputBorder = widget._inputDecoration?.border;
    if (inputBorder?.isOutline ?? false) {
      return (inputBorder! as OutlineInputBorder).borderRadius;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }

    // The width of the button and the menu are defined by the widest
    // item and the width of the hint.
    // We should explicitly type the items list to be a list of <Widget>,
    // otherwise, no explicit type adding items maybe trigger a crash/failure
    // when hint and selectedItemBuilder are provided.
    final List<Widget> buttonItems =
        widget.selectedItemBuilder == null
            ? (widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[])
            : List<Widget>.of(widget.selectedItemBuilder!(context));

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      final Widget displayedHint = _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;

      hintIndex = buttonItems.length;
      buttonItems.add(DefaultTextStyle(style: _textStyle!.copyWith(color: Theme.of(context).hintColor), child: IgnorePointer(child: displayedHint)));
    }

    // final EdgeInsetsGeometry padding = ButtonTheme.of(context).alignedDropdown ? _kAlignedButtonPadding : _kUnalignedButtonPadding;

    final buttonHeight = _buttonStyle?.height ?? (widget.isDense ? _denseButtonHeight : null);

    Widget item = buttonItems[_selectedIndex ?? hintIndex ?? 0];
    if (item is DropdownItem) {
      item = item.copyWith(alignment: widget.alignment);
    }

    // If value is null (then _selectedIndex is null) then we
    // display the hint or nothing at all.
    final Widget innerItemsWidget;
    if (buttonItems.isEmpty) {
      innerItemsWidget = const SizedBox.shrink();
    } else {
      // When both buttonHeight & buttonWidth are specified, we don't have to use IndexedStack,
      // which enhances the performance when dealing with big items list.
      // Note: Both buttonHeight & buttonWidth must be specified to avoid changing
      // button's size when selecting different items, which is a bad UX.
      innerItemsWidget =
          buttonHeight != null && _buttonStyle?.width != null
              ? Align(alignment: widget.alignment, child: item)
              : IndexedStack(
                index: _selectedIndex ?? hintIndex,
                alignment: widget.alignment,
                children:
                    buttonHeight != null
                        ? buttonItems.mapIndexed((item, index) => item).toList()
                        : buttonItems.mapIndexed((item, index) {
                          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[item]);
                        }).toList(),
              );
    }

    Widget result = DefaultTextStyle(
      style: _enabled ? _textStyle! : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
      child:
          widget.customButton ??
          Container(
            decoration: _buttonStyle?.decoration?.copyWith(boxShadow: _buttonStyle!.decoration!.boxShadow ?? kElevationToShadow[_buttonStyle!.elevation ?? 0]),
            foregroundDecoration: _buttonStyle?.foregroundDecoration?.copyWith(
              boxShadow: _buttonStyle!.foregroundDecoration!.boxShadow ?? kElevationToShadow[_buttonStyle!.elevation ?? 0],
            ),
            padding: _buttonStyle?.padding,
            height: buttonHeight,
            width: _buttonStyle?.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.isExpanded) Expanded(child: innerItemsWidget) else innerItemsWidget,
                IconTheme(
                  data: IconThemeData(color: _iconColor, size: _iconStyle.iconSize),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isMenuOpen,
                    builder: (BuildContext context, bool isOpen, _) {
                      return _iconStyle.openMenuIcon != null
                          ? isOpen
                              ? _iconStyle.openMenuIcon!
                              : _iconStyle.icon
                          : _iconStyle.icon;
                    },
                  ),
                ),
              ],
            ),
          ),
    );

    if (!DropdownButtonHideUnderline.at(context)) {
      final double bottom = widget.isDense ? 0.0 : 8.0;
      result = Stack(
        children: <Widget>[
          result,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: bottom,
            child:
                widget.underline ??
                Container(height: 1.0, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.0)))),
          ),
        ],
      );
    }

    final MouseCursor effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor>(WidgetStateMouseCursor.clickable, <WidgetState>{
      if (!_enabled) WidgetState.disabled,
    });

    if (widget._inputDecoration != null) {
      result = InputDecorator(decoration: widget._inputDecoration!, isEmpty: widget._isEmpty, isFocused: widget._isFocused, child: result);
    }

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled && !widget.openWithLongPress ? _handleTap : null,
          onLongPress: _enabled && widget.openWithLongPress ? _handleTap : null,
          canRequestFocus: _enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          overlayColor: _buttonStyle?.overlayColor,
          enableFeedback: false,
          borderRadius: _getButtonBorderRadius(context),
          child: result,
        ),
      ),
    );
  }
}

/// A [FormField] that contains a [DropdownButton2].
///
/// This is a convenience widget that wraps a [DropdownButton2] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] allows one to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// See also:
///
///  * [DropdownButton2], which is the underlying text field without the [Form]
///    integration.
class DropdownButtonFormField2<T> extends FormField<T> {
  /// Creates a [DropdownButton2] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField]. For the rest (other than [decoration]), see
  /// [DropdownButton2].
  ///
  /// The `items`, `elevation`, `iconSize`, `isDense`, `isExpanded`,
  /// `autofocus`, and `decoration`  parameters must not be null.
  DropdownButtonFormField2({
    super.key,
    this.dropdownButtonKey,
    required List<DropdownItem<T>>? items,
    DropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    this.onChanged,
    OnMenuStateChangeFn? onMenuStateChange,
    TextStyle? style,
    bool isDense = true,
    bool isExpanded = false,
    FocusNode? focusNode,
    bool autofocus = false,
    InputDecoration? decoration,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    ButtonStyleData? buttonStyleData,
    IconStyleData iconStyleData = const IconStyleData(),
    DropdownStyleData dropdownStyleData = const DropdownStyleData(),
    MenuItemStyleData menuItemStyleData = const MenuItemStyleData(),
    DropdownSearchData<T>? dropdownSearchData,
    DropdownSeparator<T>? dropdownSeparator,
    Widget? customButton,
    bool openWithLongPress = false,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) : assert(
         items == null ||
             items.isEmpty ||
             value == null ||
             items.where((DropdownItem<T> item) {
                   return item.value == value;
                 }).length ==
                 1,
         "There should be exactly one item with [DropdownButton]'s value: "
         '$value. \n'
         'Either zero or 2 or more [DropdownItem]s were detected '
         'with the same value',
       ),
       decoration = _getInputDecoration(decoration, buttonStyleData),
       super(
         initialValue: value,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         builder: (FormFieldState<T> field) {
           final _DropdownButtonFormFieldState<T> state = field as _DropdownButtonFormFieldState<T>;
           final InputDecoration decorationArg = _getInputDecoration(decoration, buttonStyleData);
           final InputDecoration effectiveDecoration = decorationArg.applyDefaults(Theme.of(field.context).inputDecorationTheme);

           final bool showSelectedItem = items != null && items.where((DropdownItem<T> item) => item.value == state.value).isNotEmpty;
           bool isHintOrDisabledHintAvailable() {
             final bool isDropdownDisabled = onChanged == null || (items == null || items.isEmpty);
             if (isDropdownDisabled) {
               return hint != null || disabledHint != null;
             } else {
               return hint != null;
             }
           }

           final bool isEmpty = !showSelectedItem && !isHintOrDisabledHintAvailable();

           // An unFocusable Focus widget so that this widget can detect if its
           // descendants have focus or not.
           return Focus(
             canRequestFocus: false,
             skipTraversal: true,
             child: Builder(
               builder: (BuildContext context) {
                 return InputDecorator(
                   decoration: const InputDecoration.collapsed(hintText: '').copyWith(errorText: field.errorText),
                   child: DropdownButtonHideUnderline(
                     child: DropdownButton2<T>._formField(
                       key: dropdownButtonKey,
                       items: items,
                       selectedItemBuilder: selectedItemBuilder,
                       value: state.value,
                       hint: hint,
                       disabledHint: disabledHint,
                       onChanged: onChanged == null ? null : state.didChange,
                       onMenuStateChange: onMenuStateChange,
                       style: style,
                       isDense: isDense,
                       isExpanded: isExpanded,
                       focusNode: focusNode,
                       autofocus: autofocus,
                       enableFeedback: enableFeedback,
                       alignment: alignment,
                       buttonStyleData: buttonStyleData,
                       iconStyleData: iconStyleData,
                       dropdownStyleData: dropdownStyleData,
                       menuItemStyleData: menuItemStyleData,
                       dropdownSearchData: dropdownSearchData,
                       dropdownSeparator: dropdownSeparator,
                       customButton: customButton,
                       openWithLongPress: openWithLongPress,
                       barrierDismissible: barrierDismissible,
                       barrierColor: barrierColor,
                       barrierLabel: barrierLabel,
                       inputDecoration: effectiveDecoration,
                       isEmpty: isEmpty,
                       isFocused: Focus.of(context).hasFocus,
                     ),
                   ),
                 );
               },
             ),
           );
         },
       );

  /// The key of DropdownButton2 child widget
  ///
  /// This allows accessing DropdownButton2State.
  /// It is useful for some cases, i.e: calling callTap() method to open the menu programmatically
  final Key? dropdownButtonKey;

  /// {@macro flutter.material.dropdownButton.onChanged}
  final ValueChanged<T?>? onChanged;

  /// The decoration to show around the dropdown button form field.
  ///
  /// By default, draws a horizontal line under the dropdown button field but
  /// can be configured to show an icon, label, hint text, and error text.
  ///
  /// If not specified, an [InputDecorator] with the `focusColor` and `hoverColor`
  /// set to the supplied `buttonStyleData.overlayColor` (if any) will be used.
  final InputDecoration decoration;

  static InputDecoration _getInputDecoration(InputDecoration? decoration, ButtonStyleData? buttonStyleData) {
    return decoration ??
        InputDecoration(
          focusColor: buttonStyleData?.overlayColor?.resolve(<WidgetState>{WidgetState.focused}),
          hoverColor: buttonStyleData?.overlayColor?.resolve(<WidgetState>{WidgetState.hovered}),
        );
  }

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  void didChange(T? value) {
    super.didChange(value);
    final DropdownButtonFormField2<T> dropdownButtonFormField = widget as DropdownButtonFormField2<T>;
    assert(dropdownButtonFormField.onChanged != null);
    dropdownButtonFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(DropdownButtonFormField2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

SearchMatchFn<T> _defaultSearchMatchFn<T>() =>
    (DropdownItem<T> item, String searchValue) => item.value.toString().toLowerCase().contains(searchValue.toLowerCase());

class _MenuLimits {
  const _MenuLimits(this.top, this.bottom, this.height, this.scrollOffset);

  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    super.key,
    required this.route,
    required this.textDirection,
    required this.buttonRect,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final TextDirection? textDirection;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final bool enableFeedback;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;
  late List<Widget> _children;
  late SearchMatchFn<T> _searchMatchFn;

  List<DropdownItem<T>> get items => widget.route.items;

  DropdownStyleData get dropdownStyle => widget.route.dropdownStyle;

  DropdownSearchData<T>? get searchData => widget.route.searchData;

  _DropdownItemButton<T> dropdownItemButton(int index) => _DropdownItemButton<T>(
    route: widget.route,
    textDirection: widget.textDirection,
    buttonRect: widget.buttonRect,
    constraints: widget.constraints,
    mediaQueryPadding: widget.mediaQueryPadding,
    itemIndex: index,
    enableFeedback: widget.enableFeedback,
  );

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve
    // direction. When the route's animation reverses, if we were to recreate
    // the CurvedAnimation objects in build, we'd lose
    // CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(parent: widget.route.animation!, curve: const Interval(0.0, 0.25), reverseCurve: const Interval(0.75, 1.0));
    _resize = CurvedAnimation(parent: widget.route.animation!, curve: dropdownStyle.openInterval, reverseCurve: const Threshold(0.0));
    //If searchController is null, then it'll perform as a normal dropdown
    //and search functions will not be executed.
    final searchController = searchData?.searchController;
    if (searchController == null) {
      _children = <Widget>[for (int index = 0; index < items.length; ++index) dropdownItemButton(index)];
    } else {
      _searchMatchFn = searchData?.searchMatchFn ?? _defaultSearchMatchFn();
      _children = _getSearchItems();
      // Add listener to searchController (if it's used) to update the shown items.
      searchController.addListener(_onSearchChange);
    }
  }

  void _onSearchChange() {
    _children = _getSearchItems();
    setState(() {});
  }

  List<Widget> _getSearchItems() {
    final String currentSearch = searchData!.searchController!.text;
    return <Widget>[
      for (int index = 0; index < items.length; ++index)
        if (_searchMatchFn(items[index], currentSearch)) dropdownItemButton(index),
    ];
  }

  @override
  void dispose() {
    _fadeOpacity.dispose();
    _resize.dispose();
    searchData?.searchController?.removeListener(_onSearchChange);
    super.dispose();
  }

  final _states = <WidgetState>{WidgetState.dragged, WidgetState.hovered};

  bool get _isIOS => Theme.of(context).platform == TargetPlatform.iOS;

  ScrollbarThemeData? get _scrollbarTheme => dropdownStyle.scrollbarTheme;

  bool get _iOSThumbVisibility => _scrollbarTheme?.thumbVisibility?.resolve(_states) ?? true;

  DropdownSeparator<T>? get separator => widget.route.dropdownSeparator;

  @override
  Widget build(BuildContext context) {
    // The menu is shown in three stages (unit timing in brackets):
    // [0s - 0.25s] - Fade in a rect-sized menu container with the selected item.
    // [0.25s - 0.5s] - Grow the otherwise empty menu container from the center
    //   until it's big enough for as many items as we're going to show.
    // [0.5s - 1.0s] Fade in the remaining visible items from top to bottom.
    //
    // When the menu is dismissed we just fade the entire thing out
    // in the first 0.25s.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final _DropdownRoute<T> route = widget.route;

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _DropdownMenuPainter(
          color: Theme.of(context).canvasColor,
          elevation: dropdownStyle.elevation,
          selectedIndex: route.selectedIndex,
          resize: _resize,
          itemHeight: items[0].height,
          dropdownDecoration: dropdownStyle.decoration,
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: ClipRRect(
            //Prevent scrollbar, ripple effect & items from going beyond border boundaries when scrolling.
            clipBehavior: dropdownStyle.decoration?.borderRadius != null ? Clip.antiAlias : Clip.none,
            borderRadius: dropdownStyle.decoration?.borderRadius?.resolve(Directionality.of(context)) ?? BorderRadius.zero,
            child: Material(
              type: MaterialType.transparency,
              textStyle: route.style,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (searchData?.searchBarWidget != null) searchData!.searchBarWidget!,
                  if (_children.isEmpty && searchData?.noResultsWidget != null)
                    searchData!.noResultsWidget!
                  else
                    Flexible(
                      child: Padding(
                        padding: dropdownStyle.scrollPadding ?? EdgeInsets.zero,
                        child: ScrollConfiguration(
                          // Dropdown menus should never overscroll or display an overscroll indicator.
                          // Scrollbars are built-in below.
                          // Platform must use Theme and ScrollPhysics must be Clamping.
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false, overscroll: false, physics: const ClampingScrollPhysics(), platform: Theme.of(context).platform),
                          child: PrimaryScrollController(
                            controller: route.scrollController!,
                            child: Theme(
                              data: Theme.of(context).copyWith(scrollbarTheme: dropdownStyle.scrollbarTheme),
                              child: Scrollbar(
                                thumbVisibility:
                                    // ignore: avoid_bool_literals_in_conditional_expressions
                                    _isIOS ? _iOSThumbVisibility : true,
                                thickness: _isIOS ? _scrollbarTheme?.thickness?.resolve(_states) : null,
                                radius: _isIOS ? _scrollbarTheme?.radius : null,
                                child: ListView.separated(
                                  // Ensure this always inherits the PrimaryScrollController
                                  primary: true,
                                  shrinkWrap: true,
                                  padding: dropdownStyle.padding ?? kMaterialListPadding,
                                  itemCount: _children.length,
                                  itemBuilder: (context, index) => _children[index],
                                  separatorBuilder:
                                      (context, index) =>
                                          separator != null
                                              ? SizedBox(height: separator!.intrinsicHeight ? null : separator!.height, child: separator)
                                              : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({this.color, this.elevation, this.selectedIndex, required this.resize, required this.itemHeight, this.dropdownDecoration})
    : _painter =
          dropdownDecoration
              ?.copyWith(color: dropdownDecoration.color ?? color, boxShadow: dropdownDecoration.boxShadow ?? kElevationToShadow[elevation])
              .createBoxPainter(() {}) ??
          BoxDecoration(
            // If you add an image here, you must provide a real
            // configuration in the paint() function and you must provide some sort
            // of onChanged callback here.
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            boxShadow: kElevationToShadow[elevation],
          ).createBoxPainter(),
      super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final Animation<double> resize;
  final double itemHeight;
  final BoxDecoration? dropdownDecoration;

  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final Tween<double> top = Tween<double>(
      //Begin at 0.0 instead of selectedItemOffset so that the menu open animation
      //always start from top to bottom instead of starting from the selected item
      begin: 0.0,
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(begin: _clampDouble(top.begin! + itemHeight, math.min(itemHeight, size.height), size.height), end: size.height);

    final Rect rect = Rect.fromLTRB(0.0, top.evaluate(resize), size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.selectedIndex != selectedIndex ||
        oldPainter.dropdownDecoration != dropdownDecoration ||
        oldPainter.itemHeight != itemHeight ||
        oldPainter.resize != resize;
  }
}

class DropdownItem<T> extends _DropdownMenuItemContainer {
  /// Creates a dropdown item.
  ///
  /// The [child] property must be set.
  const DropdownItem({
    required super.child,
    super.height,
    super.intrinsicHeight,
    super.alignment,
    this.onTap,
    this.value,
    this.enabled = true,
    this.closeOnTap = true,
    super.key,
  });

  /// Called when the dropdown menu item is tapped.
  final VoidCallback? onTap;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [DropdownButton.onChanged].
  final T? value;

  /// Whether or not a user can select this menu item.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Whether the dropdown should close when the item is tapped.
  ///
  /// Defaults to true.
  final bool closeOnTap;

  /// Creates a copy of this DropdownItem but with the given fields replaced with the new values.
  DropdownItem<T> copyWith({
    Widget? child,
    double? height,
    bool? intrinsicHeight,
    void Function()? onTap,
    T? value,
    bool? enabled,
    AlignmentGeometry? alignment,
    bool? closeOnTap,
  }) {
    return DropdownItem<T>(
      height: height ?? this.height,
      intrinsicHeight: intrinsicHeight ?? this.intrinsicHeight,
      onTap: onTap ?? this.onTap,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      alignment: alignment ?? this.alignment,
      closeOnTap: closeOnTap ?? this.closeOnTap,
      child: child ?? this.child,
    );
  }
}

// The container widget for a menu item created by a [DropdownButton2]. It
// provides the default configuration for [DropdownMenuItem]s, as well as a
// [DropdownButton]'s hint and disabledHint widgets.
class _DropdownMenuItemContainer extends StatelessWidget {
  /// Creates an item for a dropdown menu.
  ///
  /// The [child] argument is required.
  const _DropdownMenuItemContainer({
    super.key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
    this.height = _kMenuItemHeight,
    this.intrinsicHeight = false,
  });

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// Defines how the item is positioned within the container.
  ///
  /// Defaults to [AlignmentDirectional.centerStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// The height of the menu item, default value is [kMinInteractiveDimension]
  final double height;

  /// If set to true, then this item's height will vary according to its
  /// intrinsic height instead of using [height] property.
  ///
  /// Note: If set to true and there isn't enough vertical room for the menu, there's
  /// no way to know the item's intrinsic height in-advance to properly scroll to
  /// the selected item. Instead, the provided [height] value will be used, which means
  /// the menu's initial scroll offset may not properly scroll to the selected item.
  final bool intrinsicHeight;

  @override
  Widget build(BuildContext context) {
    return Container(height: intrinsicHeight ? null : height, alignment: alignment, child: child);
  }
}

// The widget that is the button wrapping the menu items.
class _DropdownItemButton<T> extends StatefulWidget {
  const _DropdownItemButton({
    super.key,
    required this.route,
    required this.textDirection,
    required this.buttonRect,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.itemIndex,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final TextDirection? textDirection;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final int itemIndex;
  final bool enableFeedback;

  @override
  _DropdownItemButtonState<T> createState() => _DropdownItemButtonState<T>();
}

class _DropdownItemButtonState<T> extends State<_DropdownItemButton<T>> {
  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        inTraditionalMode = false;
        break;
      case FocusHighlightMode.traditional:
        inTraditionalMode = true;
        break;
    }

    if (focused && inTraditionalMode) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(widget.buttonRect, widget.constraints.maxHeight, widget.mediaQueryPadding, widget.itemIndex);
      widget.route.scrollController!.animateTo(menuLimits.scrollOffset, curve: Curves.easeInOut, duration: const Duration(milliseconds: 100));
    }
  }

  void _handleOnTap() {
    final DropdownItem<T> dropdownItem = widget.route.items[widget.itemIndex];

    dropdownItem.onTap?.call();

    if (dropdownItem.closeOnTap) {
      Navigator.pop(context, _DropdownRouteResult<T>(dropdownItem.value));
    }
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts = <ShortcutActivator, Intent>{
    // On the web, up/down don't change focus, *except* in a <select>
    // element, which is what a dropdown emulates.
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  };

  MenuItemStyleData get menuItemStyle => widget.route.menuItemStyle;

  @override
  Widget build(BuildContext context) {
    final double menuCurveEnd = widget.route.dropdownStyle.openInterval.end;

    final DropdownItem<T> dropdownItem = widget.route.items[widget.itemIndex];
    final double unit = 0.5 / (widget.route.items.length + 1.5);
    final double start = _clampDouble(menuCurveEnd + (widget.itemIndex + 1) * unit, 0.0, 1.0);
    final double end = _clampDouble(start + 1.5 * unit, 0.0, 1.0);
    final CurvedAnimation opacity = CurvedAnimation(parent: widget.route.animation!, curve: Interval(start, end));

    Widget child = Container(padding: (menuItemStyle.padding ?? _kMenuItemPadding).resolve(widget.textDirection), child: dropdownItem);
    // An [InkWell] is added to the item only if it is enabled
    // isNoSelectedItem to avoid first item highlight when no item selected
    if (dropdownItem.enabled) {
      final bool isSelectedItem = !widget.route.isNoSelectedItem && widget.itemIndex == widget.route.selectedIndex;
      child = InkWell(
        autofocus: isSelectedItem,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        borderRadius: menuItemStyle.borderRadius,
        overlayColor: menuItemStyle.overlayColor,
        child: isSelectedItem ? menuItemStyle.selectedMenuItemBuilder?.call(context, child) ?? child : child,
      );
    }
    child = FadeTransition(opacity: opacity, child: child);
    if (kIsWeb && dropdownItem.enabled) {
      child = Shortcuts(shortcuts: _webShortcuts, child: child);
    }
    return child;
  }
}

class DropdownSeparator<T> extends DropdownItem<T> {
  /// Creates a dropdown separator.
  const DropdownSeparator({required super.child, super.height, super.enabled = false, super.key});
}

class _DropdownRoute<T> extends PopupRoute<_DropdownRouteResult<T>> {
  _DropdownRoute({
    required this.items,
    required this.buttonRect,
    required this.selectedIndex,
    required this.isNoSelectedItem,
    required this.capturedThemes,
    required this.style,
    required this.barrierDismissible,
    this.barrierColor,
    this.barrierLabel,
    required this.parentFocusNode,
    required this.enableFeedback,
    required this.dropdownStyle,
    required this.menuItemStyle,
    required this.searchData,
    this.dropdownSeparator,
  }) : itemHeights = addSeparatorsHeights(itemHeights: items.map((item) => item.height).toList(), separatorHeight: dropdownSeparator?.height);

  final List<DropdownItem<T>> items;
  final ValueNotifier<Rect?> buttonRect;
  final int selectedIndex;
  final bool isNoSelectedItem;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final FocusNode parentFocusNode;
  final bool enableFeedback;
  final DropdownStyleData dropdownStyle;
  final MenuItemStyleData menuItemStyle;
  final DropdownSearchData<T>? searchData;
  final DropdownSeparator<T>? dropdownSeparator;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kDropdownMenuDuration;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  final FocusScopeNode _childNode = FocusScopeNode(debugLabel: 'Child');

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FocusScope.withExternalFocusNode(
      focusScopeNode: _childNode,
      parentNode: parentFocusNode,
      child: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
          //Exclude BottomInset from maxHeight to avoid overlapping menu items
          //with keyboard when using searchable dropdown.
          //This will ensure menu is drawn in the actual available height.
          final MediaQueryData mediaQuery = MediaQuery.of(ctx);
          final BoxConstraints actualConstraints = constraints.copyWith(maxHeight: constraints.maxHeight - mediaQuery.viewInsets.bottom);
          final EdgeInsets mediaQueryPadding = dropdownStyle.useSafeArea ? mediaQuery.padding : EdgeInsets.zero;
          return ValueListenableBuilder<Rect?>(
            valueListenable: buttonRect,
            builder: (BuildContext context, Rect? rect, _) {
              return _DropdownRoutePage<T>(
                route: this,
                constraints: actualConstraints,
                mediaQueryPadding: mediaQueryPadding,
                buttonRect: rect!,
                selectedIndex: selectedIndex,
                capturedThemes: capturedThemes,
                style: style,
                enableFeedback: enableFeedback,
              );
            },
          );
        },
      ),
    );
  }

  void _dismiss() {
    if (isActive) {
      _childNode.dispose();
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    final double paddingTop = dropdownStyle.padding != null ? dropdownStyle.padding!.resolve(null).top : kMaterialListPadding.top;
    double offset = paddingTop;

    if (items.isNotEmpty && index > 0) {
      assert(items.length + (dropdownSeparator != null ? items.length - 1 : 0) == itemHeights.length);
      offset += itemHeights.sublist(0, index).reduce((double total, double height) => total + height);
    }

    return offset;
  }

  // Returns the vertical extent of the menu and the initial scrollOffset
  // for the ListView that contains the menu items.
  _MenuLimits getMenuLimits(Rect buttonRect, double availableHeight, EdgeInsets mediaQueryPadding, int index) {
    double maxHeight = getMenuAvailableHeight(availableHeight, mediaQueryPadding);
    // If a preferred MaxHeight is set by the user, use it instead of the available maxHeight.
    final double? preferredMaxHeight = dropdownStyle.maxHeight;
    if (preferredMaxHeight != null) {
      maxHeight = math.min(maxHeight, preferredMaxHeight);
    }

    double actualMenuHeight = dropdownStyle.padding?.vertical ?? kMaterialListPadding.vertical;
    final double innerWidgetHeight = searchData?.searchBarWidgetHeight ?? 0.0;
    actualMenuHeight += innerWidgetHeight;
    if (items.isNotEmpty) {
      actualMenuHeight += itemHeights.reduce((double total, double height) => total + height);
    }

    // Use actualMenuHeight if it's less than maxHeight.
    // Otherwise, maxHeight will be used, as if there are too many elements in
    // the menu, we need to shrink it down so it is at most the maxHeight.
    final double menuHeight = math.min(maxHeight, actualMenuHeight);

    // The computed top and bottom of the menu
    double menuTop = dropdownStyle.isOverButton ? buttonRect.top - dropdownStyle.offset.dy : buttonRect.bottom - dropdownStyle.offset.dy;
    double menuBottom = menuTop + menuHeight;

    // If the computed top or bottom of the menu are outside of the range
    // specified, we need to bring them into range.
    // `mediaQueryPadding` should be considered (equals to 0.0 if useSafeArea is false).
    final double topLimit = mediaQueryPadding.top;
    final double bottomLimit = availableHeight - mediaQueryPadding.bottom;
    if (menuTop < topLimit) {
      menuTop = topLimit;
      menuBottom = menuTop + menuHeight;
    } else if (menuBottom > bottomLimit) {
      menuBottom = bottomLimit;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // If all of the menu items will not fit within maxHeight then
    // compute the scroll offset that will line the selected menu item up
    // with the select item. This is only done when the menu is first
    // shown - subsequently we leave the scroll offset where the user left it.
    if (actualMenuHeight > maxHeight) {
      //menuHeight & actualMenuHeight without innerWidget's Height
      final double menuNetHeight = menuHeight - innerWidgetHeight;
      final double actualMenuNetHeight = actualMenuHeight - innerWidgetHeight;
      // The offset should be zero if the selected item is in view at the beginning
      // of the menu. Otherwise, the scroll offset should center the item if possible.
      final actualIndex = dropdownSeparator?.height != null ? index * 2 : index;
      final double selectedItemOffset = getItemOffset(actualIndex);
      scrollOffset = math.max(0.0, selectedItemOffset - (menuNetHeight / 2) + (itemHeights[actualIndex] / 2));
      // If the selected item's scroll offset is greater than the maximum scroll offset,
      // set it instead to the maximum allowed scroll offset.
      final double maxScrollOffset = actualMenuNetHeight - menuNetHeight;
      scrollOffset = math.min(scrollOffset, maxScrollOffset);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }

  // The maximum height of a simple menu should be one or more rows less than
  // the view height. This ensures a tappable area outside of the simple menu
  // with which to dismiss the menu.
  //   -- https://material.io/design/components/menus.html#usage
  double getMenuAvailableHeight(double availableHeight, EdgeInsets mediaQueryPadding) {
    return math.max(0.0, availableHeight - mediaQueryPadding.vertical - _kMenuItemHeight);
  }
}

class _DropdownRoutePage<T> extends StatelessWidget {
  const _DropdownRoutePage({
    super.key,
    required this.route,
    required this.constraints,
    required this.mediaQueryPadding,
    required this.buttonRect,
    required this.selectedIndex,
    this.elevation = 8,
    required this.capturedThemes,
    this.style,
    required this.enableFeedback,
  });

  final _DropdownRoute<T> route;
  final BoxConstraints constraints;
  final EdgeInsets mediaQueryPadding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // Computing the initialScrollOffset now, before the items have been laid
    // out. This only works if the item heights are effectively fixed, i.e. either
    // DropdownButton.itemHeight is specified or DropdownButton.itemHeight is null
    // and all of the items' intrinsic heights are less than _kMenuItemHeight.
    // Otherwise the initialScrollOffset is just a rough approximation based on
    // treating the items as if their heights were all equal to _kMenuItemHeight.
    if (route.scrollController == null) {
      final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, constraints.maxHeight, mediaQueryPadding, selectedIndex);
      route.scrollController = ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);

    final Widget menu = _DropdownMenu<T>(
      route: route,
      textDirection: textDirection,
      buttonRect: buttonRect,
      constraints: constraints,
      mediaQueryPadding: mediaQueryPadding,
      enableFeedback: enableFeedback,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _DropdownMenuRouteLayout<T>(
              route: route,
              textDirection: textDirection,
              buttonRect: buttonRect,
              availableHeight: constraints.maxHeight,
              mediaQueryPadding: mediaQueryPadding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

class _DropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _DropdownMenuRouteLayout({
    required this.route,
    required this.buttonRect,
    required this.availableHeight,
    required this.mediaQueryPadding,
    required this.textDirection,
  });

  final _DropdownRoute<T> route;
  final Rect buttonRect;
  final double availableHeight;
  final EdgeInsets mediaQueryPadding;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double? itemWidth = route.dropdownStyle.width;
    double maxHeight = route.getMenuAvailableHeight(availableHeight, mediaQueryPadding);
    final double? preferredMaxHeight = route.dropdownStyle.maxHeight;
    if (preferredMaxHeight != null && preferredMaxHeight <= maxHeight) {
      maxHeight = preferredMaxHeight;
    }
    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final double width = math.min(constraints.maxWidth, itemWidth ?? buttonRect.width);
    return BoxConstraints(minWidth: width, maxWidth: width, maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits = route.getMenuLimits(buttonRect, availableHeight, mediaQueryPadding, route.selectedIndex);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // If the button was entirely on-screen, then verify
        // that the menu is also on-screen.
        // If the button was a bit off-screen, then, oh well.
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);

    final Offset offset = route.dropdownStyle.offset;
    final double left;

    switch (route.dropdownStyle.direction) {
      case DropdownDirection.textDirection:
        switch (textDirection!) {
          case TextDirection.rtl:
            left = _clampDouble(buttonRect.right - childSize.width + offset.dx, 0.0, size.width - childSize.width);
            break;
          case TextDirection.ltr:
            left = _clampDouble(buttonRect.left + offset.dx, 0.0, size.width - childSize.width);
            break;
        }
        break;
      case DropdownDirection.right:
        left = _clampDouble(buttonRect.left + offset.dx, 0.0, size.width - childSize.width);
        break;
      case DropdownDirection.left:
        left = _clampDouble(buttonRect.right - childSize.width + offset.dx, 0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_DropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect || textDirection != oldDelegate.textDirection;
  }
}

// We box the return value so that the return value can be null. Otherwise,
// canceling the route (which returns null) would get confused with actually
// returning a real null value.
@immutable
class _DropdownRouteResult<T> {
  const _DropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) {
    return other is _DropdownRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class ButtonStyleData {
  /// Creates a ButtonStyleData.
  const ButtonStyleData({this.height, this.width, this.padding, this.decoration, this.foregroundDecoration, this.elevation, this.overlayColor});

  /// The height of the button
  final double? height;

  /// The width of the button
  final double? width;

  /// The inner padding of the Button
  final EdgeInsetsGeometry? padding;

  /// The decoration of the Button
  final BoxDecoration? decoration;

  /// The decoration to paint in front of the Button
  final BoxDecoration? foregroundDecoration;

  /// The elevation of the Button
  final int? elevation;

  /// Defines the ink response focus, hover, and splash colors.
  ///
  /// This default null property can be used as an alternative to
  /// [focusColor], [hoverColor], [highlightColor], and
  /// [splashColor]. If non-null, it is resolved against one of
  /// [WidgetState.focused], [WidgetState.hovered], and
  /// [WidgetState.pressed]. It's convenient to use when the parent
  /// widget can pass along its own MaterialStateProperty value for
  /// the overlay color.
  ///
  /// [WidgetState.pressed] triggers a ripple (an ink splash), per
  /// the current Material Design spec. The [overlayColor] doesn't map
  /// a state to [highlightColor] because a separate highlight is not
  /// used by the current design guidelines. See
  /// https://material.io/design/interaction/states.html#pressed
  ///
  /// If the overlay color is null or resolves to null, then [focusColor],
  /// [hoverColor], [splashColor] and their defaults are used instead.
  ///
  /// See also:
  ///
  ///  * The Material Design specification for overlay colors and how they
  ///    match a component's state:
  ///    <https://material.io/design/interaction/states.html#anatomy>.
  final WidgetStateProperty<Color?>? overlayColor;
}

/// A class to configure the theme of the button's icon.
class IconStyleData {
  /// Creates an IconStyleData.
  const IconStyleData({this.icon = const Icon(Icons.arrow_drop_down), this.iconDisabledColor, this.iconEnabledColor, this.iconSize = 24, this.openMenuIcon});

  /// The widget to use for the drop-down button's suffix icon.
  ///
  /// Defaults to an [Icon] with the [Icons.arrow_drop_down] glyph.
  final Widget icon;

  /// The color of any [Icon] descendant of [icon] if this button is disabled,
  /// i.e. if [onChanged] is null.
  ///
  /// Defaults to [MaterialColor.shade400] of [Colors.grey] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white10] when it is [Brightness.dark]
  final Color? iconDisabledColor;

  /// The color of any [Icon] descendant of [icon] if this button is enabled,
  /// i.e. if [onChanged] is defined.
  ///
  /// Defaults to [MaterialColor.shade700] of [Colors.grey] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white70] when it is [Brightness.dark]
  final Color? iconEnabledColor;

  /// The size to use for the drop-down button's icon.
  ///
  /// Defaults to 24.0.
  final double iconSize;

  /// Shows different icon when dropdown menu is open
  final Widget? openMenuIcon;
}

/// A class to configure the theme of the dropdown menu.
class DropdownStyleData {
  /// Creates a DropdownStyleData.
  const DropdownStyleData({
    this.maxHeight,
    this.width,
    this.padding,
    this.scrollPadding,
    this.decoration,
    this.elevation = 8,
    this.direction = DropdownDirection.textDirection,
    this.offset = Offset.zero,
    this.isOverButton = false,
    this.useSafeArea = true,
    this.useRootNavigator = false,
    this.scrollbarTheme,
    this.openInterval = const Interval(0.25, 0.5),
  });

  /// The maximum height of the dropdown menu
  ///
  /// The maximum height of the menu must be at least one row shorter than
  /// the height of the app's view. This ensures that a tappable area
  /// outside of the simple menu is present so the user can dismiss the menu.
  ///
  /// If this property is set above the maximum allowable height threshold
  /// mentioned above, then the menu defaults to being padded at the top
  /// and bottom of the menu by at one menu item's height.
  final double? maxHeight;

  /// The width of the dropdown menu
  final double? width;

  /// The inner padding of the dropdown menu
  ///
  /// The horizontal padding will be added to the button's padding as well, ensuring that
  /// the menu width and button width adapt seamlessly to the maximum width of the items.
  final EdgeInsetsGeometry? padding;

  /// The inner padding of the dropdown menu including the scrollbar
  ///
  /// The horizontal padding will be added to the button's padding as well, ensuring that
  /// the menu width and button width adapt seamlessly to the maximum width of the items.
  final EdgeInsetsGeometry? scrollPadding;

  /// The decoration of the dropdown menu
  final BoxDecoration? decoration;

  /// The z-coordinate at which to place the menu when open.
  ///
  /// The following elevations have defined shadows: 1, 2, 3, 4, 6, 8, 9, 12,
  /// 16, and 24. See [kElevationToShadow].
  ///
  /// Defaults to 8, the appropriate elevation for dropdown buttons.
  final int elevation;

  /// The direction of the dropdown menu in relation to the button.
  ///
  /// Default is [DropdownDirection.textDirection]
  final DropdownDirection direction;

  /// Changes the position of the dropdown menu
  final Offset offset;

  /// Opens the dropdown menu over the button instead of below it
  final bool isOverButton;

  /// Determine if the dropdown menu should only display in safe areas of the screen.
  /// It is true by default, which means the dropdown menu will not overlap
  /// operating system areas.
  final bool useSafeArea;

  /// Determine whether to open the dropdown menu using the root Navigator or not.
  /// If it's set to to true, dropdown menu will be pushed above all subsequent
  /// instances of the root navigator such as AppBar/TabBar. By default, it is false.
  final bool useRootNavigator;

  /// Configures the theme of the menu's scrollbar
  final ScrollbarThemeData? scrollbarTheme;

  /// The animation curve used for opening the dropdown menu (forward direction)
  final Interval openInterval;
}

/// A class to configure the theme of the dropdown menu items.
class MenuItemStyleData {
  /// Creates a MenuItemStyleData.
  const MenuItemStyleData({this.padding, this.borderRadius, this.overlayColor, this.selectedMenuItemBuilder});

  /// The padding applied to each menu item.
  ///
  /// The horizontal padding will be added to the button's padding as well, ensuring that
  /// the menu width and button width adapt seamlessly to the maximum width of the items.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the menu item.
  final BorderRadius? borderRadius;

  /// Defines the ink response focus, hover, and splash colors.
  ///
  /// This default null property can be used as an alternative to
  /// [focusColor], [hoverColor], [highlightColor], and
  /// [splashColor]. If non-null, it is resolved against one of
  /// [WidgetState.focused], [WidgetState.hovered], and
  /// [WidgetState.pressed]. It's convenient to use when the parent
  /// widget can pass along its own MaterialStateProperty value for
  /// the overlay color.
  ///
  /// [WidgetState.pressed] triggers a ripple (an ink splash), per
  /// the current Material Design spec. The [overlayColor] doesn't map
  /// a state to [highlightColor] because a separate highlight is not
  /// used by the current design guidelines. See
  /// https://material.io/design/interaction/states.html#pressed
  ///
  /// If the overlay color is null or resolves to null, then [focusColor],
  /// [hoverColor], [splashColor] and their defaults are used instead.
  ///
  /// See also:
  ///
  ///  * The Material Design specification for overlay colors and how they
  ///    match a component's state:
  ///    <https://material.io/design/interaction/states.html#anatomy>.
  final WidgetStateProperty<Color?>? overlayColor;

  /// A builder to customize the selected menu item.
  ///
  /// If this callback is null, the selected menu item will be displayed as other [items].
  ///
  /// You should return the child from the builder wrapped with the widget that
  /// customize your item, i.e:
  /// ```dart
  /// selectedMenuItemBuilder: (ctx, child) {
  ///   return Container(
  ///     color: Colors.blue,
  ///     child: child,
  ///   );
  /// },
  /// ```
  final SelectedMenuItemBuilder? selectedMenuItemBuilder;
}

/// A class to configure searchable dropdowns.
class DropdownSearchData<T> {
  /// Creates a DropdownSearchData.
  const DropdownSearchData({this.searchController, this.searchBarWidget, this.searchBarWidgetHeight, this.noResultsWidget, this.searchMatchFn})
    : assert(
        (searchBarWidget == null) == (searchBarWidgetHeight == null),
        'searchBarWidgetHeight should not be null when using searchBarWidget\n'
        'This is necessary to properly determine menu limits and scroll offset',
      );

  /// The TextEditingController used for searchable dropdowns. If this is null,
  /// then it'll perform as a normal dropdown without searching feature.
  final TextEditingController? searchController;

  /// The widget to use for searchable dropdowns, such as search bar.
  /// It will be shown at the top of the dropdown menu.
  final Widget? searchBarWidget;

  /// The height of the searchBarWidget if used.
  final double? searchBarWidgetHeight;

  /// The widget to show when the search results are empty.
  final Widget? noResultsWidget;

  /// The match function used for searchable dropdowns. If this is null,
  /// then _defaultSearchMatchFn will be used.
  ///
  /// ```dart
  /// _defaultSearchMatchFn = (item, searchValue) =>
  ///   item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
  /// ```
  final SearchMatchFn<T>? searchMatchFn;
}

enum DropdownDirection {
  /// The direction of the dropdown menu in relation to the button follows
  /// text direction from the closest [Directionality] ancestor widget in the tree.
  textDirection,

  /// The direction of the dropdown menu is to the right of the button.
  right,

  /// The direction of the dropdown menu is to the left of the button.
  left,
}

double _clampDouble(double x, double min, double max) {
  assert(min <= max && !max.isNaN && !min.isNaN);
  if (x < min) {
    return min;
  }
  if (x > max) {
    return max;
  }
  if (x.isNaN) {
    return max;
  }
  return x;
}

/// Adds separators to a list of heights.
///
/// The [itemHeights] property is the list of heights of the items.
///
/// The [separatorHeight] property is the height of the separator.
///
/// Returns a new list of heights with separators added.
List<double> addSeparatorsHeights({required List<double> itemHeights, required double? separatorHeight}) {
  final List<double> heights = [];

  bool addSeparator = false;
  if (separatorHeight != null) {
    for (final item in itemHeights) {
      if (addSeparator) {
        heights.add(separatorHeight);
      }
      heights.add(item);
      addSeparator = true;
    }
  } else {
    heights.addAll(itemHeights);
  }

  return heights;
}

// ignore: public_member_api_docs
extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
