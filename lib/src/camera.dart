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

  /// 이 [CameraPosition]을 JSON 형태로 반환합니다.
  Map<String, dynamic> get _json => {
        'bearing': bearing,
        'target': target._json,
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
  String toString() => '$runtimeType: $_json';
}
