import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todaylang/main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

const _initialUrl = 'https://airtable.com/shrZa0mMbd2zu7CiR';
// Define the name of the JS channel used to communicate between the WebView and Flutter
const _jsFormSubmittedChannel = 'FormSubmittedChannel';

// Javascript snippet to intercept XHR and post a message back using JS Channel
const _interceptXHRJS = '''
var XHR = XMLHttpRequest.prototype;
var open = XHR.open;  
var send = XHR.send;
function openReplacement(method, url, async, user, password) {  
  this._url = url;
  return open.apply(this, arguments);
}
function sendReplacement(data) {  
  // drop all lightstep requests
  if (this._url.includes("lightstep")) return;
  
  if(this.onreadystatechange) {
    this._onreadystatechange = this.onreadystatechange;
  }
  
  this.onreadystatechange = onReadyStateChangeReplacement;
  return send.apply(this, arguments);
}
function onReadyStateChangeReplacement() {  
  if (this._url.includes('submitSharedForm') && this.readyState == XMLHttpRequest.DONE) {
    FormSubmittedChannel.postMessage(this.responseText); 
  }
  
  if(this._onreadystatechange) {
    return this._onreadystatechange.apply(this, arguments);
  }
}
XHR.open = openReplacement;
XHR.send = sendReplacement;
'success'
''';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late final WebViewController webViewController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          _progress < 1.0
              ? LinearProgressIndicator(value: _progress)
              : Container(),
          Expanded(
            child: WebView(
              initialUrl: _initialUrl,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                  name: _jsFormSubmittedChannel,
                  onMessageReceived: (message) {
                    // print('Received message from channel: ${message.message}');

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Submitted')));
                    // Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text('Submitted')));
                    Navigator.pop(context, true);
                    //Get.to(() => MyApp());
                  },
                )
              },
              onPageStarted: (url) async {
                webViewController.evaluateJavascript(
                    "document.getElementByTagName('footer').style.display='none'");
              },
              onPageFinished: (url) async {
                final result =
                    await webViewController.evaluateJavascript(_interceptXHRJS);
                print('eval result: $result');
              },
              onProgress: (progress) {
                setState(() {
                  _progress = progress / 100.0;
                  // Get.to(const MyApp());
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.import_export, size: 32),
        onPressed: () async {
          webViewController.loadUrl('https://youtube.com');
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.import_export, size: 32),
      //   onPressed: () async {
      //     webViewController.evaluateJavascript(
      //         "document.getElementByTagName('header')[0].style.display='none'");
      //     webViewController.evaluateJavascript(
      //         "document.getElementByTagName('footer')[0].style.display='none'");
      //   },
      // ),
    );
  }
}
