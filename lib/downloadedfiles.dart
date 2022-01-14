import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Downloadedfiles extends StatefulWidget {
  const Downloadedfiles({Key? key}) : super(key: key);

  @override
  _DownloadedfilesState createState() => _DownloadedfilesState();
}

class _DownloadedfilesState extends State<Downloadedfiles> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      builder: (ctx, AsyncSnapshot<Directory> snap) {
        if (snap.connectionState != ConnectionState.done) {
          return showCircularIndicator("Fetching downloaded files");
        } else if (snap.hasData) {
          var dir = snap.data!;
          List<FileSystemEntity> files = Directory(dir.path).listSync();
          List<String> vfiles = [];

          for (var element in files) {
            if (element.path.split(".").last == "mp4" ||
                element.path.split(".").last == "mp3") {
              vfiles.add(element.path);
            }
          }

          return ListView.builder(
            controller: ScrollController(keepScrollOffset: true),
            itemBuilder: (ctx, index) {
              return InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: width * 0.1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.1,
                        child: const Icon(Icons.video_file_outlined),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: width * 0.1),
                        width: width * 0.7,
                        child: Text(
                            vfiles
                                .elementAt(index)
                                .split("\\")
                                .last
                                .split("/")
                                .last,
                            overflow: TextOverflow.visible),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  OpenFile.open(vfiles[index]);
                },
              );
            },
            itemCount: vfiles.length,
          );
        } else {
          return const Center(
            child: Text("Unable to fetch the documents"),
          );
        }
      },
      future: getApplicationDocumentsDirectory(),
    );
  }

  ////////////////////////
  ///
  ///
  ///
  Widget showCircularIndicator(String value) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(value),
          ),
          const CircularProgressIndicator(
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  //////////////////////////
  ///
  ///
  ///
  void showAlert(String content) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearMaterialBanners();
          },
          child: const Text("Close"),
        )
      ],
    ));
  }
}
