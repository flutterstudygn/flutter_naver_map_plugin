part of flutter_naver_map_plugin;

/// 지도의 옵션을 지정하는 클래스.
class NaverMapOptions {
  /// 지도의 로캘을 지정합니다.
  ///
  /// 기본값은 시스템 로캘입니다.
  final Locale locale;

  /// 지도의 초기 카메라 위치를 지정합니다.
  ///
  /// 기본 위치는 서울특별시청입니다.
  final CameraPosition camera;

  /// 지도의 제한 영역을 지정합니다.
  ///
  /// null일 경우 제한을 두지 않습니다.
  final LatLngBounds extent;

  /// 지도의 최소 줌 레벨.
  ///
  /// 기본값은 [NaverMap.minimumZoom]입니다.
  final double minZoom;

  /// 지도의 최대 줌 레벨.
  ///
  /// 기본값은 [NaverMap.maximumZoom]입니다.
  final double maxZoom;

  /// 지도의 컨텐츠 패딩.
  ///
  /// 단위는 픽셀입니다.
  ///
  /// 기본값은 모두 0입니다.
  final EdgeInsets contentPadding;

  /// 카메라 이동 애니메이션의 기본 지속 시간.
  ///
  /// 밀리초 단위.
  ///
  /// 기본값은 [NaverMap.defaultCameraAnimationDuration]입니다.
  final int defaultCameraAnimationDuration;

  /// 지도의 유형.
  ///
  /// 기본값은 [MapType.basic]입니다.
  final MapType mapType;

  /// 활성화할 레이어 그룹의 목록.
  final List<String> enabledLayerGroups;

  /// 비활성화할 레이어 그룹의 목록.
  final List<String> disabledLayerGroups;

  /// 라이트 모드를 활성화할지 여부.
  ///
  /// 라이트 모드가 활성화되면 지도의 로딩이 빨라지고 메모리 소모가 감소합니다.
  /// 그러나 다음과 같은 제약이 생깁니다.
  /// * 지도의 전반적인 화질이 하락합니다.
  /// * 카메라가 회전하거나 기울어지면 지도 심벌도 함께 회전하거나 기울어집니다.
  /// * 줌 레벨이 커지거나 작아지면 지도 심벌도 일정 정도 함께 커지거나 작아집니다.
  /// * NaverMap.MapType.Navi 지도 유형을 사용할 수 없습니다.
  /// * enabledLayerGroups(String...), indoorEnabled(boolean), nightModeEnabled(boolean), lightness(float), buildingHeight(float), symbolScale(float), symbolPerspectiveRatio(float)가 동작하지 않습니다.
  /// * NaverMap.OnSymbolClickListener.onSymbolClick(Symbol)이 호출되지 않습니다.
  /// * Marker.setHideCollidedSymbols(boolean)가 동작하지 않습니다.
  ///
  /// 기본값은 false입니다.
  final bool liteModeEnabled;

  /// 야간 모드를 활성화할지 여부.
  ///
  /// 야간 모드가 활성화되면 지도 스타일이 어둡게 바뀝니다.
  /// 지도 유형이 야간 모드를 지원하지 않으면 활성화하더라도 아무 변화가 일어나지 않습니다.
  ///
  /// 기본값은 false입니다.
  final bool nightModeEnabled;

  /// 건물의 3D 높이 배율.
  ///
  /// 배율이 0일 경우 지도를 기울이더라도 건물이 2D로 나타납니다. 0 ~ 1 범위.
  ///
  /// 기본값은 1입니다.
  final double buildingHeight;

  /// 배경의 명도 계수.
  ///
  /// 계수가 -1일 경우 명도 최소치인 검정색으로, 1일 경우 명도 최대치인 흰색으로 표시됩니다.
  /// 오버레이에는 적용되지 않습니다. -1 ~ 1 범위.
  ///
  /// 기본값은 0입니다.
  final double lightness;

  /// 심벌의 크기 배율.
  ///
  /// 배율이 0.5일 경우 절반, 2일 경우 두 배의 크기로 표시됩니다. 0 ~ 2 범위.
  ///
  /// 기본값은 1입니다.
  final double symbolScale;

  /// 지도를 기울일 때 적용되는 심벌의 원근 계수.
  ///
  /// 계수가 1일 경우 배경 지도와 동일한 비율로 멀리 있는 심벌은 작아지고 가까이 있는 심벌은 커지며,
  /// 0에 가까울수록 원근 효과가 감소합니다. 0 ~ 1 범위.
  ///
  /// 기본값은 1입니다.
  final double symbolPerspectiveRatio;

