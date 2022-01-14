// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

// class FileDownloader extends StatefulWidget {
//   const FileDownloader({Key? key}) : super(key: key);

//   @override
//   _FileDownloaderState createState() => _FileDownloaderState();
// }

// class _FileDownloaderState extends State<FileDownloader> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             openfile(
//                 "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//                 "qwe.mp4");
//           },
//           child: Text("Download"),
//         ),
//       ),
//     );
//   }

//   //////////////////////////////
//   ///
//   ///
//   void openfile(String url, String filename) async {
//     final file = await downloadfile(url, filename);
//     if (file == null) return;
//     OpenFile.open(file.path);
//   }

//   Future<File?> downloadfile(String url, String name) async {
//     try {
//       final appstorage = await getApplicationDocumentsDirectory();
//       var file = File("${appstorage.path}/$name");
//       final response = await Dio().get(url,
//           options: Options(
//               responseType: ResponseType.bytes,
//               followRedirects: false,
//               receiveTimeout: 0));
//       final raf = file.openSync(mode: FileMode.write);
//       raf.writeFromSync(response.data);
//       await raf.close();
//       return file;
//     } catch (e) {
//       print("Error");
//       return null;
//     }
//   }
// }
