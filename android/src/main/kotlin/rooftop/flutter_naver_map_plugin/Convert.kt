package rooftop.flutter_naver_map_plugin

import android.graphics.PointF
import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.*
import io.flutter.plugin.common.MethodChannel
import java.util.*
import kotlin.math.roundToInt


/**
 * Created by Sugyo-In on 2020-05-09.
 */

fun LatLng.toArray(): DoubleArray = doubleArrayOf(latitude, longitude)

fun LatLngBounds.toMap(): Map<String, Any> = mapOf(
        "southwest" to southWest.toArray(),
        "northeast" to northEast.toArray()
)

fun CameraPosition.toMap(): Map<String, Any> = mapOf(
        "target" to target.toArray(),
        "zoom" to zoom,
        "tilt" to tilt,
        "bearing" to bearing
)

class Convert {
    companion object {
        fun interpretLatLng(o: List<*>): LatLng = LatLng(o[0] as Double, o[1] as Double)

        fun interpretLatLngBounds(o: Map<*, *>): LatLngBounds = LatLngBounds(
                interpretLatLng(o["southwest"] as List<*>),
                interpretLatLng(o["northeast"] as List<*>)
        )

        fun interpretCameraPosition(o: Map<*, *>): CameraPosition = CameraPosition(
                interpretLatLng(o["target"] as List<*>),
                o["zoom"] as Double,
                o["tilt"] as Double,
                o["bearing"] as Double
        )

        fun interpretCameraUpdateWithParams(o: Map<*, *>, methodChannel: MethodChannel): CameraUpdate {
            val update = CameraUpdate.withParams(CameraUpdateParams().apply {
                if (o.containsKey("scrollTo")) scrollTo(interpretLatLng(o["scrollTo"] as List<*>))
                if (o.containsKey("scrollBy")) scrollBy(interpretPointF(o["scrollBy"] as List<*>))
                if (o.containsKey("rotateTo")) rotateTo(o["rotateTo"] as Double)
                if (o.containsKey("rotateBy")) rotateBy(o["rotateBy"] as Double)
                if (o.containsKey("tiltTo")) tiltTo(o["tiltTo"] as Double)
                if (o.containsKey("tiltBy")) tiltBy(o["tiltBy"] as Double)
                if (o.containsKey("zoomTo")) zoomTo(o["zoomTo"] as Double)
                if (o.containsKey("zoomBy")) zoomBy(o["zoomBy"] as Double)
            })

            return interpretCameraUpdate(update, o, methodChannel)
        }

        fun interpretCameraUpdateFitBounds(o: Map<*, *>, methodChannel: MethodChannel): CameraUpdate {
            val padding = o["padding"] as List<*>

            val update = CameraUpdate.fitBounds(
                    interpretLatLngBounds(o["bounds"] as Map<*, *>),
                    padding[0] as Int, padding[1] as Int, padding[2] as Int, padding[3] as Int
            )

            return interpretCameraUpdate(update, o, methodChannel)
        }

        fun interpretNaverMapOptions(o: Map<*, *>, density: Float): NaverMapOptions =
                NaverMapOptions().also { options ->
                    val contentPadding = interpretContentPadding(o["contentPadding"] as List<*>, density)
                    val logoMargin = interpretContentPadding(o["logoMargin"] as List<*>, density)

                    options.locale(interpretLocale(o["locale"] as String))
                    o["extent"]?.let { options.extent(interpretLatLngBounds(it as Map<*, *>)) }
                    options.minZoom(o["minZoom"] as Double)
                    options.maxZoom(o["maxZoom"] as Double)
                    options.contentPadding(contentPadding[0], contentPadding[1], contentPadding[2], contentPadding[3])
                    options.defaultCameraAnimationDuration(o["defaultCameraAnimationDuration"] as Int)
                    options.mapType(NaverMap.MapType.values()[o["mapType"] as Int])
                    options.enabledLayerGroups(
                            *(o["enabledLayerGroups"] as ArrayList<*>)
                                    .map { layerGroup -> layerGroup as String }
                                    .toTypedArray()
                    )
                    options.disabledLayerGroups(
                            *(o["disabledLayerGroups"] as ArrayList<*>)
                                    .map { layerGroup -> layerGroup as String }
                                    .toTypedArray()
                    )
                    options.liteModeEnabled(o["liteModeEnabled"] as Boolean)
                    options.nightModeEnabled(o["nightModeEnabled"] as Boolean)
                    options.indoorEnabled(o["indoorEnabled"] as Boolean)
                    options.indoorFocusRadius(o["indoorFocusRadius"] as Int)
                    if (o["backgroundColor"] is Long) {
                        options.backgroundColor((o["backgroundColor"] as Long).toInt())
                    } else {
                        options.backgroundColor(o["backgroundColor"] as Int)
                    }
                    options.pickTolerance(o["pickTolerance"] as Int)
                    options.scrollGesturesEnabled(o["scrollGesturesEnabled"] as Boolean)
                    options.zoomGesturesEnabled(o["zoomGesturesEnabled"] as Boolean)
                    options.tiltGesturesEnabled(o["tiltGesturesEnabled"] as Boolean)
                    options.rotateGesturesEnabled(o["rotateGesturesEnabled"] as Boolean)
                    options.stopGesturesEnabled(o["stopGesturesEnabled"] as Boolean)
                    options.compassEnabled(o["compassEnabled"] as Boolean)
                    options.scaleBarEnabled(o["scaleBarEnabled"] as Boolean)
                    options.zoomControlEnabled(o["zoomControlEnabled"] as Boolean)
                    options.indoorLevelPickerEnabled(o["indoorLevelPickerEnabled"] as Boolean)
                    options.locationButtonEnabled(o["locationButtonEnabled"] as Boolean)
                    options.logoClickEnabled(o["logoClickEnabled"] as Boolean)
                    options.logoGravity(o["logoGravity"] as Int)
                    options.logoMargin(logoMargin[0], logoMargin[1], logoMargin[2], logoMargin[3])
                    options.fpsLimit(o["fpsLimit"] as Int)
                    options.useTextureView(o["useTextureView"] as Boolean)
                    options.translucentTextureSurface(o["translucentTextureSurface"] as Boolean)
                    options.zOrderMediaOverlay(o["zOrderMediaOverlay"] as Boolean)
                    options.preserveEGLContextOnPause(o["preserveEGLContextOnPause"] as Boolean)
                    options.buildingHeight((o["buildingHeight"] as Double).toFloat())
                    options.lightness((o["lightness"] as Double).toFloat())
                    options.symbolScale((o["symbolScale"] as Double).toFloat())
                    options.symbolPerspectiveRatio((o["symbolPerspectiveRatio"] as Double).toFloat())
                    options.scrollGesturesFriction((o["scrollGesturesFriction"] as Double).toFloat())
                    options.zoomGesturesFriction((o["zoomGesturesFriction"] as Double).toFloat())
                    options.rotateGesturesFriction((o["rotateGesturesFriction"] as Double).toFloat())
                    options.camera(interpretCameraPosition(o["cameraPosition"] as Map<*, *>))
                }

        private fun interpretLocale(locale: String): Locale {
            val localeSegments = locale.split('-')

            return when (localeSegments.size) {
                1 -> Locale(localeSegments[0])
                2 -> Locale(localeSegments[0], localeSegments[1])
                else -> Locale(localeSegments[0], localeSegments[2], localeSegments[1])
            }
        }

        private fun interpretContentPadding(o: List<*>, density: Float): IntArray = intArrayOf(
                (o[0] as Double * density).roundToInt(),
                (o[1] as Double * density).roundToInt(),
                (o[2] as Double * density).roundToInt(),
                (o[3] as Double * density).roundToInt()
        )

        private fun interpretPointF(o: List<*>): PointF = PointF(
                (o[0] as Double).toFloat(),
                (o[1] as Double).toFloat()
        )

        private fun interpretCameraUpdate(update: CameraUpdate, o: Map<*, *>, methodChannel: MethodChannel): CameraUpdate = update.apply {
            cancelCallback { methodChannel.invokeMethod("cameraUpdate#onCancel", null) }
            finishCallback { methodChannel.invokeMethod("cameraUpdate#onFinish", null) }
            pivot(interpretPointF(o["pivot"] as List<*>))
            reason(o["reason"] as Int)
            animate(CameraAnimation.values()[o["animation"] as Int], (o["duration"] as Number).toLong())
        }
    }
}