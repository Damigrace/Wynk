import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TandC extends StatefulWidget {
  const TandC({super.key});

  @override
  State<TandC> createState() => _TandCState();
}

class _TandCState extends State<TandC> {
  int loadingPercentage = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          WebView(
            onPageStarted: (url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
            onWebViewCreated:(webViewController){
            } ,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'https://wynk.ng/wynk-terms-conditions.html'),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),

        ],
      ),
    );
  }
}