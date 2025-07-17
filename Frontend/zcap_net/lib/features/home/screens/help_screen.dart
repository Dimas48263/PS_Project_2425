import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:webview_windows/webview_windows.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final WebviewController _controller = WebviewController();
  bool _isWebViewReady = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    try {
      await _controller.initialize();

      final langCode = Localizations.localeOf(context).languageCode;
      final htmlContent = await rootBundle.loadString('assets/help/help.$langCode.html');

      await _controller.loadStringContent(htmlContent);

      setState(() {
        _isWebViewReady = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar a ajuda: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('help'.tr())),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('help'.tr())),
      body: _isWebViewReady
          ? Webview(_controller)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}