import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:accident_archive/External/Storage/StorageFactory.dart';
import 'package:accident_archive/External/Storage/StorageInterface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'display.dart';

class SelectMultiImages extends StatefulWidget {
  final String accidentId;

  SelectMultiImages({this.accidentId});
  @override
  _SelectMultiImagesState createState() => new _SelectMultiImagesState();
}

class _SelectMultiImagesState extends State<SelectMultiImages> {
  List<Asset> images = List<Asset>();
  StorageInterface storageInterface = StorageFactory.getStorageImplementation();

  @override
  void initState() {
    super.initState();
  }

  Widget buildGalleryGridView() {
    if (images?.isNotEmpty ?? false) {
      return GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];

            return AssetThumb(
              asset: asset,
              width: 200,
              height: 200,
            );
          }));
    }
    return Text('No images selected');
  }

  Widget buildFirestoreGridView() {
    return FutureBuilder<List<DocumentSnapshot>>(
        future: storageInterface.getImages(widget.accidentId),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> urls) {
          if (urls.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Loading..."),
                  SizedBox(
                    height: 50.0,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          } else {
            if (urls.hasData) {
              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(urls.data.length, (index) {
                  // log(snapshot.data.documents[index].data["url"]);

                  return InkWell(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayPicture(
                                    url: urls.data[index].data['url'],
                                  ),
                                ))
                          },
                      onLongPress: () => {
                            _deleteDialog(
                              urls.data[index],
                            )
                          },
                      child: Image.file(
                        new File(urls.data[index].data['url']),
                        scale: 0.5,
                        width: 200,
                        height: 200,
                        filterQuality: FilterQuality.low,
                      ));
                }),
              );
            }
            return Text('No images found');
          }
        });
  }

  Future<void> _deleteDialog(DocumentSnapshot url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Löschen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Möchten Sie diesen Datensatz wirklich löschen?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Löschen'),
              onPressed: () {
                setState(() {
                  storageInterface
                      .deleteImage(url, widget.accidentId)
                      .then((onValue) {
                    File(url.data['url']).delete();
                    Navigator.of(context).pop();
                  });
                });
              },
            ),
            FlatButton(
              child: Text('Stornieren'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        materialOptions: MaterialOptions(
          selectionLimitReachedText: "You can't select any more.",
         // startInAllView: true,
        ),
      );
    } on NoImagesSelectedException catch (e) {
      log(e.toString());
      // User pressed cancel, update ui or show alert
    } on Exception catch (e) {
      log(e.toString());
    }

    for (var imageFile in resultList) {
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/' + imageFile.name;
      final File file = new File(path);
      ByteData byteData = await imageFile.getByteData(quality: 40);
      List<int> imageData = byteData.buffer.asUint8List();
      await file.writeAsBytes(imageData);
      storageInterface.addImages(path, widget.accidentId).then((document) {
        saveImage(imageData,imageFile.name);
        log("successfulle added images");
      }).catchError((onError) {
        log(onError.toString());
      });
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future saveImage(List<int> bytes, String name) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    FirebaseStorage.instance
        .ref()
        .child(user.uid + "/" + widget.accidentId + "/" + name)
        .putData(bytes);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(''),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: loadAssets,
              icon: Icon(Icons.image, color: Colors.white),
              label: Text(''))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildGalleryGridView(),
          ),
          Expanded(
            child: buildFirestoreGridView(),
          )
        ],
      ),
    );
  }
}
