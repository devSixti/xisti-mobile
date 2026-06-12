import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../commonView/common_view.dart';
import '../../../utils/utils.dart';

class WebViewRedirectionScreen extends StatefulWidget {
  final String redirectUrl;
  final String? failUrl, successUrl;
  final Function() onSuccess;
  final Function() onFailed;

  /// When set, the screen detects the merchant callback URL by prefix and
  /// reads [statusQueryParam] from the query string. A value equal to
  /// [successStatusValue] (case-insensitive) triggers [onSuccess]; anything
  /// else triggers [onFailed]. Used by gateways that report status via a
  /// single response_url with query params (e.g. WiPay's ?status=success).
  // final String? callbackUrlPrefix;
  // final String statusQueryParam;
  // final String successStatusValue;

  const WebViewRedirectionScreen({
    super.key,
    required this.redirectUrl,
    this.failUrl,
    this.successUrl,
    required this.onSuccess,
    required this.onFailed,
    // this.callbackUrlPrefix,
    // this.statusQueryParam = "status",
    // this.successStatusValue = "success",
  });

  @override
  State<WebViewRedirectionScreen> createState() => _WebViewRedirectionScreenState();
}

class _WebViewRedirectionScreenState extends State<WebViewRedirectionScreen> {
  bool _showWompiReturnBar = false;

