import 'package:campuspro/Controllers/appbar_controller.dart';
import 'package:campuspro/Controllers/bottombar_controller.dart';
import 'package:campuspro/Controllers/web_controller.dart';
import 'package:campuspro/Screens/Wedgets/common_appbar.dart';
import 'package:campuspro/Screens/Wedgets/drawer.dart';
import 'package:campuspro/Screens/Wedgets/bottom_bar.dart';
import 'package:campuspro/Services/urlLuncher/web_url_luncher.dart';
import 'package:campuspro/Utilities/constant.dart';
import 'package:campuspro/Utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebController webController = Get.find<WebController>();
  final AppbarController appbarController = Get.find<AppbarController>();

  @override
  Widget build(BuildContext context) {
    final AppbarController appbarController = Get.find<AppbarController>();
    late InAppWebViewController webViewController;

    final BottomBarController bottomBarController =
        Get.find<BottomBarController>();

    String extractPhoneNumber(String url) {
      final RegExp phoneRegExp = RegExp(r'tel:(\d+)');
      final Match? match = phoneRegExp.firstMatch(url);
      return match != null ? match.group(1) ?? '' : '';
    }

    return WillPopScope(
      onWillPop: () async {
        if (appbarController.appBarName.value == Constant.schoolName) {
          Get.back();
          return true;
        } else {
          appbarController.appBarName.value = Constant.schoolName;
          webController.generateWebUrl('Index.aspx', 'Dashboard');
          bottomBarController.selectedBottomNavIndex.value = 0;
          return false;
        }
      },
      child: Scaffold(
        appBar: customAppBar(context),
        bottomNavigationBar: Obx(
          () => BottomNavBar(
            currentIndex: bottomBarController.selectedBottomNavIndex.value,
            onTap: bottomBarController.onItemTappedChangeBottomNavIndex,
          ),
        ),
        drawer: AppDrawer(context),
        body: Obx(() {
          if (webController.currentUrl.isNotEmpty) {
            return InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri("${webController.currentUrl.value}")),
                // initialSettings: InAppWebViewSettings(
                //     useHybridComposition: true, useOnDownloadStart: true),
                initialOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(
                      domStorageEnabled: true,
                      databaseEnabled: true,
                      allowFileAccess: true,
                      disableDefaultErrorPage: true,
                      allowContentAccess: true,
                      geolocationEnabled: true,
                      thirdPartyCookiesEnabled: true,
                      useHybridComposition: true,
                      loadsImagesAutomatically: true),
                  crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      cacheEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      useOnDownloadStart: true),
                ),
                onReceivedError: (controller, request, error) {
                  if (request.url.host.contains('meet.google.com') ||
                      request.url.toString().contains('tel:')) {
                    controller.goBack();
                  }
                },
                onWebViewCreated: (InAppWebViewController controller) =>
                    webViewController = controller,
                onLoadStart:
                    (InAppWebViewController controller, Uri? url) async {
                  if (url != null &&
                      (url.host.contains('meet.google.com') ||
                          url.toString().contains('tel:'))) {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: extractPhoneNumber(url.toString()),
                    );
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    } else {
                      throw 'Could not launch ${url.toString()}';
                    }
                  } else if (url
                      .toString()
                      .contains("Student/OnlineTest.aspx")) {
                    UrlLuncher.launchUrls(url.toString());
                    appbarController.appBarName.value = Constant.schoolName;
                    webController.currentUrl.value = url.toString();
                    webController.generateWebUrl('Index.aspx', 'Dashboard');
                  }
                },
                onLoadStop:
                    (InAppWebViewController controller, Uri? url) async {
                  await controller.evaluateJavascript(
                      source:
                          "window.localStorage.setItem('key', 'localStorage value!')");
                  if (url
                      .toString()
                      .contains("https://app.campuspro.in/Login.aspx")) {
                    Get.offAllNamed(Routes.userType);
                  }
                },
                onDownloadStartRequest: (
                  controller,
                  url,
                ) async {
                  final String urlFiles = "${url.url}";
                  void launchURLFiles() async => await canLaunchUrl(
                        Uri.parse(urlFiles),
                      )
                          ? await launchUrl(Uri.parse(urlFiles))
                          : throw 'Could not launch $urlFiles';
                  launchURLFiles();
                },
                shouldOverrideUrlLoading: (controller, action) async {
                  if (action.request.url.toString().contains("phonepe://") ||
                      action.request.url.toString().contains("tez://") ||
                      action.request.url.toString().contains("upi://") ||
                      action.request.url.toString().contains("paytmmp://")) {
                    return NavigationActionPolicy.CANCEL;
                  } else if (action.request.url != null &&
                      (action.request.url!.host.contains('meet.google.com') ||
                          action.request.url!.toString().contains('tel:'))) {
                    launchUrl(
                      Uri.parse(action.request.url!.toString()),
                      mode: LaunchMode.externalApplication,
                    );
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