  /// 실내지도를 활성화할지 여부.
  ///
  /// 활성화하면 카메라가 일정 이상 확대되고 실내지도가 있는 영역에 포커스될 경우 자동으로 해당 영역의 실내지도가 나타납니다.
  ///
  /// 기본값은 false입니다.
  final bool indoorEnabled;

  /// 실내지도 영역의 포커스 유지 반경.
  ///
  /// 지정할 경우 카메라의 위치가 포커스 유지 반경을 완전히 벗어날 때까지 영역에 대한 포커스가 유지됩니다.
  /// 픽셀 단위.
  ///
  /// 기본값은 [NaverMap.defaultIndoorFocusRadiusDP]를 픽셀로 환산한 값을 의미하는 -1입니다.
  final int indoorFocusRadius;

  /// 지도의 배경색.
  ///
  /// 배경은 해당 지역의 지도 데이터가 없거나 로딩 중일 때 나타납니다.
  ///
  /// 기본값은 [NaverMap.defaultBackgroundColorLight]입니다.
  final Color backgroundColor;

  /// 지도의 배경 리소스.
  ///
  /// 배경은 해당 지역의 지도 데이터가 없거나 로딩 중일 때 나타납니다.
  /// resId가 올바르지 않을 경우 backgroundColor(int)를 이용해 지정된 배경색이 사용됩니다.
  ///
  /// 기본값은 NaverMap.DEFAULT_BACKGROUND_DRWABLE_LIGHT입니다.
  // TODO: 리소스 관련 속성으로 차후 작업 필요.
  //  final int backgroundResource;

  /// 지도 클릭 시 피킹되는 [Pickable]의 클릭 허용 반경.
  ///
  /// 사용자가 지도를 클릭했을 때, 클릭된 지점이 [Pickable]의 영역 내에 존재하지 않더라도 허용 반경 내에 있다면 해당 요소가 클릭된 것으로 간주됩니다.
  /// 픽셀 단위.
  ///
  /// 기본값은 [NaverMap.defaultPickToleranceDP]를 픽셀로 환산한 값을 의미하는 -1입니다.
  final int pickTolerance;

  /// 스크롤 제스처를 활성화할지 여부.
  ///
  /// 활성화하면 지도를 스와이프해 카메라의 좌표를 변경할 수 있습니다.
  ///
  /// 기본값은 true입니다.
  final bool scrollGesturesEnabled;

  /// 줌 제스처를 활성화할지 여부.
  ///
  /// 활성화하면 지도를 더블 탭, 두 손가락 탭, 핀치해 카메라의 줌 레벨을 변경할 수 있습니다.
  ///
  /// 기본값은 true입니다.
  final bool zoomGesturesEnabled;

  /// 틸트 제스처를 활성화할지 여부.
  ///
  /// 활성화하면 지도를 두 손가락으로 세로로 스와이프해 카메라의 기울기 각도를 변경할 수 있습니다.
  ///
  /// 기본값은 true입니다.
  final bool tiltGesturesEnabled;

  /// 회전 제스처를 활성화할지 여부.
  ///
  /// 활성화하면 두 손가락으로 지도를 돌려 카메라의 베어링 각도를 변경할 수 있습니다.
  ///
  /// 기본값은 true입니다.
  final bool rotateGesturesEnabled;

  /// 스톱 제스처를 활성화할지 여부.
  ///
  /// 활성화하면 지도 애니메이션 진행 중 탭으로 지도 애니메이션을 중지할 수 있습니다.
  ///
  /// 기본값은 true입니다.
  final bool stopGesturesEnabled;

  /// 스크롤 제스처의 마찰 계수.
  ///
  /// 계수가 클수록 마찰이 강해집니다. 0 ~ 1 범위.
  ///
  /// 기본값은 [NaverMap.defaultScrollGesturesFriction]입니다.
  final double scrollGesturesFriction;

  /// 줌 제스처의 마찰 계수.
  ///
  /// 계수가 클수록 마찰이 강해집니다. 0 ~ 1 범위.
  ///
  /// 기본값은 [NaverMap.defaultZoomGesturesFriction]입니다.
  final double zoomGesturesFriction;

  /// 회전 제스처의 마찰 계수.
  ///
  /// 계수가 클수록 마찰이 강해집니다.  0 ~ 1 범위.
  ///
  /// 기본값은 [NaverMap.defaultRotateGesturesFriction]입니다.
  final double rotateGesturesFriction;

