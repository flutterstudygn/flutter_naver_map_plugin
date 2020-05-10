package rooftop.flutter_naver_map_plugin

import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.NaverMap
import com.naver.maps.map.NaverMapOptions
import java.util.*
import kotlin.math.roundToInt


/**
 * Created by Sugyo-In on 2020-05-09.
 */
class Convert {
    companion object {
        fun interpretLatLng(o: Map<*, *>): LatLng = LatLng(
                o["latitude"] as Double,
                o["longitude"] as Double
        )

        fun interpretLatLngBounds(o: Map<*, *>): LatLngBounds = LatLngBounds(
                interpretLatLng(o["southwest"] as Map<*, *>),
                interpretLatLng(o["northeast"] as Map<*, *>)
        )

        fun interpretCameraPosition(o: Map<*, *>): CameraPosition = CameraPosition(
                interpretLatLng(o["target"] as Map<*, *>),
                o["zoom"] as Double,
                o["tilt"] as Double,
                o["bearing"] as Double
        )

        fun interpretNaverMapOptions(o: Map<*, *>, density: Float): NaverMapOptions =
                NaverMapOptions().also { options ->
                    val contentPadding = toContentPadding(o["contentPadding"] as Map<*, *>, density)
                    val logoMargin = toContentPadding(o["logoMargin"] as Map<*, *>, density)

                    options.locale(toLocale(o["locale"] as String))
                    o["extent"]?.let { options.extent(interpretLatLngBounds(it as Map<*, *>)) }
                    options.minZoom(o["minZoom"] as Double)
                    options.maxZoom(o["maxZoom"] as Double)
                    options.contentPadding(
                            contentPadding.getValue("left"),
                            contentPadding.getValue("top"),
                            contentPadding.getValue("right"),
                            contentPadding.getValue("bottom")
                    )
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
                    // o["backgroundResource"] todo Flutter단에서 구현 되면 작업.
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
                    options.logoMargin(
                            logoMargin.getValue("left"),
                            logoMargin.getValue("top"),
                            logoMargin.getValue("right"),
                            logoMargin.getValue("bottom")
                    )
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
                    options.camera(interpretCameraPosition(o["camera"] as Map<*, *>))
                }

        private fun toLocale(locale: String): Locale {
            val localeSegments = locale.split('-')

            return when (localeSegments.size) {
                1 -> Locale(localeSegments[0])
                2 -> Locale(localeSegments[0], localeSegments[1])
                else -> Locale(localeSegments[0], localeSegments[2], localeSegments[1])
            }
        }

        private fun toContentPadding(o: Map<*, *>, density: Float): Map<String, Int> = mapOf(
                "left" to (o["left"] as Double * density).roundToInt(),
                "top" to (o["top"] as Double * density).roundToInt(),
                "right" to (o["right"] as Double * density).roundToInt(),
                "bottom" to (o["bottom"] as Double * density).roundToInt()
        )
    }
}