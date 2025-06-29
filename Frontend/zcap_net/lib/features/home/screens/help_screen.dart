import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _markdownContent = '';
   bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _loadMarkdown();
      _isLoaded = true;
    }
  }

    Future<void> _loadMarkdown() async {
    final langCode = context.locale.languageCode;
    final path = 'assets/help/help.$langCode.md';

    try {
      final content = await rootBundle.loadString(path);
      setState(() => _markdownContent = content);
    } catch (e) {
      setState(() => _markdownContent = 'Error loading help file.');
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('help'.tr())),
      body: _markdownContent.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _markdownContent,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            ),
    );
  }
}