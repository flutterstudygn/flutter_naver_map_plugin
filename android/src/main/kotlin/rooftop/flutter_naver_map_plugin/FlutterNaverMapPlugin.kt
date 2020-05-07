package rooftop.flutter_naver_map_plugin

import android.app.Activity
import android.app.Application
import android.os.Bundle
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.concurrent.atomic.AtomicInteger

private const val VIEW_TYPE = "rooftop/flutter_naver_map_plugin"
private const val CREATED = 1
private const val STARTED = 2
private const val RESUMED = 3
private const val PAUSED = 4
private const val STOPPED = 5
private const val DESTROYED = 6

class FlutterNaverMapPlugin private constructor(
        private val registrarActivityHashCode: Int
) : Application.ActivityLifecycleCallbacks,
        DefaultLifecycleObserver,
        FlutterPlugin,
        ActivityAware {
  private val state = AtomicInteger(0)

  private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

  private lateinit var lifecycle: Lifecycle

  // V1 Android embedding >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      // When a background flutter view tries to register the plugin, the registrar has no activity.
      // We stop the registration process as this plugin is foreground only.
      registrar.activity() ?: return

      val plugin = FlutterNaverMapPlugin(registrar.activity().hashCode())

      registrar.apply {
        activity().application.registerActivityLifecycleCallbacks(plugin)
        platformViewRegistry()
                .registerViewFactory(
                        VIEW_TYPE,
                        NaverMapFactory(
                                plugin.state,
                                registrar.messenger(),
                                null,
                                null,
                                registrar,
                                -1
                        )
                )
      }
    }
  }

  // Application.ActivityLifecycleCallbacks methods

  override fun onActivityCreated(activity: Activity, bundle: Bundle) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }
    state.set(CREATED)
  }

  override fun onActivityStarted(activity: Activity) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }
    state.set(STARTED)
  }

  override fun onActivityResumed(activity: Activity) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }
    state.set(RESUMED)
  }

  override fun onActivityPaused(activity: Activity) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }
    state.set(PAUSED)
  }

  override fun onActivityStopped(activity: Activity) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }
    state.set(STOPPED)
  }

  override fun onActivityDestroyed(activity: Activity) {
    if (activity.hashCode() != registrarActivityHashCode) {
      return
    }

    activity.application.unregisterActivityLifecycleCallbacks(this)
    state.set(DESTROYED)
  }

  override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {}

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> V1 Android embedding

  // V2 Android embedding >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  // FlutterPlugin

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = binding
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = null
  }

  // ActivityAware

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding).also {
      it.addObserver(this)
    }

    pluginBinding?.platformViewRegistry?.registerViewFactory(
            VIEW_TYPE,
            NaverMapFactory(
                    state,
                    pluginBinding!!.binaryMessenger,
                    binding.activity.application,
                    lifecycle,
                    null,
                    binding.activity.hashCode()
            )
    )
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding).also {
      it.addObserver(this)
    }
  }

  override fun onDetachedFromActivity() {
    lifecycle.removeObserver(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  // DefaultLifecycleObserver methods

  override fun onCreate(owner: LifecycleOwner) {
    state.set(CREATED)
  }

  override fun onStart(owner: LifecycleOwner) {
    state.set(STARTED)
  }

  override fun onResume(owner: LifecycleOwner) {
    state.set(RESUMED)
  }

  override fun onPause(owner: LifecycleOwner) {
    state.set(PAUSED)
  }

  override fun onStop(owner: LifecycleOwner) {
    state.set(STOPPED)
  }

  override fun onDestroy(owner: LifecycleOwner) {
    state.set(DESTROYED)
  }

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> V2 Android embedding
}
