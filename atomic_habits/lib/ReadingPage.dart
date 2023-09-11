import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  const PDFViewerPage({
    required this.file,
    super.key,
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController? controller;
  int pages = 0;
  int indexPage = 0;

  Future<void> _saveLastReadPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadPage', page);
  }

  Future<void> _loadLastReadPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastReadPage = prefs.getInt('lastReadPage') ?? 0;
    setState(() {
      indexPage = lastReadPage;
    });
  }

  void initState() {
    super.initState();
    _loadLastReadPage();
  }

  @override
  Widget build(BuildContext context) {
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text("Atomic Habits"),
        actions: pages >= 2
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Center(child: Text(text)),
                ),
              ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) => {
          setState(() => this.indexPage = indexPage!),
          _saveLastReadPage(indexPage!)
        },
      ),
    );
  }
}
