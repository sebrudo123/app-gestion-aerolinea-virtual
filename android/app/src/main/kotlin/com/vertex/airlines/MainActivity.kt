package com.vertex.airlines

import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {
    private val simsChannel = "com.vertex.airlines/sims"
    private val downloadsChannel = "com.vertex.airlines/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, simsChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "detectInstalled") {
                    val packages = call.argument<List<String>>("packages") ?: emptyList()
                    val installed = packages.filter { pkg ->
                        try {
                            packageManager.getPackageInfo(pkg, 0)
                            true
                        } catch (e: Exception) {
                            false
                        }
                    }
                    result.success(installed)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, downloadsChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveToDownloads") {
                    val path = call.argument<String>("path")
                    val fileName = call.argument<String>("fileName") ?: "SkyConnect.apk"
                    val subfolder = call.argument<String>("subfolder") ?: "SkyConnect"
                    try {
                        result.success(saveToDownloads(path, fileName, subfolder))
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                } else if (call.method == "installApk") {
                    val path = call.argument<String>("path")
                    try {
                        result.success(installApk(path))
                    } catch (e: Exception) {
                        result.error("INSTALL_FAILED", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun installApk(path: String?): Boolean {
        val file = File(path ?: throw Exception("Ruta no válida"))
        if (!file.exists()) throw Exception("El archivo no existe")

        val uri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            FileProvider.getUriForFile(this, "$packageName.provider", file)
        } else {
            Uri.fromFile(file)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            !packageManager.canRequestPackageInstalls()
        ) {
            val settings = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                data = Uri.parse("package:$packageName")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(settings)
            return false
        }

        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
        return true
    }

    private fun saveToDownloads(path: String?, fileName: String, subfolder: String): String {
        val source = File(path ?: throw Exception("Ruta no válida"))
        if (!source.exists()) throw Exception("El archivo no existe")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = contentResolver
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "application/vnd.android.package-archive")
                put(MediaStore.Downloads.RELATIVE_PATH,
                    Environment.DIRECTORY_DOWNLOADS + "/" + subfolder)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            val uri = resolver.insert(collection, values)
                ?: throw Exception("No se pudo crear el archivo en Descargas")
            resolver.openOutputStream(uri)?.use { output ->
                FileInputStream(source).use { input ->
                    input.copyTo(output)
                }
            } ?: throw Exception("No se pudo escribir en Descargas")
            val done = ContentValues().apply { put(MediaStore.Downloads.IS_PENDING, 0) }
            resolver.update(uri, done, null, null)
            return uri.toString()
        } else {
            @Suppress("DEPRECATION")
            val dir = File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                subfolder
            )
            if (!dir.exists()) dir.mkdirs()
            val dest = File(dir, fileName)
            FileInputStream(source).use { input ->
                dest.outputStream().use { output ->
                    input.copyTo(output)
                }
            }
            return dest.absolutePath
        }
    }
}
