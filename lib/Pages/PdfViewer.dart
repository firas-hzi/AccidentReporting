
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:simple_share/simple_share.dart';

class PdfViewer extends StatelessWidget {
  final String path;
  const PdfViewer({Key key, this.path}) : super(key: key);

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
                final uri = Uri.file(path);
                print(uri.toString());
                await SimpleShare.share(
                  uri: uri.toString(),
                );
              }),
        ],
      ),
      path: path,
    );
  }
}
