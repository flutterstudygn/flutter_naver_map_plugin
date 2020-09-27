part of flutter_naver_map_plugin;

/// 생성된 지도를 조작하는 클래스.
///
/// 지도와 관련된 모든 조작은 이 클래스를 통해 이루어집니다.
/// 이 클래스의 인스턴스는 직접 생성할 수 없고 [NaverMap.onMapCreated]를 통해 얻어야 합니다.
class NaverMapController {
  final MethodChannel _channel;

  final _NaverMapState _mapState;

  /// 카메라의 움직임에 대한 이벤트 리스너.
  OnCameraChange onCameraChange;

  /// 카메라의 움직임이 끝난 경우에 대한 이벤트 리스너.
  OnCameraIdle onCameraIdle;

  /// 지도 옵션 변경에 대한 이벤트 리스너.
  OnOptionChange onOptionChange;

  /// 클릭 이벤트 리스너.
  ///
  /// 단, 오버레이나 심벌이 클릭 이벤트를 소비한 경우 지도까지 이벤트가 전달되지 않습니다.
  OnMapClick onMapClick;

  /// 롱 클릭 이벤트 리스너.
  OnMapLongClick onMapLongClick;

  /// 더블 탭 이벤트 리스너.
  OnMapDoubleTap onMapDoubleTap;

  /// 두 손가락 탭 리스너를 지정합니다.
  OnMapTwoFingerTap onMapTwoFingerTap;

  LocationTrackingMode _locationTrackingMode = LocationTrackingMode.none;

  int _defaultCameraAnimationDuration;

  Locale _locale;

  CameraPosition _cameraPosition;

  LatLngBounds _contentBounds;

  List<int> _coveringIleIds;

  LatLngBounds _extent;

  double _minZoom;

  double _maxZoom;

  MapType _mapType;

  Map<LayerGroup, bool> _layerGroupEnables;

  bool _nightModeEnabled;

  bool _liteModeEnabled;

  double _buildingHeight;

  double _lightness;

  double _symbolScale;

  double _symbolPerspectiveRatio;

  bool _indoorEnabled;

  int _indoorFocusRadius;

  Color _backgroundColor;

  EdgeInsets _contentPadding;

  int _fpsLimit;

  CameraUpdate _lastCameraUpdate;

  double _width;

  double _height;

