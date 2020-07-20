part of flutter_naver_map_plugin;

class NaverMap extends StatefulWidget {
  /// 지도에서 표현할 수 있는 최소 줌 레벨.
  static const double minimumZoom = 0;

  /// 지도에서 표현할 수 있는 최대 줌 레벨.
  static const double maximumZoom = 21;

  /// 지도에서 표현할 수 있는 최소 기울기 각도.
  static const double minimumTilt = 0;

  /// 지도에서 표현할 수 있는 최대 기울기 각도.
  static const double maximumTilt = 60;

  /// 지도에서 표현할 수 있는 최소 베어링 각도.
  static const double minimumBearing = 0;

  /// 지도에서 표현할 수 있는 최대 베어링 각도.
  static const double maximumBearing = 0;

  /// 카메라 애니메이션의 기본 지속 시간.
  ///
  /// 밀리초 단위.
  static const int defaultCameraAnimationDuration = 200;

  /// 기본 실내지도 영역 포커스 반경.
  ///
  /// DP 단위.
  static const int defaultIndoorFocusRadiusDP = 55;

  /// 기본 밝은 배경색.
  static const Color defaultBackgroundColorLight =
      Color.fromARGB(0xff, 0xf3, 0xf2, 0xf1);

  /// 기본 어두운 배경색.
  static const Color defaultBackgroundColorDark =
      Color.fromARGB(0xff, 0x26, 0x2a, 0x2f);

  /// 지도 클릭 시 피킹되는 [Pickable]의 기본 클릭 허용 반경.
  ///
  /// DP 단위.
  static const int defaultPickToleranceDP = 2;

  /// 기본 스크롤 제스처 마찰 계수.
  static const double defaultScrollGesturesFriction = 0.88;

  /// 기본 줌 제스처 마찰 계수.
  static const double defaultZoomGesturesFriction = 0.12375;

  /// 기본 회전 제스처 마찰 계수.
  static const double defaultRotateGesturesFriction = 0.19333;

  /// Naver Cloud Platform에서 발급되는 client ID.
  final String clientId;

  final NaverMapOptions _naverMapOptions;

  NaverMap(
    this.clientId, {
    this.gestureRecognizers,
    NaverMapOptions naverMapOptions,
    Key key,
    double minZoom = NaverMap.minimumZoom,
    double maxZoom = NaverMap.maximumZoom,
    EdgeInsets contentPadding = EdgeInsets.zero,
    int defaultCameraAnimationDuration =
        NaverMap.defaultCameraAnimationDuration,
    MapType mapType = MapType.basic,
    List<String> enabledLayerGroups = const [],
    List<String> disabledLayerGroups = const [],
    bool liteModeEnabled = false,
    bool nightModeEnabled = false,
    bool indoorEnabled = false,
    int indoorFocusRadius = -1,
    backgroundColor = NaverMap.defaultBackgroundColorLight,
    // int backgroundResource = 0, TODO
    int pickTolerance = NaverMap.defaultPickToleranceDP,
    bool scrollGesturesEnabled = true,
    bool zoomGesturesEnabled = true,
    bool tiltGesturesEnabled = true,
    bool rotateGesturesEnabled = true,
    bool stopGesturesEnabled = true,
    bool compassEnabled = true,
    bool scaleBarEnabled = true,
    bool zoomControlEnabled = true,
    bool indoorLevelPickerEnabled = true,
    bool locationButtonEnabled = false,
    bool logoClickEnabled = true,
    int logoGravity = AndroidPlatformConstants.noGravity,
    EdgeInsets logoMargin = EdgeInsets.zero,
    int fpsLimit = 0,
    bool useTextureView = kDebugMode,
    bool translucentTextureSurface = false,
    bool zOrderMediaOverlay = false,
    bool preserveEGLContextOnPause = true,
    LatLngBounds extent,
    double buildingHeight = 1,
    double lightness = 0,
    double symbolScale = 1,
    double symbolPerspectiveRatio = 1,
    double scrollGesturesFriction = NaverMap.defaultScrollGesturesFriction,
    double zoomGesturesFriction = NaverMap.defaultZoomGesturesFriction,
    double rotateGesturesFriction = NaverMap.defaultRotateGesturesFriction,
    Locale locale,
    CameraPosition camera,
  })  : _naverMapOptions = _NaverMapOptions._(
          locale: locale ?? ui.window.locale,
          minZoom: minZoom,
          maxZoom: maxZoom,
          contentPadding: contentPadding,
          defaultCameraAnimationDuration: defaultCameraAnimationDuration,
          mapType: mapType,
          enabledLayerGroups: enabledLayerGroups,
          disabledLayerGroups: disabledLayerGroups,
          liteModeEnabled: liteModeEnabled,
          nightModeEnabled: nightModeEnabled,
          indoorEnabled: indoorEnabled,
          indoorFocusRadius: indoorFocusRadius,
          backgroundColor: backgroundColor,
          // backgroundResource: backgroundResource, todo
          pickTolerance: pickTolerance,
          scrollGesturesEnabled: scrollGesturesEnabled,
          zoomGesturesEnabled: zoomGesturesEnabled,
          tiltGesturesEnabled: tiltGesturesEnabled,
          rotateGesturesEnabled: rotateGesturesEnabled,
          stopGesturesEnabled: stopGesturesEnabled,
          compassEnabled: compassEnabled,
          scaleBarEnabled: scaleBarEnabled,
          zoomControlEnabled: zoomControlEnabled,
          indoorLevelPickerEnabled: indoorLevelPickerEnabled,
          locationButtonEnabled: locationButtonEnabled,
          logoClickEnabled: logoClickEnabled,
          logoGravity: logoGravity,
          logoMargin: logoMargin,
          fpsLimit: fpsLimit,
          useTextureView: useTextureView,
          translucentTextureSurface: translucentTextureSurface,
          zOrderMediaOverlay: zOrderMediaOverlay,
          preserveEGLContextOnPause: preserveEGLContextOnPause,
          extent: extent,
          buildingHeight: buildingHeight,
          lightness: lightness,
          symbolScale: symbolScale,
          symbolPerspectiveRatio: symbolPerspectiveRatio,
          scrollGesturesFriction: scrollGesturesFriction,
          zoomGesturesFriction: zoomGesturesFriction,
          rotateGesturesFriction: rotateGesturesFriction,
          camera: camera ??
              CameraPosition(
                LatLng(37.5666102, 126.9783881),
                zoom: 14,
                tilt: 0.0,
                bearing: 0.0,
              ),
        ),
        super(key: key);

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
      'options': widget._naverMapOptions._map,
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'rooftop/flutter_naver_map_plugin',
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        onPlatformViewCreated: onCreateMap,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'rooftop/flutter_naver_map_plugin',
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: creationParams,
        onPlatformViewCreated: onCreateMap,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  void onCreateMap(int id) {
    NaverMapController.init(id, widget._naverMapOptions);
  }
}
