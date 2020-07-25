part of flutter_naver_map_plugin;

/// 위경도 좌표를 나타내는 클래스.
class LatLng {
  /// 최소 위도. 도 단위.
  static const double minimumLatitude = -90;

  /// 최대 위도. 도 단위.
  static const double maximumLatitude = 90;

  /// 최소 경도. 도 단위.
  static const double minimumLongitude = -180;

  /// 최소 경도. 도 단위.
  static const double maximumLongitude = 180;

  /// 위경도 좌표로 나타낼 수 있는 [LatLngBounds]. 전 세계.
  static final LatLngBounds coverage = LatLngBounds.world;

  /// 위도. 도 단위.
  final double latitude;

  /// 경도. 도 단위.
  final double longitude;

  /// 위도와 경도로 좌표를 생성합니다.
  ///
  /// [latitude]는 -90 이상, 90 이하로 clamp.
  /// [longitude]는 -180 이상, 180 미만으로 normalize.
  const LatLng(double latitude, double longitude)
      : latitude = latitude < -90 ? -90 : (90 < latitude ? 90 : latitude),
        longitude = (longitude + 180) % 360 - 180;

  /// 기존의 [LatLng]을 새로운 객체로 복제합니다.
  factory LatLng.clone(LatLng latLng) =>
      LatLng(latLng.latitude, latLng.longitude);

  factory LatLng.fromMap(Map<dynamic, dynamic> map) =>
      LatLng(map['latitude'], map['longitude']);

  factory LatLng.fromList(List<double> list) => LatLng(list[0], list[1]);

  /// 이 [LatLng]의 [longitude]를 [minimumLongitude]와 [maximumLongitude]의 범위로 래핑한 [LatLng]을 반환합니다.
  ///
  /// [longitude]가 이미 해당 범위에 속해 있을 경우 새로운 객체가 만들어지지 않고 [this]가 반환됩니다.
  LatLng get wrap =>
      longitude >= minimumLongitude && longitude <= minimumLongitude
          ? this
          : LatLng(
              latitude,
              Geometry.wrap(longitude, minimumLongitude, minimumLongitude),
            );

  /// 이 [LatLng]가 좌표계의 [coverage] 내에 포함되는지 여부를 반환합니다.
  /// [coverage]를 벗어날 경우 좌표 연산의 정확도가 보장되지 않습니다.
  bool get isWithinCoverage => coverage.contains(this);

  /// [LatLng]이 유효한지 여부를 반환합니다.
  /// [latitude] 또는 [longitude]가 [double.nan]이거나 [double.infinity]일 경우 올바르지 않은 것으로 간주됩니다.
  bool get isValid =>
      !latitude.isNaN &&
      !longitude.isNaN &&
      !latitude.isInfinite &&
      !longitude.isInfinite;

  Map<String, double> get _map => {
        'latitude': latitude,
        'longitude': longitude,
      };

  List<double> get _list => [latitude, longitude];

  /// [other]와의 거리를 반환합니다.
  double distanceTo(LatLng other) {
    if (latitude == other.latitude && longitude == other.longitude) return 0;

    final lat1 = Geometry.toRadians(latitude);
    final lng1 = Geometry.toRadians(longitude);
    final lat2 = Geometry.toRadians(other.latitude);
    final lng2 = Geometry.toRadians(other.longitude);

    return 1.2756274E7 *
        math.asin(math.sqrt(math.pow(math.sin((lat1 - lat2) / 2.0), 2.0) +
            math.cos(lat1) *
                math.cos(lat2) *
                math.pow(math.sin((lng1 - lng2) / 2.0), 2.0)));
  }

  /// 이 좌표로부터 북쪽으로 [northMeter], 동쪽으로 [eastMeter]만큼 떨어진 [LatLng]을 반환합니다.
  LatLng offset(double northMeter, double eastMeter) {
    final newLatitude = latitude + Geometry.toDegrees(northMeter / 6378137.0);
    final newLongitude = longitude +
        Geometry.toDegrees(
            eastMeter / (6378137.0 * math.cos(Geometry.toRadians(latitude))));

    return LatLng(newLatitude, newLongitude);
  }

  @override
  String toString() => '$runtimeType: $_list';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}

