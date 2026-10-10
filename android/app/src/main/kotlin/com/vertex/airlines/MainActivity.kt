package com.vertex.airlines

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        MethodChannel(engine.dartExecutor.binaryMessenger, "com.vertex.airlines/sims")
            .setMethodCallHandler { call, result ->
                if (call.method == "detectInstalled") {
                    val targets = call.argument<List<String>>("packages") ?: emptyList<String>()
                    val installed = targets.filter { pkg ->
                        try {
                            packageManager.getLaunchIntentForPackage(pkg) != null
                        } catch (e: Exception) {
                            false
                        }
                    }
                    result.success(installed)
                } else {
                    result.notImplemented()
                }
            }
    }
}