
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DisplayPicture extends StatelessWidget {
  final String url;

  const DisplayPicture({Key key, this.url}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     return Container(
    child: PhotoView(
    
      imageProvider: FileImage(new File(url), scale: 0.5
      
      ),
    )
  );
}
  
}