  /// 나침반을 활성화할지 여부.
  ///
  /// 활성화하면 나침반이 노출됩니다.
  ///
  /// 기본값은 true입니다.
  final bool compassEnabled;

  /// 축척 바를 활성화할지 여부.
  ///
  /// 활성화하면 축척 바가 노출됩니다.
  ///
  /// 기본값은 true입니다.
  final bool scaleBarEnabled;

  /// 줌 컨트롤을 활성화할지 여부.
  ///
  /// 활성화하면 줌 컨트롤이 노출됩니다.
  ///
  /// 기본값은 true입니다.
  final bool zoomControlEnabled;

  /// 실내지도 층 피커를 활성화할지 여부.
  ///
  /// 활성화하면 실내지도 패널이 노출됩니다.
  ///
  /// 기본값은 true입니다.
  final bool indoorLevelPickerEnabled;

  /// 현위치 버튼을 활성화할지 여부.
  ///
  /// 활성화하면 현위치 버튼이 노출됩니다.
  ///
  /// 기본값은 false입니다.
  final bool locationButtonEnabled;

  /// 네이버 로고 클릭을 활성화할지 여부.
  ///
  /// 활성화하면 네이버 로고 클릭시 범례, 법적 공지, 오픈소스 라이선스를 보여주는 다이얼로그가 열립니다.
  /// **이 옵션을 false로 지정하는 앱은 반드시 앱 내에 네이버 지도 SDK의 법적 공지 Widget 및 오픈소스 라이선스 Widget으로 연결되는 메뉴를 만들어야 합니다.**
  ///
  /// 기본값은 true입니다.
  final bool logoClickEnabled;

  /// 네이버 로고의 그래비티.
  ///
  /// 기본값은 지정하지 않음을 의미하는 [AndroidPlatformConstants.noGravity]입니다.
  final int logoGravity;

  /// 네이버 로고의 마진.
  ///
  /// 픽셀 단위.
  final EdgeInsets logoMargin;

  /// 지도의 최대 초당 프레임 수(FPS, frames per second).
  ///
  /// 기본값은 제한을 두지 않음을 의미하는 0입니다.
  final int fpsLimit;

  /// 지도 렌더링을 위해 GLSurfaceView대신 TextureView를 사용할지 여부.
  ///
  /// 기본값은 debug build에선 true release builde에선 false 입니다.
  ///
  /// 이유는 알 수 없지만 hot reload 시 GLSurfaceView를 사용하면 네이버 지도 sdk의 NDK 레벨에서 에러를 내보내며 앱이 죽습니다.
  /// 또한 hot restart 시엔 지도 객체가 destory된 후 재생성되지 않습니다.
  final bool useTextureView;

  /// TextureView를 투명하게 만들지 여부.
  ///
  /// TextureView를 사용하지 않고 GLSurfaceView를 사용하는 경우에는 무시됩니다.
  ///
  /// 기본값은 false입니다.
  final bool translucentTextureSurface;

  /// GLSurfaceView의 zOrderMediaOverlay를 활성화할지 여부.
  ///
  /// GLSurfaceView를 사용하지 않고 TextureView를 사용하는 경우에는 무시됩니다.
  ///
  /// 기본값은 false입니다.
  final bool zOrderMediaOverlay;

  /// GLSurfaceView의 preserveEGLContextOnPause를 활성화할지 여부.
  ///
  /// GLSurfaceView를 사용하지 않고 TextureView를 사용하는 경우에는 무시됩니다.
  ///
  /// 기본값은 true입니다.
  final bool preserveEGLContextOnPause;

