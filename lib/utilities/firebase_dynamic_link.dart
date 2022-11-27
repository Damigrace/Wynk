import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AppUtils {
  ///Build a dynamic link firebase
  static Future<String> buildDynamicLink(String vault, String wynkid, String amount) async {
    String url = "https://wynk1.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,

      link: Uri.parse('$url?vault=$vault&wynkid=$wynkid&amount=$amount'),
      androidParameters: AndroidParameters(
        packageName: "",
        minimumVersion: 0,
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
          description: "Welcome to Wynk",
          imageUrl:
          Uri.parse("https://flutter.dev/images/flutter-logo-sharing.png"),
          title: "Wynk Super App"),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}