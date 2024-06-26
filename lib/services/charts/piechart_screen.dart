import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PieChartScreen extends StatelessWidget {
  PieChartScreen({super.key});

  late final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(false)
    ..clearCache()
    ..setBackgroundColor(Colors.transparent)
    ..loadFlutterAsset('assets/js/hc_index.html')
    ..setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        if (webViewController.platform is AndroidWebViewController) {
          AndroidWebViewController.enableDebugging(kDebugMode);
        }

        if (webViewController.platform is WebKitWebViewController) {
          final WebKitWebViewController webKitWebViewController =
              webViewController.platform as WebKitWebViewController;
          webKitWebViewController.setInspectable(kDebugMode);
        }
      },
      onPageFinished: (url) {
        //serialize your data models to string
        const xyValue = ''' 
      [
        {
            name: 'Grocery',
            colorByPoint: true,
            data: [
                {
                    name: 'Mango',
                    y: 11.04,
                    drilldown: 'Chrome'
                },
                {
                    name: 'watermelon ',
                    y: 19.47,
                    drilldown: 'Safari'
                },
                {
                    name: 'Grapes',
                    y: 9.32,
                    drilldown: 'Edge'
                },
                {
                    name: 'Oranges',
                    y: 8.15,
                    drilldown: 'Firefox'
                },
                {
                    name: 'Other',
                    y: 11.02,
                    drilldown: null
                }
            ]
        }
    ]
    ''';
        webViewController.runJavaScript('jsPieChartFunc($xyValue);');
      },
    ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: WebViewWidget(
          controller: webViewController,
        ));
  }
}
