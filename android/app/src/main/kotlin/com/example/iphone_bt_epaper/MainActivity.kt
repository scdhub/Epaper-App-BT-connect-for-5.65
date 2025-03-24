package com.example.iphone_bt_epaper

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.hch.epaper.ble_sdk.api.DefaultSDKFactory
import com.hch.epaper.ble_sdk.api.EInkSDK
import com.hch.epaper.ble_sdk.api.SDKError
import com.hch.epaper.ble_sdk.api.SDKOperationDelegate
import com.hch.epaper.ble_sdk.api.SDKFactory
import io.flutter.plugin.common.BasicMessageChannel // callback.message 送信用
import io.flutter.plugin.common.StringCodec
import android.os.Handler
import android.os.Looper
import org.json.JSONObject
//import org.json.JSONArray

import android.util.Log // Log出力用

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.iphone_bt_epaper/channel"
    var sdk: EInkSDK? = null
    var deviceName: String? = null
    var imageUrl: String? = null
    var output: String? = null    // FlutterへのBL接続状況返却
    var json = JSONObject()
    var data: MutableMap<String, Any?> = mutableMapOf(
            "callbackName" to "",
            "message" to "",
            "progressPercent" to 0)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val messageChannel = flutterEngine?.dartExecutor?.binaryMessenger?.let {
            BasicMessageChannel(it, CHANNEL, StringCodec.INSTANCE)
        } ?: throw IllegalStateException("flutterEngine or binaryMessenger is null")


        fun sendMessageToFlutter(channel: BasicMessageChannel<String>) {
            Handler(Looper.getMainLooper()).postDelayed({
                json = JSONObject(data)
                channel.send(json.toString())
            }, 500) // 0.5秒ごとに送信
        }

