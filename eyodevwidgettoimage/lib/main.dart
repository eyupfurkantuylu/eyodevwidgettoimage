import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hello Eyo.Dev',
              ),
              Text(
                'Widget to Image',
                style: Theme.of(context).textTheme.headline4,
              ),
              buildImage(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    final image = await controller
                        .captureFromWidget(buildImage());

                    if (image == null) return;
                    await saveImage(image);
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: new BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "DOWNLOAD",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack buildImage() {
    return Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://i.pinimg.com/474x/c9/d1/17/c9d11769e2b4d92426cd326b75c8d72c.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Container(
                      child: Text(
                        "Eyo Dev'e hoş geldin!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                )


              ],
            );
  }

  Future<String> saveImage(Uint8List image) async {
    // izin yoksa izin talep eder
    await [Permission.storage].request();

    // resmin kaydedileceği andaki zamanı alır, stringe çevirir nokta ve iki noktaları tireye çevirir
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');

    // resim adını benzersiz yapabilmek için screenshot_ keywordünün sonuna yukarıda hazırladığımız time nesnesini verdik
    final name = 'screenshot_$time';

    // görseli galeriye kaydeder
    final result = await ImageGallerySaver.saveImage(image, name: name);
    return result['filePath'];
  }


}