  bool _isWompiCheckoutUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('checkout.wompi.co') || lower.contains('wompi.co/p/') || lower.contains('wompi.co/p?');
  }

  @override
  void initState() {
    _showWompiReturnBar = _isWompiCheckoutUrl(widget.redirectUrl);
    if (widget.redirectUrl.trim().isEmpty) {
      returnFailedResponse();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: ScaffoldWithSafeArea(
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          leading: backButtonForAppBarCustom(
            context: context,
            onBackPress: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _inaApWebView()),
              if (_showWompiReturnBar) _wompiReturnToMerchantBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wompiReturnToMerchantBar() {
    return Material(
      elevation: 6,
      color: getCurrentTheme(context).colorScaffoldBg,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Volver al comercio'),
          ),
        ),
      ),
    );
  }

  Widget _inaApWebView() {
    InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true,
      javaScriptEnabled: true,
      javaScriptCanOpenWindowsAutomatically: true,
      useShouldOverrideUrlLoading: true,
      clearCache: true,
      saveFormData: false,
      safeBrowsingEnabled: true,
      cacheEnabled: false,
      clearSessionCache: true,
      cacheMode: CacheMode.LOAD_NO_CACHE,
      hardwareAcceleration: false,
      useHybridComposition: false,
      transparentBackground: true,
      preferredContentMode: UserPreferredContentMode.MOBILE,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.redirectUrl)),
      initialSettings: settings,
      onLoadStart: (controller, url) {
        final navigationUrl = url?.rawValue ?? "";
        if (mounted && _isWompiCheckoutUrl(navigationUrl) != _showWompiReturnBar) {
          setState(() => _showWompiReturnBar = _isWompiCheckoutUrl(navigationUrl));
        }
        // final callbackResult = _resolveStatusFromCallback(navigationUrl);
        // if (callbackResult == true) {
        //   returnSuccessResponse();
        // } else if (callbackResult == false) {
        //   returnFailedResponse();
        // } else
        if ((widget.successUrl?.isNotEmpty ?? false) && navigationUrl.contains(widget.successUrl!)) {
          returnSuccessResponse();
        } else if ((widget.failUrl?.isNotEmpty ?? false) && navigationUrl.contains(widget.failUrl!)) {
          returnFailedResponse();
        }
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        String navigationUrl = navigationAction.request.url?.rawValue ?? "";
        // final callbackResult = _resolveStatusFromCallback(navigationUrl);
        // if (callbackResult == true) {
        //   returnSuccessResponse();
        //   return NavigationActionPolicy.CANCEL;
        // } else if (callbackResult == false) {
        //   returnFailedResponse();
        //   return NavigationActionPolicy.CANCEL;
        // }
        if ((widget.successUrl?.isNotEmpty ?? false) && navigationUrl.contains(widget.successUrl!)) {
          returnSuccessResponse();
          return NavigationActionPolicy.CANCEL;
        } else if ((widget.failUrl?.isNotEmpty ?? false) && navigationUrl.contains(widget.failUrl!)) {
          returnFailedResponse();
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  /// Returns `true` if the URL is the merchant callback and reports success,
  /// `false` if it's the callback but reports any other status, or `null`
  /// when the callback-prefix mode is not configured or the URL doesn't
  /// match the prefix (let the substring fallback decide).
  // bool? _resolveStatusFromCallback(String url) {
  //   final prefix = widget.callbackUrlPrefix;
  //   if (prefix == null || prefix.isEmpty) return null;
  //   if (!url.startsWith(prefix)) return null;
  //   final uri = Uri.tryParse(url);
  //   if (uri == null) return false;
  //   final status = uri.queryParameters[widget.statusQueryParam] ?? "";
  //   return status.toLowerCase() == widget.successStatusValue.toLowerCase();
  // }

  void returnFailedResponse() {
    widget.onFailed.call();
    Navigator.pop(context, false);
  }

  void returnSuccessResponse() {
    widget.onSuccess.call();
    Navigator.pop(context, true);
  }
}

void paymentMethodCheck(
  final BuildContext context,
  int paymentMethod,

  /// This list takes payment types which need to be verified
  /// because some of payment type like Cash no need to verifies alternatively we directly called onSuccess in Cash payment
  List<int> checkForPaymentTypes, {

  /// this param [successUrl] is webViewRedirection success url
  /// when webViewRedirection is success this url check with current webViewRedirection success url
  /// and both are same then webViewRedirection is success
  required String successUrl,

  /// this param [failedUrl] is webViewRedirection failed url
  /// when webViewRedirection is failed this url check with current webViewRedirection failed url
  /// and both are same then webViewRedirection is failed
  required String failedUrl,

  /// this param [redirectUrl] is webViewRedirection gateway url
  /// when webViewRedirection web view is build this url is used to show first page of web view
  required String redirectUrl,

  /// this function of [onSuccess] called when transaction is success
  /// if success url match then this function is called
  required Function() onSuccess,

  /// this function of [onFailed] called when transaction is failed
  /// if any reason webViewRedirection failed this function is called
  required Function() onFailed,
}) {
  if (checkForPaymentTypes.contains(paymentMethod)) {
    openScreen(
      context,
      WebViewRedirectionScreen(
        redirectUrl: redirectUrl,
        failUrl: failedUrl,
        successUrl: successUrl,
        onSuccess: () {
          onSuccess.call();
        },
        onFailed: () {
          onFailed.call();
        },
      ),
    );
  } else {
    onSuccess.call();
  }
}

/// Below method use to called within [openScreenWithResult] to overcome some issue facing like screen not opening and anything else
Future<void> paymentMethodCheckUsingOpenScreenWithResult(
  final BuildContext context,
  int paymentMethod,

  /// This list takes payment types which need to be verified
  /// because some of payment type like Cash no need to verifies alternatively we directly called onSuccess in Cash payment
  List<int> checkForPaymentTypes, {

  /// this param [successUrl] is webViewRedirection success url
  /// when webViewRedirection is success this url check with current webViewRedirection success url
  /// and both are same then webViewRedirection is success
  required String successUrl,

  /// this param [failedUrl] is webViewRedirection failed url
  /// when webViewRedirection is failed this url check with current webViewRedirection failed url
  /// and both are same then webViewRedirection is failed
  required String failedUrl,

  /// this param [redirectUrl] is webViewRedirection gateway url
  /// when webViewRedirection web view is build this url is used to show first page of web view
  required String redirectUrl,

  /// this function of [onSuccess] called when transaction is success
  /// if success url match then this function is called
  required Function() onSuccess,

  /// this function of [onFailed] called when transaction is failed
  /// if any reason webViewRedirection failed this function is called
  required Function() onFailed,
}) async {
  if (checkForPaymentTypes.contains(paymentMethod)) {
    await openScreenWithResult(
      context,
      WebViewRedirectionScreen(
        redirectUrl: redirectUrl,
        failUrl: failedUrl,
        successUrl: successUrl,
        onSuccess: () {},
        onFailed: () {},
      ),
    ).then((value) {
      if (value ?? false) {
        onSuccess.call();
      } else {
        onFailed.call();
      }
    });
  } else {
    onSuccess.call();
  }
}
