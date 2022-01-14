import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final controller = TextEditingController();
  final namecontroller = TextEditingController();

  YoutubeExplode yt = YoutubeExplode();
  bool urlchecqued = false;
  List<String> urldata = ["", "", ""];
  int choice = -1;
  int i = 0;
  double completed = 0;
  late StreamInfo streamInfo_main;
  String quality = "";
  bool _checkingurl = false;
  bool downloading = false;
  bool audioonly = false;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    namecontroller.dispose();
  }

  List<String> strvalues = [
    "Checquing validity of URL",
    "Getting possible video formats"
  ];
  @override
  Widget build(BuildContext context) {
    return _checkingurl
        ? showCircularIndicator(strvalues[i])
        : SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _textField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: checkurl,
                    child: const Text("ChecqueUrl"),
                  ),
                ),
                urlchecqued
                    ? Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Title"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(urldata[0]),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Author"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(urldata[1]),
                                ),
                              ],
                            ),
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Duration"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(urldata[2]),
                              ),
                            ]),
                          ],
                        ),
                      )
                    : const SizedBox(),
                urlchecqued
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Download Audio only"),
                              Checkbox(
                                  value: audioonly,
                                  onChanged: (val) {
                                    setState(() {
                                      audioonly = val!;
                                    });
                                  }),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(30.0),
                            child: TextButton.icon(
                                onPressed: () {
                                  choosequality(context);
                                },
                                icon: const Icon(Icons.save),
                                label: quality == ""
                                    ? Text(audioonly
                                        ? "Choose Audio Quality"
                                        : "Choose video quality")
                                    : Text(quality)),
                          ),
                        ],
                      )
                    : const SizedBox(),
                if (urlchecqued)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25),
                    child: TextField(
                      controller: namecontroller,
                      decoration: const InputDecoration(
                          labelText: "Enter the name for file"),
                    ),
                  ),
                urlchecqued && choice >= 0
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (downloading) {
                              showAlert("Video is already downloading");
                            } else {
                              if (namecontroller.text.isNotEmpty) {
                                downloadvideo();
                              } else {
                                showAlert("Please give a valid name for file");
                              }
                            }
                          },
                          label: const Text("Download"),
                          icon: const Icon(Icons.save_alt_rounded),
                        ),
                      )
                    : const SizedBox(),
                downloading
                    ? showCircularIndicator(
                        "video is started downloading in backgroung")
                    : const Center(),
              ],
            ),
          );
  }

  ///////////
  ///
  TextField _textField() {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Enter video url here",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gapPadding: 30,
        ),
      ),
    );
  }

  void checkurl() async {
    try {
      setState(() {
        _checkingurl = !_checkingurl;
        i = 0;
      });
      Video video = await yt.videos
          .get(controller.text.trim()); // Returns a Video instance.

      urldata[0] = video.title;
      urldata[1] = (video.author);
      urldata[2] = (video.duration.toString());

      setState(() {
        urlchecqued = true;
        _checkingurl = !_checkingurl;
      });
    } catch (e) {
      setState(() {
        urlchecqued = false;
        _checkingurl = !_checkingurl;
        i = 0;
      });
      showAlert("Invalid url");
    }
  }

  void choosequality(BuildContext context) async {
    try {
      if (urlchecqued) {
        setState(() {
          _checkingurl = true;
          i = 1;
        });
        var manifest = await yt.videos.streamsClient
            .getManifest(controller.text.trim())
            .timeout(const Duration(seconds: 5));
        var listofstream = audioonly ? manifest.audioOnly : manifest.video;
        showDialog(
            context: context,
            builder: (ctx) {
              return Dialog(
                elevation: 30,
                insetAnimationCurve: Curves.bounceIn,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  height: 200,
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
                ),
              );
            });
        setState(() {
          _checkingurl = false;
          i = 1;
        });
      }
    } catch (e) {
      showAlert("Unable to process request");
      setState(() {
        _checkingurl = false;
        i = 1;
      });
    }
  }

  void downloadvideo() async {
    setState(() {
      downloading = !downloading;
    });
    try {
      final appstorage = await getApplicationDocumentsDirectory();
      // final appstorage = await DownloadsPathProvider.downloadsDirectory;
      // print(appstorage!.path);
      // Get the actual stream
      var stream = yt.videos.streamsClient.get(
        streamInfo_main,
      );
      // print(streamInfo_main.codec.type);
      // print(streamInfo_main.codec.mimeType);
      // print(streamInfo_main.codec.subtype);
      // Open a file for writing.
      var file = File("${appstorage.path}/${namecontroller.text}." +
          (audioonly ? "mp3" : "mp4"));

      var fileStream = file.openWrite();
      // double downloaded = 0;
      // Pipe all the content of the stream into the file.

      await stream.pipe(
        fileStream,
      );

      // file.open();
      // print(file.path);

      // Close the file.

      await fileStream.flush();
      await fileStream.close();
      OpenFile.open(file.path);
      if (!audioonly) GallerySaver.saveVideo(file.path);

      showAlert("Download Complete");
      // print("done");
    } catch (e) {
      showAlert("unable to download");
    }

    setState(() {
      downloading = !downloading;
      urlchecqued = false;
      controller.clear();
      namecontroller.clear();
      choice = -1;
      quality = "";
    });
  }

  void setdownloadmeasure(double downloaded, String totalsize) {
    setState(() {
      completed = (downloaded / double.parse(totalsize)) * 10000;
    });
  }

  void showAlert(String content) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            elevation: 30,
            insetAnimationCurve: Curves.bounceIn,
            alignment: Alignment.center,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Center(child: Text(content)),
            ),
          );
        });
    // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    //   content: Text(content),
    //   actions: [
    //     ElevatedButton(
    //       onPressed: () {
    //         ScaffoldMessenger.of(context).clearMaterialBanners();
    //       },
    //       child: const Text("Close"),
    //     )
    //   ],
    // ));
  }

  Widget showCircularIndicator(String value) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(value),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              strokeWidth: 4,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
