import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class YDownloader extends StatefulWidget {
  const YDownloader({Key? key}) : super(key: key);

  @override
  _YDownloaderState createState() => _YDownloaderState();
}

class _YDownloaderState extends State<YDownloader> {
  YoutubeExplode yt = YoutubeExplode();
  final controller = TextEditingController();
  String quality = "";
  int choice = -1;
  late StreamInfo streamInfo_main;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YDownloader")),
      body: Column(
        children: [
          TextField(
            controller: controller,
          ),
          ListTile(
            title: quality == "" ? Text("Choose quality") : Text(quality),
            onTap: () {
              getVideoType();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadvideo();
        },
      ),
    );
  }

  void getMetadata() async {
    // You can provide either a video ID or URL as String or an instance of `VideoId`.
    Video video = await yt.videos.get(
        'https://www.youtube.com/watch?v=6tfBflFUO7s'); // Returns a Video instance.

    var title = video.title; // "Scamazon Prime"
    var author = video.author; // "Jim Browning"
    var duration = video.duration; // Instance of Duration - 0:19:48.00000
    print(title);
  }

  void downloadvideo() async {
    try {
      final appstorage = await getApplicationDocumentsDirectory();

      if (streamInfo_main != null) {
        // Get the actual stream
        var stream = yt.videos.streamsClient.get(
          streamInfo_main,
        );

        // Open a file for writing.
        var file = File("D://movies//video4.mp4");
        var fileStream = file.openWrite();

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
      }
    } catch (e) {
      print(e);
    }
  }

  //////////////
  ///
  void getVideoType() async {
    var manifest = await yt.videos.streamsClient.getManifest('6tfBflFUO7s');
    var listofstream = manifest.video;
    showBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 500,
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(listofstream.elementAt(index).toString()),
                  onTap: () {
                    setState(() {
                      choice = index;
                      streamInfo_main = listofstream.elementAt(choice);
                      quality = listofstream.elementAt(choice).toString();
                    });
                    Navigator.of(context).pop();
                  },
                );
              }),
              itemCount: listofstream.length,
            ),
          );
        });
  }
}
