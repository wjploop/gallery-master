package io.carrot.my_plugin

import android.app.Activity
import android.app.WallpaperManager
import android.content.Context
import android.content.Intent
import android.content.res.Resources
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import android.view.RoundedCorner
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.core.content.FileProvider

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/** MyPlugin */
class MyPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    val TAG = MyPlugin::class.java.simpleName

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
            "screenInfo" -> result.success(mapOf("connerRadius" to cornerRadius))
            "insertPictureToSystemGallery" -> {
                val argus = call.arguments as Map<String, String>
                Log.d(TAG, "start insert pic $argus")
                try {
                    MediaStore.Images.Media.insertImage(
                        activity.contentResolver,
                        argus["path"],
                        argus["name"],
                        argus["desc"]
                    )
                    result.success(true)
                    Log.d(TAG, "success insert pic ")
                } catch (e: Resources.NotFoundException) {
                    result.success(false)
                    Log.d(TAG, "failed insert pic")
                }
            }
            "openGallery" -> {
                activity.startActivity(
                    Intent(
                        Intent.ACTION_VIEW,
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    ).apply {
                    })
            }
            "setWallpaper" -> {
                val argus = call.arguments as Map<String, Any>
                val path = argus["path"] as String
                val type = argus["type"] as Int
                result.success(
                    when (type) {
                        0 -> setWallpaperForLockAndSystem(path)
                        1 -> setWallpaper(path, type)
                        2 -> setWallpaper(path, type)
                        else -> throw NotImplementedError("set wallpaper type is not allow: $type")
                    }
                )
            }
            "share" -> {
                val argus = call.arguments as Map<String, Any>
                val path = argus["path"] as String
                share(path)
            }
            else -> result.notImplemented()
        }
    }

    lateinit var activity: Activity

    lateinit var wallpaperManager: WallpaperManager

    var cornerRadius = 0;

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "on attach activity")
        activity = binding.activity
        val wm = activity.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = wm.defaultDisplay
        if (Build.VERSION.SDK_INT >= 31) {
            val cornerTopLeft = wm.defaultDisplay.getRoundedCorner(RoundedCorner.POSITION_TOP_LEFT)
            cornerRadius = cornerTopLeft?.radius ?: 0
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // 委屈使用这个作为conner
            cornerRadius = (display?.let {
                it.cutout?.safeInsetTop?.let {
                    it / 2.0
                } ?: 0
            } ?: 0).toInt()
        }
        wallpaperManager = WallpaperManager.getInstance(activity)
    }


    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setWallpaper(path: String, flag: Int): Boolean {
        try {
            val destPath =
                activity.filesDir.path + File.separator + "wallpaper_" + flag + path.split(".")
                    .last()
            val dest = File(destPath)
            File(path).copyTo(dest, true)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val res = wallpaperManager.setStream(dest.inputStream(), null, false, flag)
                return res > 0
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
        return false
    }

    private fun setWallpaperForLockAndSystem(path: String): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            return false
        }
        val lock = setWallpaper(path, WallpaperManager.FLAG_LOCK)
        val system = setWallpaper(path, WallpaperManager.FLAG_SYSTEM)
        return lock && system
    }

    private fun share(path: String) {
        Log.d(TAG, "start share $path")
        Intent(Intent.ACTION_SEND).apply {
            type = "image/*"
            putExtra(Intent.EXTRA_STREAM, FileProvider.getUriForFile(activity,activity.packageName,File(path)))
            activity.startActivity(this)
            Log.d(TAG, "share")
        }
    }
}