//        fun updateValues(values: Map<String, Any?>) {
//            for ((key, newValue) in values) {
//                // 値の型を確認し、適切に処理
//                if (data.containsKey(key)) {
//                    when (newValue) {
//                        is String -> data[key] = newValue // String型
//                        is String? -> data[key] = newValue // String?型
//                        is Int? -> data[key] = newValue // Int?型
//                        else -> println("無効な型です: $key")
//                    }
//                } else {
//                    println("指定されたキーは存在しません: $key")
//                }
//            }
//        }

        fun updateValues(callbackName: String, message: String?, progressPercent: Int?) {
            data["callbackName"] = callbackName
            data["message"] = message
            data["progressPercent"] = progressPercent
        }

        // デリゲートの実装
        val delegate: SDKOperationDelegate = object : SDKOperationDelegate {
            override fun onSetupSDKStart() {
                // SDK初期化開始時の通知　optinal
                Log.d("MainActivity", "onSetupSDKStart")
//                updateValues("onSetupSDKStart", "Start", null)
//                sendMessageToFlutter(messageChannel)
            }
            override fun onSetupSDKComplete() {
                // セットアップ完了時の処理
                Log.d("MainActivity", "onSetupSDKComplete")
                // Flutter側へメッセージ送信
//                output = "onSetupSDKComplete"
                updateValues("onSetupSDKComplete", "Complete", null)
                sendMessageToFlutter(messageChannel)
                // BL接続
                Log.d("MainActivity", "call connectBleDevice")
                sdk?.connectBleDevice(deviceName!!)
            }
            override fun onSetupSDKFailed(error: SDKError?) {
                // セットアップ失敗時の処理
                Log.d("MainActivity", "onSetupSDKFailed: ${error?.message}")
                // Flutter側へメッセージ送信
//                output = "onSetupSDKFailed: ${error?.message}"
//                output = "Failed"
//                data["callbackName"] = "onSetupSDKFailed"
//                data["message"] = error?.message
                updateValues("onSetupSDKFailed", error?.message, null)
                sendMessageToFlutter(messageChannel)
            }
            // その他必要なコールバックの実装
            override fun onBLEDeviceCancelFailed(error: SDKError?) {
                Log.d("MainActivity", "onBLEDeviceCancelFailed: ${error?.message}")
                updateValues("onBLEDeviceCancelFailed", error?.message, null)
                sendMessageToFlutter(messageChannel)
            }
            //            override fun onBLEDeviceConnectStart() {
//                // BL接続開始時の通知　optional
//            }
            override fun onBLEDeviceConnectCanceled() {
                // BL接続キャンセル時の処理
                Log.d("MainActivity", "onBLEDeviceConnectCanceled")
                // Flutter側へメッセージ送信
//                output = "onBLEDeviceConnectCanceled"
                updateValues("onBLEDeviceConnectCanceled", "DeviceConnectCanceled", null)
                sendMessageToFlutter(messageChannel)
//                // BL接続切断
//                Log.d("MainActivity", "call cancelConnection")
//                sdk?.cancelConnection()
            }
            override fun onBLEDeviceConnectComplete() {
                // BL接続成功時の処理
                Log.d("MainActivity", "onBLEDeviceConnectComplete")
                // Flutter側へメッセージ送信
//                output = "onBLEDeviceConnectComplete"
                updateValues("onBLEDeviceConnectComplete", "Complete", null)
                sendMessageToFlutter(messageChannel)
                // 画像送信
                Log.d("MainActivity", "call sendImageToDevice")
                sdk?.sendImageToDevice("3000K-5.65", imageUrl!!)
            }
            override fun onBLEDeviceConnectFailed(error: SDKError?) {
                // BL接続失敗時の処理
                Log.d("MainActivity", "onBLEDeviceConnectFailed: ${error?.message}")
                // Flutter側へメッセージ送信
//                output = "onBLEDeviceConnectFailed: ${error?.message}"
//                output = "Failed"
                updateValues("onBLEDeviceConnectFailed", error?.message, null)
                sendMessageToFlutter(messageChannel)
            }

            override fun onBLEDeviceDisconnect() {
                // BL切断成功時の処理
                Log.d("MainActivity", "onBLEDeviceDisconnect")
                // Flutter側へメッセージ送信
//                output = "onBLEDeviceDisconnect"
                updateValues("onBLEDeviceDisconnect", "DeviceDisconnect", null)
                sendMessageToFlutter(messageChannel)
            }

            override fun onSendImageToDeviceStart() {
                // 画像送信開始時通知　optional
                Log.d("MainActivity", "onSendImageToDeviceStart")
                updateValues("onSendImageToDeviceStart", "Start", null)
                sendMessageToFlutter(messageChannel)
            }
            override fun onSendImageToDeviceComplete() {
                // 画像送信成功時の処理
                Log.d("MainActivity", "onSendImageToDeviceComplete")
                // Flutter側へメッセージ送信
//                output = "onSendImageToDeviceComplete"
                updateValues("onSendImageToDeviceComplete", "Complete", null)
                sendMessageToFlutter(messageChannel)
                // BL接続切断
                Log.d("MainActivity", "call cancelConnection")
                sdk?.cancelConnection()
            }
            override fun onSendImageToDeviceFailed(error: SDKError?) {
                // 画像送信失敗時の処理
                Log.d("MainActivity", "onSendImageToDeviceFailed: ${error?.message}")
                // Flutter側へメッセージ送信
//                output = "onSendImageToDeviceFailed: ${error?.message}"
//                output = "Failed"
                updateValues("onSendImageToDeviceFailed", error?.message, null)
                sendMessageToFlutter(messageChannel)
                // BL接続切断
                Log.d("MainActivity", "call cancelConnection")
                sdk?.cancelConnection()
            }
            // 呼び出しタイミング：不明　仕様書記載なし
            override fun onSendImageToDeviceCanceled() {
                Log.d("MainActivity", "onSendImageToDeviceCanceled")
                // Flutter側へメッセージ送信
//                output = "onSendImageToDeviceCanceled"
                updateValues("onSendImageToDeviceCanceled", "DeviceCanceled", null)
                sendMessageToFlutter(messageChannel)
                // BL接続切断
                Log.d("MainActivity", "call cancelConnection")
                sdk?.cancelConnection()
            }
            override fun onSendImageToDeviceProgress(progressPercent: Int) {
                // 画像送信進捗通知　optional
                Log.d("MainActivity", "onSendImageToDeviceProgress: ${progressPercent}")
                // Flutter側へメッセージ送信
//                output = "onSendImageToDeviceProgress: ${progressPercent.toString()}"
//                output = progressPercent.toString()
                updateValues("onSendImageToDeviceProgress", "SendImage", progressPercent)
                sendMessageToFlutter(messageChannel)
            }
        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "callSdk") {

                Log.d("MainActivity", "SDK instance: $sdk")
                if (sdk == null) {
                    // SDKファクトリーのインスタンスを取得
                    val factory = DefaultSDKFactory.instance
                    Log.d("MainActivity", "factory: $factory")

                    // SDKインスタンスを作成
                    Log.d("MainActivity", "call createSDK")
                    sdk = factory.createSDK()
                    Log.d("MainActivity", "createSDK: $sdk")
                }
                // SDKの初期化
                Log.d("MainActivity", "call setupSDK")
                val res = sdk?.setupSDK(context, delegate)
                Log.d("MainActivity", "setupSDK: $res")
                // デバイス名取得
                deviceName = call.argument<String>("deviceName")
                imageUrl = call.argument<String>("imageUrl")

                result.success(output)
            } else {
                result.notImplemented()
            }
        }
    }
}
