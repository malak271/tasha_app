
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JawwalPayScreen extends StatelessWidget {

  String jawwalPayUrl;
  JawwalPayScreen({required this.jawwalPayUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إكمال عملية الدفع',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        leading: Icon(Icons.arrow_back),
      ),
      body: WebView(
        initialUrl: jawwalPayUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
