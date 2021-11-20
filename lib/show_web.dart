import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
}

class ShowWeb extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<ShowWeb> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "https://banice.thairoyalfrozen.com/users/login_bypass";
  WebStorageManager webStorageManager = WebStorageManager.instance();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    // initialUrlRequest: URLRequest(
                    //   url: Uri.parse(
                    //       "https://banice.thairoyalfrozen.com/users/login_bypass"),
                    // ),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated:
                        (InAppWebViewController controller) async {
                      webViewController = controller;
                      webStorageManager.android.deleteAllData();
                      final receiveData =
                          ModalRoute.of(context)!.settings.arguments;
                      //var result = getDataFromJson(jsonEncode(receiveData));
                      String token = receiveData.toString();
                      var url = Uri.parse(
                          "https://banice.thairoyalfrozen.com/users/login_bypass");
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: url,
                          method: 'POST',
                          body: Uint8List.fromList(utf8.encode("token=$token")),
                          headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                          },
                        ),
                      );
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setString('tk', token);
                      });
                      // await controller.evaluateJavascript(
                      //     source: "window.localStorage.setItem('user', zz)");
                      // await controller.evaluateJavascript(
                      //     source: "alert(window.localStorage.getItem('user'))");
                    },
                    onLoadStart:
                        (InAppWebViewController controller, url) async {
                      setState(() {
                        this.url = url.toString();

                        //urlController.text = this.url;
                      });
                    },
                    onLoadStop: (InAppWebViewController controller, url) async {
                      //print('sssssssssssssssssssss');
                      //print(url);

                      //await controller.evaluateJavascript(
                      //  source:
                      //    "alert(window.localStorage.getItem('token'))");

                      pullToRefreshController.endRefreshing();
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
