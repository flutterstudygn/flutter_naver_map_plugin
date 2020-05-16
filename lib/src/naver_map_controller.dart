part of flutter_naver_map_plugin;

class NaverMapController {
  final MethodChannel channel;

  final NaverMapOptions naverMapOptions;

  NaverMapController._(this.channel, this.naverMapOptions);

  static Future<NaverMapController> init(
    int id,
    NaverMapOptions options,
  ) async {
    return NaverMapController._(
      MethodChannel('rooftop/flutter_naver_map_plugin#$id'),
      options.clone,
    );
  }
}
