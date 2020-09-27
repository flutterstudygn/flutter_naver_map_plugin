import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map_plugin/flutter_naver_map_plugin.dart';

import '../routes/example_route.dart';

class Controller extends StatefulWidget {
  final ExampleRouteState exampleState;
  final GlobalKey<NMapState> mapKey;

  const Controller(this.exampleState, this.mapKey, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  NaverMapController controller;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ContentBorderSwitch(),
      _ContentSize(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: Platform.isIOS,
        title: Text('Map Controller'),
      ),
      body: FutureBuilder<NaverMapController>(
        future: widget.mapKey.currentState.controller.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            controller = snapshot.data;

            return ListView.separated(
              itemCount: items.length,
              itemBuilder: (_, index) => items[index],
              separatorBuilder: (_, __) => Divider(),
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _ContentBorderSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentBorderSwitchState();
}

class _ContentBorderSwitchState extends State<_ContentBorderSwitch> {
  @override
  Widget build(BuildContext context) {
    final ctrlState = context.findAncestorStateOfType<_ControllerState>();

    return ListTile(
      title: Text('Show layout border'),
      subtitle: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text('map'),
          SizedBox(width: 8),
          Container(
            width: 16,
            height: 16,
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text('content'),
          SizedBox(width: 8),
          Container(
            width: 16,
            height: 16,
            decoration:
                BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text('padding'),
        ],
      ),
      trailing: Switch(
        value: ctrlState.widget.exampleState.showLayoutBorder,
        onChanged: (isOn) => setState(
            () => ctrlState.widget.exampleState.showLayoutBorder = isOn),
      ),
    );
  }
}

class _ContentSize extends StatelessWidget {
  final left = TextEditingController();
  final top = TextEditingController();
  final right = TextEditingController();
  final bottom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrlState = context.findAncestorStateOfType<_ControllerState>();
    final controller = ctrlState.controller;
    left.text = controller.contentPadding.left.round().toString();
    top.text = controller.contentPadding.top.round().toString();
    right.text = controller.contentPadding.right.round().toString();
    bottom.text = controller.contentPadding.bottom.round().toString();

    return WillPopScope(
      onWillPop: () async {
        controller.contentPadding = EdgeInsets.fromLTRB(
          double.parse(left.text),
          double.parse(top.text),
          double.parse(right.text),
          double.parse(bottom.text),
        );
        return true;
      },
      child: ListTile(
        title: Text('Content size'),
        subtitle: Column(children: [
          Table(children: [
            TableRow(children: [
              Text('Map size'),
              Text('width: ${controller.width.round()}'),
              Text('height: ${controller.height.round()}'),
            ]),
            TableRow(children: [
              Text('Content size'),
              Text('width: ${controller.contentWidth.round()}'),
              Text('height: ${controller.contentHeight.round()}'),
            ]),
          ]),
          Row(children: [
            Text('Content padding'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Text('left:', textAlign: TextAlign.end),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(controller: left),
                        ),
                        Text('right:', textAlign: TextAlign.end),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(controller: right),
                        ),
                      ]),
                      TableRow(children: [
                        Text('top:', textAlign: TextAlign.end),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(controller: top),
                        ),
                        Text('bottom:', textAlign: TextAlign.end),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(controller: bottom),
                        ),
                      ])
                    ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