  NaverMapOptions({
    this.minZoom = NaverMap.minimumZoom,
    this.maxZoom = NaverMap.maximumZoom,
    this.contentPadding = EdgeInsets.zero,
    this.defaultCameraAnimationDuration =
        NaverMap.defaultCameraAnimationDuration,
    this.mapType = MapType.basic,
    this.enabledLayerGroups = const [],
    this.disabledLayerGroups = const [],
    this.liteModeEnabled = false,
    this.nightModeEnabled = false,
    this.indoorEnabled = false,
    this.indoorFocusRadius = -1,
    this.backgroundColor = NaverMap.defaultBackgroundColorLight,
//    this.backgroundResource = 0, TODO
    this.pickTolerance = NaverMap.defaultPickToleranceDP,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.stopGesturesEnabled = true,
    this.compassEnabled = true,
    this.scaleBarEnabled = true,
    this.zoomControlEnabled = true,
    this.indoorLevelPickerEnabled = true,
    this.locationButtonEnabled = false,
    this.logoClickEnabled = true,
    this.logoGravity = AndroidPlatformConstants.noGravity,
    this.logoMargin = EdgeInsets.zero,
    this.fpsLimit = 0,
    this.useTextureView = kDebugMode,
    this.translucentTextureSurface = false,
    this.zOrderMediaOverlay = false,
    this.preserveEGLContextOnPause = true,
    this.extent,
    double buildingHeight = 1,
    double lightness = 0,
    double symbolScale = 1,
    double symbolPerspectiveRatio = 1,
    double scrollGesturesFriction = NaverMap.defaultScrollGesturesFriction,
    double zoomGesturesFriction = NaverMap.defaultZoomGesturesFriction,
    double rotateGesturesFriction = NaverMap.defaultRotateGesturesFriction,
    CameraPosition camera,
  })  : locale = ui.window.locale,
        buildingHeight = Geometry.clamp(buildingHeight, 0.0, 1.0),
        lightness = Geometry.clamp(lightness, -1.0, 1.0),
        symbolScale = Geometry.clamp(symbolScale, 0.0, 2.0),
        symbolPerspectiveRatio =
            Geometry.clamp(symbolPerspectiveRatio, 0.0, 1.0),
        scrollGesturesFriction =
            Geometry.clamp(scrollGesturesFriction, 0.0, 1.0),
        zoomGesturesFriction = Geometry.clamp(zoomGesturesFriction, 0.0, 1.0),
        rotateGesturesFriction =
            Geometry.clamp(rotateGesturesFriction, 0.0, 1.0),
        camera = camera ??
            CameraPosition(
              LatLng(37.5666102, 126.9783881),
              zoom: 14,
              tilt: 0.0,
              bearing: 0.0,
            );

  /// 이 [NaverMapOptions]를 JSON 형태로 반환합니다.
  Map<String, dynamic> get _json => {
        'locale': locale.toLanguageTag(),
        'extent': extent?._json,
        'minZoom': minZoom,
        'maxZoom': maxZoom,
        'contentPadding': {
          'left': contentPadding.left,
          'top': contentPadding.top,
          'right': contentPadding.right,
          'bottom': contentPadding.bottom
        },
        'defaultCameraAnimationDuration': defaultCameraAnimationDuration,
        'mapType': mapType.index,
        'enabledLayerGroups': enabledLayerGroups,
        'disabledLayerGroups': disabledLayerGroups,
        'liteModeEnabled': liteModeEnabled,
        'nightModeEnabled': nightModeEnabled,
        'indoorEnabled': indoorEnabled,
        'indoorFocusRadius': indoorFocusRadius,
        'backgroundColor': backgroundColor.value,
        //'backgroundResource' : backgroundResource, todo,
        'pickTolerance': pickTolerance,
        'scrollGesturesEnabled': scrollGesturesEnabled,
        'zoomGesturesEnabled': zoomGesturesEnabled,
        'tiltGesturesEnabled': tiltGesturesEnabled,
        'rotateGesturesEnabled': rotateGesturesEnabled,
        'stopGesturesEnabled': stopGesturesEnabled,
        'compassEnabled': compassEnabled,
        'scaleBarEnabled': scaleBarEnabled,
        'zoomControlEnabled': zoomControlEnabled,
        'indoorLevelPickerEnabled': indoorLevelPickerEnabled,
        'locationButtonEnabled': locationButtonEnabled,
        'logoClickEnabled': logoClickEnabled,
        'logoGravity': logoGravity,
        'logoMargin': {
          'left': logoMargin.left,
          'top': logoMargin.top,
          'right': logoMargin.right,
          'bottom': logoMargin.bottom
        },
        'fpsLimit': fpsLimit,
        'useTextureView': useTextureView,
        'translucentTextureSurface': translucentTextureSurface,
        'zOrderMediaOverlay': zOrderMediaOverlay,
        'preserveEGLContextOnPause': preserveEGLContextOnPause,
        'buildingHeight': buildingHeight,
        'lightness': lightness,
        'symbolScale': symbolScale,
        'symbolPerspectiveRatio': symbolPerspectiveRatio,
        'scrollGesturesFriction': scrollGesturesFriction,
        'zoomGesturesFriction': zoomGesturesFriction,
        'rotateGesturesFriction': rotateGesturesFriction,
        'camera': camera._json,
      };

  NaverMapOptions get clone => NaverMapOptions(
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
        camera: camera,
      );

  @override
  String toString() => '$runtimeType: $_json';
}
