#import "FlutterNaverMapPlugin.h"
#import <flutter_naver_map_plugin/flutter_naver_map_plugin-Swift.h>

@implementation FlutterNaverMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNaverMapPlugin registerWithRegistrar:registrar];
}
@end