/// 남서쪽과 북동쪽 두 위경도 좌표로 이루어진 [최소 경계 사각형](https://terms.naver.com/entry.nhn?docId=3479529&cid=58439&categoryId=58439) 영역을 나타내는 클래스.
class LatLngBounds {
  /// 전체 지구 영역을 나타내는 상수.
  static final LatLngBounds world = LatLngBounds(
    LatLng(-90, -180),
    LatLng(90, 180),
  );

  /// 남서쪽 좌표.
  final LatLng southwest;

  /// 북동쪽 좌표.
  final LatLng northeast;

  /// 남서쪽과 북동쪽 좌표로부터 객체를 생성합니다.
  ///
  /// [southwest.latitude]는 [northeast.latitude]보다 클 수 없습니다.
  LatLngBounds(this.southwest, this.northeast)
      : assert(southwest.latitude <= northeast.latitude);

  /// 동서남북 각각의 경계를 가지는 객체를 생성합니다.
  factory LatLngBounds.eachDirection(
    double west,
    double north,
    double east,
    double south,
  ) =>
      LatLngBounds(LatLng(south, west), LatLng(north, east));

  /// 두 좌표로부터 손쉽게 객체를 생성합니다.
  factory LatLngBounds.easy(LatLng latLng1, LatLng latLng2) {
    final southwest = latLng1.latitude < latLng2.latitude ? latLng1 : latLng2;
    final northeast = latLng1.latitude > latLng2.latitude ? latLng1 : latLng2;

    return LatLngBounds(southwest, northeast);
  }

  /// [latLngs]의 좌표를 모두 포함하는 최소한의 [LatLngBounds]를 생성합니다.
  ///
  /// [latLngs]는 null 일 수 없으며 [latLngs.length]는 2이상 이어야합니다.
  /// [latLngs]에 있는 null이거나 유효하지 않은 좌표는 무시됩니다.
  factory LatLngBounds.containsAll(Iterable<LatLng> latLngs) {
    assert(latLngs.length > 1, "The latLngs's length is must bigger then 1");

    double west, north, east, south;

    west = east = latLngs.first.longitude;
    north = south = latLngs.first.latitude;

    latLngs.forEach((latLng) {
      if (latLng == null || !latLng.isValid) return;

      if (latLng.longitude < west) west = latLng.longitude;
      if (east < latLng.longitude) east = latLng.longitude;
      if (latLng.latitude < south) south = latLng.latitude;
      if (north < latLng.latitude) north = latLng.latitude;
    });

    return LatLngBounds(LatLng(south, west), LatLng(north, east));
  }

  /// Map 형태의 객체에서 [LatLngBounds] 객체를 생성합니다.
  ///
  /// [map]에 필요 요소가 누락되거나 데이터형이 다르다면 ArgumentError 를 던집니다.
  factory LatLngBounds.fromMap(Map<String, dynamic> map) => LatLngBounds(
        LatLng.fromList(map['southwest']),
        LatLng.fromList(map['northeast']),
      );

  /// 최서단의 경도를 반환합니다.
  double get west => southwest.longitude;

  /// 최북단의 위도를 반환합니다.
  double get north => northeast.latitude;

  /// 최동단의 경도를 반환합니다.
  double get east => northeast.longitude;

  /// 최남단의 위도를 반환합니다.
  double get south => southwest.latitude;

  /// [this]의 중심점 좌표를 반환합니다.
  LatLng get center {
    final offsetY = southwest.latitude < 0 ? -southwest.latitude : 0;
    final offsetX = southwest.longitude < 0 ? -southwest.longitude : 0;

    final westNormalized = west + offsetX;
    final northNormalized = north + offsetY;
    final eastNormalized = east + offsetX;
    final southNormalized = south + offsetY;

    final latitude =
        (southNormalized + (northNormalized - southNormalized) * 0.5) - offsetY;
    final longitude =
        (westNormalized + (eastNormalized - westNormalized) * 0.5) - offsetX;

    return LatLng(latitude, longitude);
  }

  /// 이 [LatLngBounds]가 유효한지 여부를 반환합니다.
  ///
  /// [southwest]와 [northeast]가 모두 유효할 경우 유효한 것으로 간주됩니다.
  bool get isValid => southwest.isValid && northeast.isValid;

