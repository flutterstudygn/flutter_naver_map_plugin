part of flutter_naver_map_plugin;

/// 카메라의 위치 관련 정보를 나타내는 불변 클래스.
///
/// 카메라의 위치는 좌표, 줌 레벨, 기울기 각도, 베어링 각도로 구성됩니다.
class CameraPosition {
  /// 카메라의 좌표.
  final LatLng target;

  /// 베어링 각도. 도 단위. 카메라가 바라보는 방위를 나타냅니다.
  ///
  /// 방위가 북쪽일 경우 0도이며, 시계 방향으로 값이 증가합니다.
  final double bearing;

  /// 기울기 각도. 도 단위. 카메라가 지면을 내려다보는 각도를 나타냅니다.
  ///
  /// 천정에서 지면을 수직으로 내려다보는 경우 0도이며, 비스듬해질수록 값이 증가합니다.
  final double tilt;

  /// 줌 레벨.
  ///
  /// 이 값이 증가할수록 축척이 증가합니다.
  final double zoom;

  /// 카메라 위치에 관한 모든 요소를 지정해 객체를 생성합니다.
  CameraPosition(
    this.target, {
    double zoom = 0,
    double bearing = 0,
    double tilt = 0,
  })  : zoom = Geometry.clamp(zoom, NaverMap.minimumZoom, NaverMap.maximumZoom),
        bearing = Geometry.wrap(
          bearing,
          NaverMap.minimumBearing,
          NaverMap.maximumBearing,
        ),
        tilt = Geometry.clamp(
          bearing,
          NaverMap.minimumTilt,
          NaverMap.maximumTilt,
        );

  /// Map 형태의 객체에서 [CameraPosition] 객체를 생성합니다.
  ///
  /// [map]에 필요 요소가 누락되거나 데이터형이 다르다면 ArgumentError 를 던집니다.
  factory CameraPosition.fromMap(Map<String, dynamic> map) => CameraPosition(
        LatLng.fromList(map['latLng']),
        zoom: map['zoom'],
        bearing: map['bearing'],
        tilt: map['tilt'],
      );

  Map<String, dynamic> get _map => {
        'bearing': bearing,
        'target': target._list,
        'tilt': tilt,
        'zoom': zoom,
      };

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final CameraPosition typedOther = other;
    return bearing == typedOther.bearing &&
        target == typedOther.target &&
        tilt == typedOther.tilt &&
        zoom == typedOther.zoom;
  }

  @override
  int get hashCode => hashValues(bearing, target, tilt, zoom);

  @override
  String toString() => '$runtimeType: $_map';
}

/// 지도를 바라보는 카메라의 이동을 정의하는 클래스.
///
/// 이 클래스의 인스턴스는 직접 생성할 수 없고, 팩토리 메서드를 이용해서 생성할 수 있습니다.
/// 생성한 인스턴스를 파라미터로 삼아 [NaverMapController.moveCamera]를 호출하면 지도를 이동시킬 수 있습니다.
///
/// 카메라의 이동은 다음과 같은 다섯 가지 요소로 구성됩니다.
/// - 카메라의 위치: 카메라를 이동할 위치. [CameraUpdate]를생성하는 팩토리 메서드의 파라미터로 지정합니다.
/// - 피봇 지점: 카메라 이동의 기준점이 되는 지점. 피봇 지점을 지정하면 이동, 줌 레벨 변경, 회전의 기준점이 해당 지점이 됩니다. [pivot]으로 지정합니다.
/// - 애니메이션: 카메라 이동 시 적용될 애니메이션. 애니메이션의 유형과 시간을 지정할 수 있습니다. [animate]로 지정합니다.
/// - 이동 원인: 카메라 이동의 원인. 이 값을 지정하면 [NaverMapController.onCameraChange]의 reason 파라미터로 전달됩니다.
/// - 콜백: 카메라 이동이 완료된 후 호출될 콜백. 카메라 이동이 방해 없이 완료된 경우와 취소된 경우를 구분할 수 있습니다. [finishCallback] 및 [cancelCallback]으로 지정합니다.
class CameraUpdate {
  /// 개발자가 API를 호출해 카메라가 움직였음을 나타내는 값.
  static const reasonDeveloper = 0;

  /// 사용자의 제스처로 인해 카메라가 움직였음을 나타내는 값.
  static const reasonGesture = -1;

  /// 사용자의 버튼 선택으로 인해 카메라가 움직였음을 나타내는 값.
  static const reasonControl = -2;

  /// 위치 정보 갱신으로 카메라가 움직였음을 나타내는 값.
  static const reasonLocation = -3;

  /// 카메라 이동이 완료된 후 호출될 콜백.
  VoidCallback finishCallback;

  /// 카메라 이동이 취소된 후 호출될 콜백.
  VoidCallback cancelCallback;

  /// 피봇 지점.
  ///
  /// 0, 0일 경우 왼쪽 위, 1, 1일 경우 오른쪽 아래 지점을 의미합니다.
  /// [CameraUpdate.fitBounds]를 이용해 객체를 생성한 경우에는 무시됩니다.
  Offset pivot = Offset.zero;

