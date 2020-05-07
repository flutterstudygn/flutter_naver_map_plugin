package rooftop.flutter_naver_map_plugin

import android.app.Application
import android.content.Context
import androidx.lifecycle.Lifecycle
import com.naver.maps.map.NaverMapSdk
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.atomic.AtomicInteger

/**
 * Created by Sugyo-In on 2020-03-20.
 */
class NaverMapFactory(
        private val state: AtomicInteger,
        private val binaryMessenger: BinaryMessenger,
        private val application: Application?,
        private val lifecycle: Lifecycle?,
        private val registrar: PluginRegistry.Registrar?,
        private val activityHashCode: Int
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<*, *>

        if (params.containsKey("clientId")) {
            NaverMapSdk.getInstance(context).client = NaverMapSdk.NaverCloudPlatformClient(params["clientId"] as String)
        }

        return FlutterNaverMap(
                id = viewId,
                context = context,
                registrar = registrar,
                application = application,
                activityHashCode = activityHashCode
        )
    }
}