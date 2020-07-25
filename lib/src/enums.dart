part of flutter_naver_map_plugin;

/// 지도의 유형을 나타내는 열거형.
enum MapType {
  /// 일반 지도.
  basic,

  /// 내비게이션 지도.
  navi,

  /// 위성 지도.
  satellite,

  /// 위성 지도(겹쳐보기).
  hybrid,

  /// 지형도.
  terrain,

  /// 없음.
  none,
}

/// 위치 추적 모드를 나타내는 열거형.
enum LocationTrackingMode {
  /// 위치 추적을 사용하지 않는 모드.
  none,

  /// 위치는 추적하지만 지도는 움직이지 않는 모드.
  noFollow,

  /// 위치를 추적하면서 카메라도 따라 움직이는 모드.
  follow,

  /// 위치를 추적하면서 카메라의 좌표와 베어링도 따라 움직이는 모드.
  face,
}

/// 카메라 이동 애니메이션 유형을 정의하는 열거형 클래스.
/// [CameraUpdate]에서 사용합니다.
enum CameraAnimation {
  /// 애니메이션 없음.
  none,

  /// 선형 애니메이션.
  linear,

  /// 부드럽게 가감속되는 애니메이션.
  easing,

  /// 플라잉 애니메이션.
  fly,
}

/// 레이어 그룹.
enum LayerGroup {
  /// 건물 레이어 그룹.
  building,

  /// 대중교통 레이어 그룹.
  transit,

  /// 자전거 도로 레이어 그룹.
  bicycle,

  /// 실시간 교통정보 레이어 그룹.
  traffic,

  /// 지적편집도 레이어 그룹.
  cadastral,

  /// 등산로 레이어 그룹.
  mountain,
}
