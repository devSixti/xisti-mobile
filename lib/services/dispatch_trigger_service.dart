import '../services/push_notification_service.dart';

/// Tracks recent FCM dispatch hints so polling can back off after a push.
abstract final class DispatchTriggerService {
  static DateTime? _lastDispatchAt;
  static String _lastAction = '';

  static const Duration recentDispatchWindow = Duration(seconds: 25);
  static const Duration skipPollWindow = Duration(seconds: 8);
  static const Duration fastPollInterval = Duration(seconds: 10);
  static const Duration slowPollInterval = Duration(seconds: 30);

  static void recordFromNotificationData(Map<String, dynamic> data) {
    final action = (data[NotificationConstant.dispatchAction] ?? '').toString();
    if (action.isNotEmpty) {
      _lastAction = action;
    }
    final ts = int.tryParse((data[NotificationConstant.dispatchTs] ?? '').toString());
    _lastDispatchAt = ts != null && ts > 0
        ? DateTime.fromMillisecondsSinceEpoch(ts * 1000)
        : DateTime.now();
  }

  static void recordManualRefresh([String action = 'manual']) {
    _lastAction = action;
    _lastDispatchAt = DateTime.now();
  }

  static String get lastAction => _lastAction;

  static bool get hadRecentDispatch {
    final at = _lastDispatchAt;
    if (at == null) return false;
    return DateTime.now().difference(at) < recentDispatchWindow;
  }

  /// Skip redundant HTTP poll when a push just triggered the same refresh.
  static bool shouldSkipScheduledPoll(String pollAction) {
    final at = _lastDispatchAt;
    if (at == null) return false;
    if (DateTime.now().difference(at) > skipPollWindow) return false;
    if (_lastAction.isEmpty) return false;
    return _lastAction == pollAction;
  }

  static Duration pollingIntervalFor(String pollAction) {
    if (hadRecentDispatch && _lastAction == pollAction) {
      return slowPollInterval;
    }
    return fastPollInterval;
  }
}