  Map<String, dynamic> get _map => {
        'southwest': southwest._list,
        'northeast': northeast._list,
      };

  /// 이 [LatLngBounds]가 [point]를 포함하는지 여부를 반환합니다.
  bool contains(LatLng point) =>
      _containsLatitude(point.latitude) && _containsLongitude(point.longitude);

  /// 이 [LatLngBounds]가 [bounds]를 포함하는지 여부를 반환합니다.
  bool containsBounds(LatLngBounds bounds) =>
      south <= bounds.south &&
      west <= bounds.west &&
      north >= bounds.north &&
      east >= bounds.east;

  /// 이 [LatLngBounds]가 [bounds]와 교차하는지 여부를 반환합니다.
  bool intersects(LatLngBounds bounds) =>
      south <= bounds.north &&
      west <= bounds.east &&
      north >= bounds.south &&
      east >= bounds.west;

  /// 이 [LatLngBounds]와 [bounds] 간의 교차 [LatLngBounds]를 반환합니다.
  ///
  /// 교차 영역이 없으면 null을 반환합니다.
  LatLngBounds intersection(LatLngBounds bounds) {
    final maxWest = math.max(west, bounds.west);
    final minEast = math.min(east, bounds.east);

    if (minEast < maxWest) return null;

    final maxSouth = math.max(south, bounds.south);
    final minNorth = math.min(north, bounds.north);

    if (minNorth < maxSouth) return null;

    return LatLngBounds.eachDirection(minNorth, minEast, maxSouth, maxWest);
  }

  /// 동서남북으로 [meter]만큼 확장한 [LatLngBounds]를 반환합니다.
  LatLngBounds bufferAll(double meter) => LatLngBounds(
        southwest.offset(-meter, -meter),
        northeast.offset(meter, meter),
      );

  /// [horizontal], [vertical] 각각의 값 만큼 확장한 [LatLngBounds]를 반환합니다.
  ///
  /// 단위는 meter.
  LatLngBounds bufferSymmetrical(double horizontal, double vertical) =>
      LatLngBounds.eachDirection(
        southwest.offset(0, -horizontal).longitude,
        northeast.offset(vertical, 0).latitude,
        northeast.offset(0, horizontal).longitude,
        southwest.offset(-vertical, 0).latitude,
      );

  /// [west], [north], [east], [south] 각각의 값 만큼 확장한 [LatLngBounds]를 반환합니다.
  ///
  /// 단위는 meter.
  LatLngBounds bufferEach(
    double west,
    double north,
    double east,
    double south,
  ) =>
      LatLngBounds.eachDirection(
        southwest.offset(0, -west).longitude,
        northeast.offset(north, 0).latitude,
        northeast.offset(0, east).longitude,
        southwest.offset(-south, 0).latitude,
      );

  /// [latLng]를 포함하도록 확장한 [LatLngBounds]를 반환합니다.
  LatLngBounds expand(LatLng latLng) => contains(latLng)
      ? this
      : LatLngBounds.eachDirection(
          math.max(north, latLng.latitude),
          math.max(east, latLng.longitude),
          math.min(south, latLng.latitude),
          math.min(west, latLng.longitude),
        );

  /// 이 [LatLngBounds]와 [bounds]를 모두 포함하는 [LatLngBounds]를 반환합니다.
  LatLngBounds union(LatLngBounds bounds) => containsBounds(bounds)
      ? this
      : LatLngBounds.eachDirection(
          math.max(north, bounds.north),
          math.max(east, bounds.east),
          math.min(south, bounds.south),
          math.min(west, bounds.west),
        );

  bool _containsLatitude(double latitude) =>
      (southwest.latitude <= latitude) && (latitude <= northeast.latitude);

  bool _containsLongitude(double longitude) {
    if (southwest.longitude <= northeast.longitude) {
      return southwest.longitude <= longitude &&
          longitude <= northeast.longitude;
    } else {
      return southwest.longitude <= longitude ||
          longitude <= northeast.longitude;
    }
  }

  @override
  String toString() => '$runtimeType: $_map';

  @override
  bool operator ==(Object o) =>
      o is LatLngBounds && o.southwest == southwest && o.northeast == northeast;

  @override
  int get hashCode => hashValues(southwest, northeast);
}
