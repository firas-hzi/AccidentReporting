import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:printing/printing.dart';
import 'dart:io';


class PdfViewer extends StatelessWidget {
  final File file;
  const PdfViewer({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              label: Text(''),
              onPressed: () async {
          await Printing.sharePdf(bytes: file.readAsBytesSync(), filename: 'my-document.pdf');
             
              }),
        ],
      ),
      path: file.path,
    );
  }
}
