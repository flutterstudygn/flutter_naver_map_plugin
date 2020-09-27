import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map_plugin/flutter_naver_map_plugin.dart';

import '../routes/controller_route.dart';
import '../widgets/layout_border_layer.dart';

class ExampleRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExampleRouteState();
}

class ExampleRouteState extends State<ExampleRoute> {
  final _mapKey = GlobalKey<NMapState>();

  bool _showLayoutBorder = false;

  NMap _map;

  set showLayoutBorder(bool show) => setState(() => _showLayoutBorder = show);

  bool get showLayoutBorder => _showLayoutBorder;

  @override
  void initState() {
    super.initState();
    _map = NMap(key: _mapKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Naver map example'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => Controller(this, _mapKey),
            )),
          )
        ],
      ),
      body: _showLayoutBorder ? LayoutBorderLayer(_map, _mapKey) : _map,
    );
  }
}

class NMap extends StatefulWidget {
  NMap({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NMapState();
}

class NMapState extends State<NMap> {
  final controller = Completer<NaverMapController>();

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      'Your NCP Client ID',
      camera: CameraPosition(
        LatLng(37.566677, 126.978408),
      ),
      zoomControlEnabled: true,
      locationButtonEnabled: true,
      contentPadding: EdgeInsets.all(16),
      onMapCreated: (controller) => this.controller.complete(controller),
    );
  }
}
