import 'package:flutter/material.dart';
import 'package:internetfiledownloader/downloadedfiles.dart';
import 'package:internetfiledownloader/downloadpage.dart';
import 'package:internetfiledownloader/filedownloader.dart';
import 'package:internetfiledownloader/youtube_downloader.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////

class _HomeState extends State<Home> {
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
  int _index = 0;
  PageController controller = PageController(
    viewportFraction: 1,
    keepPage: true,
  );
  List _widgets = [DownloadPage(), Downloadedfiles()];
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("AppBar"),
      // ),
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
      body: PageView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        onPageChanged: (int i) {
          setState(() {
            _index = i;
          });
        },
        itemBuilder: ((context, index) {
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
          return Transform.scale(
            scale: index == _index ? 1 : 0.9,
            child: Card(
              elevation: 0,
              // color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: _widgets[index],
            ),
          );
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
        }),
        itemCount: _widgets.length,
      ),
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedIconTheme: const IconThemeData(
          color: Colors.redAccent,
        ),
        elevation: 20,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            // controller.jumpToPage(i);Cur
            controller.animateToPage(i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined),
              label: "Download Video"),
          BottomNavigationBarItem(
              icon: Icon(Icons.download_done_sharp),
              label: "Downloaded videos"),
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home3"),
          // BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home4"),
        ],
      ),
// /////////////////////////////////////////////////////////
//
// /////////////////////////////////////////////////////////
    );
  }
}