  NaverMapController._(this._mapState, int id)
      : _channel = MethodChannel('rooftop/flutter_naver_map_plugin#$id') {
    final options = _mapState.widget._naverMapOptions;

    _defaultCameraAnimationDuration = options.defaultCameraAnimationDuration;
    _locale = options.locale;
    _cameraPosition = options.cameraPosition;
    _extent = options.extent;
    _minZoom = options.minZoom;
    _maxZoom = options.maxZoom;
    _mapType = options.mapType;
    _nightModeEnabled = options.nightModeEnabled;
    _liteModeEnabled = options.liteModeEnabled;
    _buildingHeight = options.buildingHeight;
    _lightness = options.lightness;
    _symbolScale = options.symbolScale;
    _symbolPerspectiveRatio = options.symbolPerspectiveRatio;
    _indoorEnabled = options.indoorEnabled;
    _indoorFocusRadius = options.indoorFocusRadius;
    _backgroundColor = options.backgroundColor;
    _contentPadding = options.contentPadding;
    _fpsLimit = options.fpsLimit;

    for (final enabled in options.enabledLayerGroups) {
      _layerGroupEnables[enabled] = true;
    }
    for (final disabled in options.disabledLayerGroups) {
      _layerGroupEnables[disabled] = false;
    }

    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// 지도 뷰의 화면상 너비를 반환합니다.
  double get width => _width;

  /// 지도 뷰의 화면상 높이를 반환합니다.
  double get height => _height;

  /// 패딩을 제외한 지도 뷰의 화면상 너비를 반환합니다.
  double get contentWidth => _width - _contentPadding.horizontal;

  /// 패딩을 제외한 지도 뷰의 높이를 반환합니다.
  double get contentHeight => _height - _contentPadding.vertical;

  /// 패딩을 제외한 지도 뷰의 화면상 영역을 반환합니다.
  Rect get contentRect {
    final position = (_mapState.context.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    final offset = position + _contentPadding.topLeft;

    return Rect.fromLTWH(offset.dx, offset.dy, contentWidth, contentHeight);
  }

  /// 지도의 로캘을 반환합니다.
  ///
  /// 기본값은 시스템 로캘을 의미하는 null입니다.
  Locale get locale => _locale;

  /// 지도의 로캘을 지정합니다.
  ///
  /// null일 경우 시스템 로캘로 지정됩니다.
  set locale(Locale locale) => _channel
          .invokeMethod<String>(
        'map#setLocale',
        locale?.toString() ?? ui.window.locale.toString(),
      )
          .then(
        (value) {
          final localeSegments = value.split('_');
          _locale = Locale(localeSegments.first, localeSegments.last);
        },
      );

  /// 지도의 콘텐츠 영역에 대한 [LatLngBounds]를 반환합니다.
  LatLngBounds get contentBounds => _contentBounds;

  /// 지도의 콘텐츠 영역에 대한 좌표열을 반환합니다.
  ///
  /// 지도의 콘텐츠 영역은 네 개의 좌표로 구성된 사각형으로 표현됩니다.
  /// 단, 반환되는 배열의 크기는 5이며, 첫 번째 원소와 마지막 원소가 동일한 지점을 가리킵니다.
  List<LatLng> get contentRegion => [
        LatLng.clone(_contentBounds.southwest),
        LatLng(
          _contentBounds.northeast.latitude,
          _contentBounds.southwest.longitude,
        ),
        LatLng.clone(_contentBounds.northeast),
        LatLng(
          _contentBounds.southwest.latitude,
          _contentBounds.northeast.longitude,
        ),
        LatLng.clone(_contentBounds.southwest),
      ];

  /// 현재 화면을 커버하는 타일 ID의 목록을 반환합니다.
  List<int> get coveringTileIds => _coveringIleIds;

  /// 지도의 콘텐츠 영역 중심에 대한 카메라 위치를 반환합니다.
  CameraPosition get cameraPosition => _cameraPosition;

  /// 카메라의 위치를 변경합니다.
  ///
  /// 만약 카메라 이동 애니메이션이 진행 중이었다면 취소되고, 진행 중인 [CameraUpdate] 객체의 [CameraUpdate.onCameraUpdateCancel] 및 [onCameraChange]가 호출됩니다.
  set cameraPosition(CameraPosition position) => _channel
      .invokeMapMethod<String, dynamic>('map#setCameraPosition', position._map)
      .then((value) => _cameraPosition = CameraPosition.fromMap(value));

  /// 카메라 이동 애니메이션의 기본 지속 시간을 반환합니다.
  ///
  /// 기본값은 [NaverMap.defaultCameraAnimationDuration]입니다.
  int get defaultCameraAnimationDuration => _defaultCameraAnimationDuration;

  /// 카메라 이동 애니메이션의 기본 지속 시간을 지정합니다.
  set defaultCameraAnimationDuration(int duration) {
    _channel
        .invokeMethod<int>('map#setDefaultCameraAnimationDuration', duration)
        .then((value) => _defaultCameraAnimationDuration = value);
  }

  /// 지도의 제한 영역을 반환합니다.
  ///
  /// 기본값은 제한이 없음을 의미하는 null입니다.
  LatLngBounds get extent => _extent;

  /// 지도의 제한 영역을 지정합니다.
  set extent(LatLngBounds bounds) => _channel
      .invokeMapMethod<String, dynamic>('map#setExtent', bounds._map)
      .then((value) => _extent = LatLngBounds.fromMap(value));

  /// 지도의 최소 줌 레벨을 반환합니다.
  ///
  /// 기본값은 [NaverMap.minimumZoom]입니다.
  double get minZoom => _minZoom;

  /// 지도의 최소 줌 레벨을 지정합니다.
  set minZoom(double zoom) => _channel
      .invokeMethod<double>('map#setMinZoom', zoom)
      .then((value) => _minZoom = value);

  /// 지도의 최대 줌 레벨을 반환합니다.
  ///
  /// 기본값은 [NaverMap.maximumZoom]입니다.
  double get maxZoom => _maxZoom;

  /// 지도의 최대 줌 레벨을 지정합니다.
  set maxZoom(double zoom) => _channel
      .invokeMethod<double>('map#setMaxZoom', zoom)
      .then((value) => _maxZoom = value);

  /// 지도의 유형을 반환합니다.
  ///
  /// 기본값은 [MapType.basic]입니다.
  MapType get mapType => _mapType;

  /// 지도의 유형을 지정합니다.
  set mapType(MapType type) => _channel
      .invokeMethod<int>('map#setMapType', type.index)
      .then((value) => _mapType = MapType.values[value]);

  /// 지도가 어두운지 여부를 반환합니다.
  ///
  /// 야간 모드가 활성화되어 있거나 지도의 유형이 [MapType.satellite] 또는 [MapType.hybrid]일 경우 어두운 것으로 간주됩니다.
  bool get isDark =>
      _mapType == MapType.satellite ||
      _mapType == MapType.hybrid ||
      _nightModeEnabled;

  /// 라이트 모드가 활성화되어 있는지 여부를 반환합니다.
  ///
  /// 라이트 모드가 활성화되면 지도의 로딩이 빨라지고 메모리 소모가 감소합니다.
  /// 그러나 다음과 같은 제약이 생깁니다.
  /// * 지도의 전반적인 화질이 하락합니다.
  /// * 카메라가 회전하거나 기울어지면 지도 심벌도 함께 회전하거나 기울어집니다.
  /// * 줌 레벨이 커지거나 작아지면 지도 심벌도 일정 정도 함께 커지거나 작아집니다.
  /// * [MapType.navi] 지도 유형을 사용할 수 없습니다.
  /// * [setLayerGroupEnabled]와 [indoorEnabled], [nightModeEnabled], [lightness], [buildingHeight], [symbolScale], [symbolPerspectiveRatio]들의 setter가 동작하지 않습니다.
  /// * [NaverMap.onSymbolClick]이 호출되지 않습니다.
  /// * [Marker.hideCollidedSymbols]의 setter가 동작하지 않습니다.
  ///
  /// 기본값은 false입니다.
  bool get liteModeEnabled => _liteModeEnabled;

  /// 라이트 모드를 활성화할지 여부를 지정합니다.
  ///
  /// 라이트 모드가 활성화되면 지도의 로딩이 빨라지고 메모리 소모가 감소합니다.
  /// 그러나 다음과 같은 제약이 생깁니다.
  /// * 지도의 전반적인 화질이 하락합니다.
  /// * 카메라가 회전하거나 기울어지면 지도 심벌도 함께 회전하거나 기울어집니다.
  /// * 줌 레벨이 커지거나 작아지면 지도 심벌도 일정 정도 함께 커지거나 작아집니다.
  /// * [MapType.navi] 지도 유형을 사용할 수 없습니다.
  /// * [setLayerGroupEnabled]와 [indoorEnabled], [nightModeEnabled], [lightness], [buildingHeight], [symbolScale], [symbolPerspectiveRatio]들의 setter가 동작하지 않습니다.
  /// * [NaverMap.onSymbolClick]이 호출되지 않습니다.
  /// * [Marker.hideCollidedSymbols]의 setter가 동작하지 않습니다.
  ///
  /// 기본값은 false입니다.
  set liteModeEnabled(bool enabled) => _channel
      .invokeMethod<bool>('map#setLiteModeEnabled', enabled)
      .then((value) => _liteModeEnabled = value);

  /// 야간 모드가 활성화되어 있는지 여부를 반환합니다.
  ///
  /// 야간 모드가 활성화되면 지도 스타일이 어둡게 바뀝니다.
  /// 지도 유형이 야간 모드를 지원하지 않으면 야간 모드를 활성화하더라도 아무 변화가 일어나지 않습니다.
  ///
  /// 기본값은 false입니다.
  bool get nightModeEnabled => _nightModeEnabled;

  /// 야간 모드를 활성화할지 여부를 지정합니다.
  ///
  /// 야간 모드가 활성화되면 지도 스타일이 어둡게 바뀝니다.
  /// 지도 유형이 야간 모드를 지원하지 않으면 야간 모드를 활성화하더라도 아무 변화가 일어나지 않습니다.
  set nightModeEnabled(bool enabled) => _channel
      .invokeMethod<bool>('map#setNightModeEnabled', enabled)
      .then((value) => _nightModeEnabled = value);

  /// 건물의 3D 높이 배율을 반환합니다.
  ///
  /// 배율이 0일 경우 지도를 기울이더라도 건물이 2D로 나타납니다.
  ///
  /// 기본값은 1입니다.
  double get buildingHeight => _buildingHeight;

  /// 건물의 3D 높이 배율을 지정합니다.
  ///
  /// 배율이 0일 경우 지도를 기울이더라도 건물이 2D로 나타납니다.
  set buildingHeight(double height) => _channel
      .invokeMethod<double>('map#setBuildingHeight', height)
      .then((value) => _buildingHeight = value);

  /// 배경의 명도 계수를 반환합니다.
  ///
  /// 계수가 -1일 경우 명도 최소치인 검정색으로, 1일 경우 명도 최대치인 흰색으로 표시됩니다.
  /// 오버레이에는 적용되지 않습니다.
  ///
  /// 기본값은 0입니다.
  double get lightness => _lightness;

  /// 배경의 명도 계수를 지정합니다.
  ///
  /// 계수가 -1일 경우 명도 최소치인 검정색으로, 1일 경우 명도 최대치인 흰색으로 표시됩니다.
  /// 오버레이에는 적용되지 않습니다.
  set lightness(double lightness) => _channel
      .invokeMethod<double>('map#setLightness', lightness)
      .then((value) => _lightness = value);

  /// 심벌의 크기 배율을 반환합니다.
  ///
  /// 배율이 0.5일 경우 절반, 2일 경우 두 배의 크기로 표시됩니다.
  ///
  /// 기본값은 1입니다.
  double get symbolScale => _symbolScale;

  /// 심벌의 크기 배율을 지정합니다.
  ///
  /// 배율이 0.5일 경우 절반, 2일 경우 두 배의 크기로 표시됩니다.
  ///
  /// [scale]의 범위는 0 ~ 2 입니다.
  set symbolScale(double scale) => _channel
      .invokeMethod<double>('map#setSymbolScale', scale)
      .then((value) => _symbolScale = value);

  /// 지도를 기울일 때 적용되는 심벌의 원근 계수를 반환합니다.
  ///
  /// 계수가 1일 경우 배경 지도와 동일한 비율로 멀리 있는 심벌은 작아지고 가까이 있는 심벌은 커지며, 0에 가까울수록 원근 효과가 감소합니다.
  ///
  /// 기본값은 1입니다.
  double get symbolPerspectiveRatio => _symbolPerspectiveRatio;

  /// 지도를 기울일 때 적용되는 심벌의 원근 계수를 지정합니다.
  ///
  /// 계수가 1일 경우 배경 지도와 동일한 비율로 멀리 있는 심벌은 작아지고 가까이 있는 심벌은 커지며, 0에 가까울수록 원근 효과가 감소합니다.
  ///
  /// [ratio]의 범위는 0 ~ 1 입니다.
  set symbolPerspectiveRatio(double ratio) => _channel
      .invokeMethod<double>('map#setSymbolPerspectiveRatio', ratio)
      .then((value) => _symbolPerspectiveRatio = value);

  /// 실내지도 활성화 여부를 반환합니다.
  ///
  /// 활성화하면 카메라가 일정 이상 확대되고 실내지도가 있는 영역에 포커스될 경우 자동으로 해당 영역에 대한 실내지도가 나타납니다.
  bool get indoorEnabled => _indoorEnabled;

  /// 실내지도 활성화 여부를 지정합니다.
  ///
  /// 활성화하면 카메라가 일정 이상 확대되고 실내지도가 있는 영역에 포커스될 경우 자동으로 해당 영역에 대한 실내지도가 나타납니다.
  set indoorEnabled(bool enabled) => _channel
      .invokeMethod<bool>('map#setIndoorEnabled', enabled)
      .then((value) => _indoorEnabled = value);

  /// 실내지도 영역의 포커스 유지 반경을 반환합니다.
  ///
  /// 지정할 경우 카메라의 위치가 포커스 유지 반경을 완전히 벗어날 때까지 영역에 대한 포커스가 유지됩니다.
  ///
  /// 기본값은 [NaverMap.defaultIndoorFocusRadiusDP]를 픽셀로 환산한 값입니다.
  int get indoorFocusRadius => _indoorFocusRadius;

  /// 실내지도 영역의 포커스 유지 반경을 지정합니다.
  ///
  /// 지정할 경우 카메라의 위치가 포커스 유지 반경을 완전히 벗어날 때까지 영역에 대한 포커스가 유지됩니다.
  set indoorFocusRadius(int radius) => _channel
      .invokeMethod<int>('map#setIndoorFocusRadius', radius)
      .then((value) => _indoorFocusRadius = value);

  /// 지도의 배경색을 반환합니다.
  ///
  /// 배경은 해당 지역의 지도 데이터가 없거나 로딩 중일 때 나타납니다.
  Color get backgroundColor => _backgroundColor;

  /// 지도의 배경색을 지정합니다.
  ///
  /// 배경은 해당 지역의 지도 데이터가 없거나 로딩 중일 때 나타납니다.
  set backgroundColor(Color color) => _channel
      .invokeMethod<int>('map#setBackgroundColor', color.value)
      .then((value) => _backgroundColor = Color(value));

  /// 위치 추적 모드를 반환합니다.
  ///
  /// 기본값은 [LocationTrackingMode.none]입니다.
  LocationTrackingMode get locationTrackingMode => _locationTrackingMode;

  /// 위치 추적 모드를 지정합니다.
  ///
  /// 위치 소스가 null일 경우 호출하더라도 아무런 변화가 일어나지 않습니다.
  /// LocationTrackingMode.None이 아닌 값으로 지정할 경우 위치 추적 기능이 활성화됩니다.
  set locationTrackingMode(LocationTrackingMode mode) => _channel
      .invokeMethod<int>('map#setLocationTrackingMode', mode.index)
      .then((index) =>
          _locationTrackingMode = LocationTrackingMode.values[index]);

  /// 지도의 컨텐츠 패딩.
  ///
  /// 기본값은 모두 0입니다.
  EdgeInsets get contentPadding => _contentPadding;

  /// 지도의 콘텐츠 패딩을 지정합니다.
  ///
  /// 패딩에 해당하는 부분은 지도의 콘텐츠 영역에서 제외됩니다.
  /// 따라서 패딩을 변경하면 비록 화면에 나타나는 지도의 모습은 변하지 않지만 지도의 중심을 가리키는 카메라의 위치는 변경되며, [onCameraChange] 이벤트가 발생합니다.
  set contentPadding(EdgeInsets padding) => _channel.invokeListMethod<double>(
        'map#setContentPadding',
        [padding.left, padding.top, padding.right, padding.bottom],
      ).then((ltrb) => _contentPadding = EdgeInsets.fromLTRB(
            ltrb[0],
            ltrb[1],
            ltrb[2],
            ltrb[3],
          ));

  /// 지도의 최대 초당 프레임 수(FPS, frames per second)를 반환합니다.
  ///
  /// 기본값은 제한을 두지 않음을 의미하는 0입니다.
  int get fpsLimit => _fpsLimit;

  /// 지도의 최대 초당 프레임 수(FPS, frames per second)를 지정합니다.
  set fpsLimit(int fps) => _channel
      .invokeMethod<int>('map#setFpsLimit', fps)
      .then((value) => _fpsLimit = value);

  /// [layerGroup]을 활성화할지 여부를 지정합니다.
  Future<void> setLayerGroupEnabled(LayerGroup layerGroup, bool enabled) =>
      _channel.invokeMethod<bool>('map#setLayerGroupEnabled', {
        layerGroup == LayerGroup.cadastral
            ? 'landparcel'
            : layerGroup.toString().split('.').last: enabled
      }).then((value) => _layerGroupEnables[layerGroup] = value);

  /// [layerGroup]이 활성화되어 있는지 여부를 반환합니다.
  bool isLayerGroupEnabled(String layerGroup) => _layerGroupEnables[layerGroup];

  /// 현재 화면을 커버하는 [zoom] 레벨 타일 ID의 목록을 반환합니다.
  Future<List<int>> getCoveringTilesAtZoom(int zoom) =>
      _channel.invokeListMethod<int>('map#getCoveringTilesAtZoom', zoom);

  /// 카메라를 이동합니다.
  ///
  /// 만약 카메라 이동 애니메이션이 진행 중이었다면 취소되고, 진행 중인 [CameraUpdate] 객체의 [CameraUpdate.onCameraUpdateCancel] 및 [onCameraChange]가 호출됩니다.
  void moveCamera(CameraUpdate update) {
    _lastCameraUpdate = update;
    String tag;
    Map<String, dynamic> arguments;

    if (update is _CamUpdateWithParams) {
      tag = update._tag;
      arguments = update._map;
    } else if (update is _CamUpdateFitBounds) {
      tag = update._tag;
      arguments = update._map;
    }

    _channel.invokeMethod<void>('map#moveCamera_$tag', arguments);
  }

  /// 현재 진행 중인 카메라 이동 애니메이션을 [reason]을 이유로 취소합니다.
  ///
  /// 진행 중인 [CameraUpdate] 객체의 [CameraUpdate.onCameraUpdateCancel] 및 [onCameraChange]가 호출됩니다.
  void cancelTransitions([int reason = CameraUpdate.reasonDeveloper]) =>
      _channel.invokeMethod<void>('map#cancelTransitions');

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'map#updateMapViewState':
        _updateMapViewState(call);
        break;
      case 'map#onCameraChange':
        final args = call.arguments as Map;
        onCameraChange?.call(args['reason'], args['animated']);
        break;
      case 'map#onCameraIdle':
        onCameraIdle?.call();
        break;
      case 'map#onOptionChange':
        onOptionChange?.call();
        break;
      case 'map#onMapClick':
        final args = call.arguments as Map;
        onMapClick?.call(
          Offset(args['point'][0], args['point'][1]),
          LatLng.fromList(args['latLng']),
        );
        break;
      case 'map#onMapLongClick':
        final args = call.arguments as Map;
        onMapLongClick?.call(
          Offset(args['point'][0], args['point'][1]),
          LatLng.fromList(args['latLng']),
        );
        break;
      case 'map#onMapDoubleTap':
        final args = call.arguments as Map;
        onMapDoubleTap?.call(
          Offset(args['point'][0], args['point'][1]),
          LatLng.fromList(args['latLng']),
        );
        break;
      case 'map#onMapTwoFingerTap':
        final args = call.arguments as Map;
        onMapTwoFingerTap?.call(
          Offset(args['point'][0], args['point'][1]),
          LatLng.fromList(args['latLng']),
        );
        break;
      case 'cameraUpdate#onCancel':
        _lastCameraUpdate.cancelCallback?.call();
        break;
      case 'cameraUpdate#onFinish':
        _lastCameraUpdate.finishCallback?.call();
        break;
      default:
        throw NoSuchMethodError.withInvocation(
          _channel,
          Invocation.method(Symbol(call.method), call.arguments),
        );
    }
  }

  void _updateMapViewState(MethodCall call) {
    final args = call.arguments as Map;

    if (args.containsKey('cameraPosition')) {
      _cameraPosition = CameraPosition.fromMap(args['cameraPosition']);
    }
    if (args.containsKey('contentBounds')) {
      _contentBounds = LatLngBounds.fromMap(args['contentBounds']);
    }
    if (args.containsKey('coveringIleIds')) {
      _coveringIleIds = args['coveringIleIds'];
    }
  }
}
