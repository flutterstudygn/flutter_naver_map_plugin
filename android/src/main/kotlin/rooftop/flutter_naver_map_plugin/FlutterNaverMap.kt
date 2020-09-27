package rooftop.flutter_naver_map_plugin

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.View
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.naver.maps.map.LocationTrackingMode
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView
import java.util.*
import kotlin.math.roundToInt

/**
 * Created by Sugyo-In on 2020-03-20.
 */
class FlutterNaverMap(
        private val id: Int,
        private val registrar: PluginRegistry.Registrar?,
        private val context: Context,
        binaryMessenger: BinaryMessenger,
        application: Application?,
        activityHashCode: Int,
        naverMapOptions: NaverMapOptions
) : DefaultLifecycleObserver,
        Application.ActivityLifecycleCallbacks,
        ActivityPluginBinding.OnSaveInstanceStateListener,
        MethodChannel.MethodCallHandler,
        PlatformView {
    private val tag = "FlutterNaverMap"

    private val methodChannel: MethodChannel = MethodChannel(binaryMessenger, "rooftop/flutter_naver_map_plugin#$id")

    private val mapView = MapView(context, naverMapOptions)

    private val activityHashCode = activityHashCode
        get() = registrar?.activity()?.hashCode() ?: field

    private val application = application
        get() = registrar?.activity()?.application ?: field

    private val mapSurfaceState = mutableMapOf<String, Any?>(
            "cameraPosition" to null,
            "contentBounds" to null,
            "contentRegion" to null,
            "coveringTileIds" to null
    )

    private var disposed = false

    private lateinit var map: NaverMap

    init {
        methodChannel.setMethodCallHandler(this)

        mapView.getMapAsync { naverMap ->
            map = naverMap

            mapSurfaceState["cameraPosition"] = map.cameraPosition
            mapSurfaceState["contentBounds"] = map.contentBounds
            mapSurfaceState["coveringTileIds"] = map.coveringTileIds

            methodChannel.invokeMethod("map#updateMapViewState", mapOf(
                    "cameraPosition" to map.cameraPosition.toMap(),
                    "contentBounds" to map.contentBounds.toMap(),
                    "coveringTileIds" to map.coveringTileIds
            ))

            map.apply {
                addOnCameraChangeListener { reason, animated ->
                    methodChannel.invokeMethod("map#onCameraChange", mapOf(
                            "reason" to reason,
                            "animated" to animated
                    ))
                }

                addOnCameraIdleListener {
                    val payload = mutableMapOf<String, Any>()

                    if (mapSurfaceState["cameraPosition"] != map.cameraPosition) payload["cameraPosition"] = map.cameraPosition.toMap()
                    if (mapSurfaceState["contentBounds"] != map.contentBounds) payload["contentBounds"] = map.contentBounds.toMap()
                    if (mapSurfaceState["coveringTileIds"] != map.coveringTileIds) payload["coveringTileIds"] = map.coveringTileIds

                    methodChannel.run {
                        invokeMethod("map#updateMapSurfaceState", payload)
                        invokeMethod("map#onCameraIdle", null)
                    }
                }

                addOnOptionChangeListener { methodChannel.invokeMethod("map#onOptionChange", null) }

                onMapClickListener = NaverMap.OnMapClickListener { pointF, latLng ->
                    methodChannel.invokeMethod("map#onMapClick", mapOf(
                            "point" to doubleArrayOf(pointF.x.toDouble(), pointF.y.toDouble()),
                            "latLng" to latLng.toArray()
                    ))
                }

                onMapLongClickListener = NaverMap.OnMapLongClickListener { pointF, latLng ->
                    methodChannel.invokeMethod("map#onMapLongClick", mapOf(
                            "point" to doubleArrayOf(pointF.x.toDouble(), pointF.y.toDouble()),
                            "latLng" to latLng.toArray()
                    ))
                }

                onMapDoubleTapListener = NaverMap.OnMapDoubleTapListener { pointF, latLng ->
                    methodChannel.invokeMethod(
                            "map#onMapDoubleTap",
                            mapOf(
                                    "point" to doubleArrayOf(pointF.x.toDouble(), pointF.y.toDouble()),
                                    "latLng" to latLng.toArray()
                            )
                    )

                    return@OnMapDoubleTapListener false
                }

                onMapTwoFingerTapListener = NaverMap.OnMapTwoFingerTapListener { pointF, latLng ->
                    methodChannel.invokeMethod(
                            "map#onMapTwoFingerTap",
                            mapOf(
                                    "point" to doubleArrayOf(pointF.x.toDouble(), pointF.y.toDouble()),
                                    "latLng" to latLng.toArray()
                            )
                    )

                    return@OnMapTwoFingerTapListener false
                }
            }
        }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result, map: NaverMap) {
        when (call.method) {
            "map#setLocale" -> {
                val localeSegments = (call.arguments as String).split("_")
                map.locale = Locale(localeSegments[0], localeSegments[1])
                result.success(map.locale.toString())
            }
            "map#setCameraPosition" -> {
                map.cameraPosition = Convert.interpretCameraPosition(call.arguments as Map<*, *>)
                result.success(map.cameraPosition.toMap())
            }
            "map#setDefaultCameraAnimationDuration" -> {
                map.defaultCameraAnimationDuration = call.arguments as Int
                result.success(map.defaultCameraAnimationDuration)
            }
            "map#setExtent" -> {
                map.extent = Convert.interpretLatLngBounds(call.arguments as Map<*, *>)
                result.success(map.extent!!.toMap())
            }
            "map#setMinZoom" -> {
                map.minZoom = call.arguments as Double
                result.success(map.minZoom)
            }
            "map#setMaxZoom" -> {
                map.maxZoom = call.arguments as Double
                result.success(map.maxZoom)
            }
            "map#setMapType" -> {
                map.mapType = NaverMap.MapType.values()[call.arguments as Int]
                result.success(map.mapType.ordinal)
            }
            "map#setLiteModeEnabled" -> {
                map.isLiteModeEnabled = call.arguments as Boolean
                result.success(map.isLiteModeEnabled)
            }
            "map#setNightModeEnabled" -> {
                map.isNightModeEnabled = call.arguments as Boolean
                result.success(map.isNightModeEnabled)
            }
            "map#setBuildingHeight" -> {
                map.buildingHeight = (call.arguments as Double).toFloat()
                result.success(map.buildingHeight)
            }
            "map#setLightness" -> {
                map.lightness = (call.arguments as Double).toFloat()
                result.success(map.lightness)
            }
            "map#setSymbolScale" -> {
                map.symbolScale = (call.arguments as Double).toFloat()
                result.success(map.symbolScale)
            }
            "map#setSymbolPerspectiveRatio" -> {
                map.symbolPerspectiveRatio = (call.arguments as Double).toFloat()
                result.success(map.symbolPerspectiveRatio)
            }
            "map#setIndoorEnabled" -> {
                map.isIndoorEnabled = call.arguments as Boolean
                result.success(map.isIndoorEnabled)
            }
            "map#setIndoorFocusRadius" -> {
                map.indoorFocusRadius = call.arguments as Int
                result.success(map.indoorFocusRadius)
            }
            "map#setBackgroundColor" -> {
                map.backgroundColor = (call.arguments as Number).toInt()
                result.success(map.backgroundColor)
            }
            "map#setLocationTrackingMode" -> {
                map.locationTrackingMode = LocationTrackingMode.values()[call.arguments as Int]
                result.success(map.locationTrackingMode.ordinal)
            }
            "map#setContentPadding" -> {
                val ltrb = call.arguments as List<*>
                val density = context.resources.displayMetrics.density
                map.setContentPadding(
                        ((ltrb[0] as Double) * density).roundToInt(),
                        ((ltrb[1] as Double) * density).roundToInt(),
                        ((ltrb[2] as Double) * density).roundToInt(),
                        ((ltrb[3] as Double) * density).roundToInt()
                )
                result.success(ltrb)
            }
            "map#setFpsLimit" -> {
                map.fpsLimit = call.arguments as Int
                result.success(map.fpsLimit)
            }
            "map#setLayerGroupEnabled" -> {
                val arg = (call.arguments as Map<*, *>).entries.first()
                map.setLayerGroupEnabled(arg.key as String, arg.value as Boolean)
                result.success(map.isLayerGroupEnabled(arg.key as String))
            }
            "map#getCoveringTilesAtZoom" -> {
                result.success(map.getCoveringTileIdsAtZoom(call.arguments as Int))
            }
            "map#moveCamera_withParams" -> {
                map.moveCamera(Convert.interpretCameraUpdateWithParams(call.arguments as Map<*, *>, methodChannel))
            }
            "map#moveCamera_fitBounds" -> {
                map.moveCamera(Convert.interpretCameraUpdateFitBounds(call.arguments as Map<*, *>, methodChannel))
            }
            "map#cancelTransitions" -> {
                map.cancelTransitions()
            }
            else -> result.notImplemented()
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (this::map.isInitialized) {
            onMethodCall(call, result, map)
        } else {
            mapView.getMapAsync { map -> onMethodCall(call, result, map) }
        }
    }

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
