part of flutter_naver_map_plugin;

class NaverMap extends StatefulWidget {
  /// 지도에서 표현할 수 있는 최소 줌 레벨.
  static const int minimumZoom = 0;

  /// 지도에서 표현할 수 있는 최대 줌 레벨.
  static const int maximumZoom = 21;

  /// 지도에서 표현할 수 있는 최소 기울기 각도.
  static const double minimumTilt = 0;

  /// 지도에서 표현할 수 있는 최대 기울기 각도.
  static const double maximumTilt = 60;

  /// 지도에서 표현할 수 있는 최소 베어링 각도.
  static const double minimumBearing = 0;

  /// 지도에서 표현할 수 있는 최대 베어링 각도.
  static const double maximumBearing = 0;

  const NaverMap(
    this.clientId, {
    this.gestureRecognizers,
    Key key,
  }) : super(key: key);

  /// Naver Cloud Platform에서 발급되는 client ID.
  final String clientId;

  /// 어떤 제스쳐가 지도에 적용될지를 지정합니다.
  ///
  /// 지도상의 [PointerEvent]들에 대해 다른 [GestureRecognizer]와 경쟁할 수 있습니다.
  /// 예를 들면 지도가 [ListView]안에 있다면 [ListView]는 수직 쓸기 제스쳐를
  /// 처리할 것입니다. 하지만 이 [Set]에 지정된 제스쳐에 한에선 지도가 처리권을
  /// 갖게 됩니다.
  ///
  /// 이 [Set]이 비거나 null이라면 지도는 다른 [GestureRecognizer]가 권한을 가지지
  /// 않은 제스쳐에 대해서만 처리하게 됩니다.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State createState() => _NaverMapState();
}

class _NaverMapState extends State<NaverMap> {
  @override
  Widget build(BuildContext context) {
    final creationParams = <String, dynamic>{
      'clientId': widget.clientId,
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'rooftop/flutter_naver_map_plugin',
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'rooftop/flutter_naver_map_plugin',
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }
}
