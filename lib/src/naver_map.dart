part of flutter_naver_map_plugin;

/// 네이버 지도가 사용 준비됨을 알리는 콜백 함수
///
/// 지도가 생성됐을 때 [NaverMap.onMapCreated]를 통해 [NaverMapController]를 얻을 수 있다.
typedef MapCreatedCallback = void Function(NaverMapController controller);

/// 카메라가 움직이면 호출되는 콜백 메서드.
///
/// 해당 시점의 카메라 위치는 콜백 내에서 [NaverMapController.cameraPosition]을 호출해 구할 수 있습니다.
///
/// [reason]은 움직임의 원인이며 [animated]는 애니메이션 효과의 적용 유무, [position]은 카메라의 위치입니다.
typedef OnCameraChange = void Function(int reason, bool animated);

/// 카메라의 움직임이 끝나면 호출되는 콜백 메서드.
///
/// 해당 시점의 카메라 위치는 콜백 내에서 [NaverMapController.cameraPosition]을 호출해 구할 수 있습니다.
///
/// 이 이벤트는 다음과 같은 경우에 발생합니다.
/// - 카메라가 애니메이션 없이 움직일 때. 단, 사용자가 제스처로 지도를 움직이는 경우 제스처가 완전히 끝날 때까지는 연속적인 이동으로 간주되어 이벤트가 발생하지 않습니다.
/// - 카메라 애니메이션이 완료될 때. 단, 카메라 애니메이션이 진행 중일 때 새로운 애니메이션이 발생하거나, 기존 [CameraUpdate]의 [CameraUpdate.finishCallback] 또는 [CameraUpdate.cancelCallback]으로 지정된 콜백 내에서 카메라 이동이 일어날 경우 연속적인 이동으로 간주되어 이벤트가 발생하지 않습니다.
/// - [NaverMapController.cancelTransitions]가 호출되어 카메라 애니메이션이 명시적으로 취소될 때.
typedef OnCameraIdle = void Function();

/// 지도의 옵션이 변경되면 호출되는 콜백 메서드.
///
/// 지도의 최소/최대 줌, 레이어 활성화/비활성화 상태 등이 변경되면 이벤트가 발생합니다.
typedef OnOptionChange = void Function();

/// 지도가 클릭되면 호출되는 콜백 메서드.
///
/// [point]과 [coord]는 각각 클릭된 지점의 화면 좌표와 지도 좌표입니다.
typedef OnMapClick = void Function(Offset point, LatLng coord);

/// 지도가 롱 클릭되면 호출되는 콜백 메서드.
///
/// [point]과 [coord]는 각각 클릭된 지점의 화면 좌표와 지도 좌표입니다.
typedef OnMapLongClick = void Function(Offset point, LatLng coord);

/// 지도가 더블 탭되면 호출되는 콜백 메서드.
///
/// [point]과 [coord]는 각각 클릭된 지점의 화면 좌표와 지도 좌표입니다.
///
/// 기존 NaverMap SDK에서는 반환값에 따라 이벤트가 소비되지만 현재로선 네이티브 코드에서 플러터 함수 반환값에 대한 비동가 작업이 어려워 이벤트를 소비하지 않도록 합니다.
typedef OnMapDoubleTap = void Function(Offset point, LatLng coord);

/// 지도가 두 손가락 탭되면 호출되는 콜백 메서드.
///
/// [point]과 [coord]는 각각 두 손가락 탭된 중심 지점의 화면 좌표와 지도 좌표입니다.
///
/// 기존 NaverMap SDK에서는 반환값에 따라 이벤트가 소비되지만 현재로선 네이티브 코드에서 플러터 함수 반환값에 대한 비동가 작업이 어려워 이벤트를 소비하지 않도록 합니다.
typedef OnMapTwoFingerTap = void Function(Offset point, LatLng coord);

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

  /// 네이버 지도가 사용 준비됨을 알리는 콜백 함수
  ///
  /// 이 [NaverMap]을 위한 [NaverMapController]를 얻는 용도로 사용한다.
  final MapCreatedCallback onMapCreated;

  /// 지도의 초기 옵션.
  final _NaverMapOptions _naverMapOptions;

  /// 네이버 지도 객체를 생성합니다.
  ///
  /// [clientId], [gestureRecognizers],[onMapCreated],[key]를 제외한 매개변수들은 [_NaverMapOptions]를 참고하기바랍니다.
  NaverMap(
    this.clientId, {
    this.gestureRecognizers = const {},
    this.onMapCreated,
    Key key,
    double minZoom = NaverMap.minimumZoom,
    double maxZoom = NaverMap.maximumZoom,
    EdgeInsets contentPadding = EdgeInsets.zero,
    int defaultCameraAnimationDuration =
        NaverMap.defaultCameraAnimationDuration,
    MapType mapType = MapType.basic,
    Set<LayerGroup> enabledLayerGroups = const {},
    Set<LayerGroup> disabledLayerGroups = const {},
    bool liteModeEnabled = false,
    bool nightModeEnabled = false,
    bool indoorEnabled = false,
    int indoorFocusRadius = -1,
    backgroundColor = NaverMap.defaultBackgroundColorLight,
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
          cameraPosition: camera ??
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

    throw Exception(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  void onCreateMap(int id) {
    widget.onMapCreated?.call(NaverMapController._(this, id));
  }
}