  /// 카메라 이동의 원인을 지정합니다.
  ///
  /// 기본값은 [CameraUpdate.reasonDeveloper]입니다.
  int reason = CameraUpdate.reasonDeveloper;

  CameraAnimation _animation = CameraAnimation.none;
  Duration _duration = Duration.zero;

  CameraUpdate._();

  /// bounds가 화면에 온전히 보이는 좌표와 최대 줌 레벨로 카메라의 위치를 변경하는 [CameraUpdate] 객체를 생성합니다.
  ///
  /// 기울기 각도와 베어링 각도는 0으로 변경되며, 피봇 지점은 무시됩니다.
  ///
  /// [bounds]는 카메라로 볼 영역이며 [padding]으로 영역과 지도 화면 간 확보할 최소 여백을 준다.
  factory CameraUpdate.fitBounds(
    LatLngBounds bounds, {
    EdgeInsets padding = EdgeInsets.zero,
  }) =>
      _CamUpdateFitBounds(bounds, padding);

  /// params를 이용해 카메라를 이동하는 [CameraUpdate] 객체를 생성합니다.
  factory CameraUpdate.withParams({
    LatLng scrollTo,
    Offset scrollBy,
    double rotateTo,
    double rotateBy,
    double tiltTo,
    double tiltBy,
    double zoomTo,
    double zoomBy,
  }) =>
      _CamUpdateWithParams(
        scrollTo: scrollTo,
        scrollBy: scrollBy,
        rotateTo: rotateTo,
        rotateBy: rotateBy,
        tiltTo: tiltTo,
        tiltBy: tiltBy,
        zoomTo: zoomTo,
        zoomBy: zoomBy,
      );

  /// 카메라의 줌 레벨을 1만큼 증가하는 [CameraUpdate] 객체를 생성합니다.
  ///
  /// 좌표, 기울기 각도, 베어링 각도 등 줌 레벨 외의 다른 속성은 변하지 않습니다.
  factory CameraUpdate.zoomIn() => _CamUpdateWithParams(zoomBy: 1);

  /// 카메라의 줌 레벨을 1만큼 감소하는 [CameraUpdate] 객체를 생성합니다.
  ///
  /// 좌표, 기울기 각도, 베어링 각도 등 줌 레벨 외의 다른 속성은 변하지 않습니다.
  factory CameraUpdate.zoomOut() => _CamUpdateWithParams(zoomBy: -1);

  Map<String, dynamic> get _map => {
        'pivot': [pivot.dx, pivot.dy],
        'reason': reason,
        'animation': _animation.index,
        'duration': _duration.inMilliseconds,
      };

  /// 카메라 이동 시 적용할 애니메이션을 지정합니다.
  ///
  /// [animation]이 [CameraAnimation.none]이거나 [duration]이 [Duration.zero]인 경우 지도가 애니메이션 없이 즉시 이동됩니다.
  void animate({CameraAnimation animation, Duration duration}) {
    _animation = animation ?? _animation;
    _duration = duration ?? _duration;
  }
}

class _CamUpdateFitBounds extends CameraUpdate {
  final String _tag = 'fitBounds';
  final LatLngBounds bounds;
  final EdgeInsets padding;

  _CamUpdateFitBounds(this.bounds, this.padding) : super._();

  @override
  Map<String, dynamic> get _map => super._map
    ..addAll({
      'tag': _tag,
      'bounds': bounds._map,
      'padding': [padding.left, padding.top, padding.right, padding.bottom],
    });
}

class _CamUpdateWithParams extends CameraUpdate {
  final String _tag = 'withParams';
  final LatLng scrollTo;
  final Offset scrollBy;
  final double rotateTo;
  final double rotateBy;
  final double tiltTo;
  final double tiltBy;
  final double zoomTo;
  final double zoomBy;

  _CamUpdateWithParams({
    this.scrollTo,
    this.scrollBy,
    this.rotateTo,
    this.rotateBy,
    this.tiltTo,
    this.tiltBy,
    this.zoomTo,
    this.zoomBy,
  })  : assert(
          scrollTo == null || scrollBy == null,
          'Cannot provide both a scrollTo and a scrollBy.',
        ),
        assert(
          rotateTo == null || rotateBy == null,
          'Cannot provide both a rotateTo and a rotateBy.',
        ),
        assert(
          tiltTo == null || tiltBy == null,
          'Cannot provide both a tiltTo and a tiltBy.',
        ),
        assert(
          zoomTo == null || zoomBy == null,
          'Cannot provide both a zoomTo and a zoomBy.',
        ),
        super._();

  @override
  Map<String, dynamic> get _map => super._map
    ..addAll({
      'tag': _tag,
      'scrollTo': scrollTo,
      'scrollBy': scrollBy,
      'rotateTo': rotateTo,
      'rotateBy': rotateBy,
      'tiltTo': tiltTo,
      'tiltBy': tiltBy,
      'zoomTo': zoomTo,
      'zoomBy': zoomBy,
    });
}
