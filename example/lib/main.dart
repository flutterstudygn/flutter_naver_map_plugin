import 'package:flutter/material.dart';
import 'package:flutter_naver_map_plugin/flutter_naver_map_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Naver map example'),
        ),
        body: NaverMap(
          'Your NCP Client ID',
          naverMapOptions: NaverMapOptions(
            camera: CameraPosition(
              LatLng(37.566677, 126.978408),
            ),
          ),
        ),
      ),
    );
  }
}
