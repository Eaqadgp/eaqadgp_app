package com.example.eaqad_app

import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.unity3d.player.UnityPlayerActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity(){
    fun moveTo(){
        //startActivity(Intent(MainActivity@this, UnityPlayerActivity::class.java))
       startActivity(Intent(MainActivity@this, UnityApp::class.java))
       //startActivity(Intent(MainActivity@this, UnityTest::class.java))
       //startActivity(Intent(MainActivity@this, TestActivity::class.java))
    }

    private  val CHANNEL = "your_channel_name"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine)
            //configureChannels(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result ->
                if (call.method == "nativeMethod") {
                    moveTo()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
}


}
