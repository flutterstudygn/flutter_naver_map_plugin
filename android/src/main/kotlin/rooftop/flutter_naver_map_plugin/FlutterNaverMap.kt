package rooftop.flutter_naver_map_plugin

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.naver.maps.map.MapView
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView

/**
 * Created by Sugyo-In on 2020-03-20.
 */
class FlutterNaverMap(
        private val id: Int,
        private val registrar: PluginRegistry.Registrar?,
        context: Context,
        application: Application?,
        activityHashCode: Int
) : DefaultLifecycleObserver,
        Application.ActivityLifecycleCallbacks,
        ActivityPluginBinding.OnSaveInstanceStateListener,
        PlatformView {
    private val mapView = MapView(context)

    private val activityHashCode = activityHashCode
        get() = registrar?.activity()?.hashCode() ?: field

    private val application = application
        get() = registrar?.activity()?.application ?: field

    private var disposed = false

    override fun getView(): View = mapView

    override fun dispose() {
        if (disposed) return

        disposed = true
        mapView.onDestroy()
        application?.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onActivityPaused(activity: Activity) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onPause()
    }

    override fun onActivityResumed(activity: Activity) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onResume()
    }

    override fun onActivityStarted(activity: Activity) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onStart()
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onDestroy()
    }

    override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onSaveInstanceState(bundle)
    }

    override fun onActivityStopped(activity: Activity) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onStop()
    }

    override fun onActivityCreated(activity: Activity, bundle: Bundle?) {
        if (disposed || activity.hashCode() != activityHashCode) return
        mapView.onCreate(bundle)
    }

    override fun onCreate(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onCreate(null)
    }

    override fun onResume(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onResume()
    }

    override fun onPause(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onPause()
    }

    override fun onStart(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onStart()
    }

    override fun onStop(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onStop()
    }

    override fun onDestroy(owner: LifecycleOwner) {
        if (disposed) return
        mapView.onDestroy()
    }

    override fun onRestoreInstanceState(bundle: Bundle?) {
        if (disposed) return
        mapView.onCreate(bundle)
    }

    override fun onSaveInstanceState(bundle: Bundle) {
        if (disposed) return
        mapView.onSaveInstanceState(bundle)
    }
}