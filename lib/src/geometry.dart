part of flutter_naver_map_plugin;

class Geometry {
  /// 도를 라디안으로 변환하여 반환합니다.
  static double toRadians(double degree) => degree * (math.pi / 180);

  /// 라디안을 도로 변환하여 반환합니다.
  static double toDegrees(double radian) => radian * (180 / math.pi);

  /// [value]를 [min]이상 [max]이하로 제한하여 반환합니다.
  ///
  /// [value]가 null이라면 null을 반환합니다.
  static num clamp(num value, num min, num max) {
    if (value == null) return null;

    return math.max(min, math.min(max, value));
  }

  /// [value]를 [min]이상 [max]이하로 제한하여 반환합니다.
  ///
  /// [Geometry.clamp]와 달리 [max]를 넘어가게 되면 [value]를 [max]로 나눈 나머지를 [min]과 비교합니다.
  ///
  /// [value]가 null이라면 null을 반환합니다.
  static num wrap(num value, num min, num max) {
    if (value == null) return null;
    if (min == max) return min;

    double range = max - min;

    return ((value - min) % range + range) % range + min;
  }
}
