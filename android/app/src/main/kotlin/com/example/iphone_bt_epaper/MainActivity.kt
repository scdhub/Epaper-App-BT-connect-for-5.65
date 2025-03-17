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

import android.util.Log // Log出力用

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.iphone_bt_epaper/channel"
    var sdk: EInkSDK? = null
    var deviceName: String? = null
    var imageUrl: String? = null
    var output: String? = ""    // FlutterへのBL接続状況返却

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // デリゲートの実装
        val delegate: SDKOperationDelegate = object : SDKOperationDelegate {
            override fun onSetupSDKStart() {
                // SDK初期化開始時の通知　optinal
                Log.d("MainActivity", "onSetupSDKStart")
            }
            override fun onSetupSDKComplete() {
                // セットアップ完了時の処理
                Log.d("MainActivity", "onSetupSDKComplete")
            }
            override fun onSetupSDKFailed(error: SDKError?) {
                // セットアップ失敗時の処理
                Log.d("MainActivity", "onSetupSDKFailed: ${error?.message}")
            }
            // その他必要なコールバックの実装
            override fun onBLEDeviceCancelFailed(error: SDKError?) {
                Log.d("MainActivity", "onBLEDeviceCancelFailed: ${error?.message}")
            }
            //            override fun onBLEDeviceConnectStart() {
//                // BL接続開始時の通知　optional
//            }
            override fun onBLEDeviceConnectCanceled() {
                // BL接続キャンセル時の処理
                Log.d("MainActivity", "onBLEDeviceConnectCanceled")
            }
            override fun onBLEDeviceConnectComplete() {
                // BL接続成功時の処理
                Log.d("MainActivity", "onBLEDeviceConnectComplete")
                sdk?.sendImageToDevice("3000K-5.65", imageUrl!!)
            }
            override fun onBLEDeviceConnectFailed(error: SDKError?) {
                // BL接続失敗時の処理
                Log.d("MainActivity", "onBLEDeviceConnectFailed: ${error?.message}")
            }
            override fun onBLEDeviceDisconnect() {
                // BL切断成功時の処理
                Log.d("MainActivity", "onBLEDeviceDisconnect")
            }
            override fun onSendImageToDeviceStart() {
                // 画像送信開始時通知　optional
                Log.d("MainActivity", "onSendImageToDeviceStart")
            }
            override fun onSendImageToDeviceComplete() {
                // 画像送信成功時の処理
                Log.d("MainActivity", "onSendImageToDeviceComplete")
                sdk?.cancelConnection()
            }
            override fun onSendImageToDeviceFailed(error: SDKError?) {
                // 画像送信失敗時の処理
                Log.d("MainActivity", "onSendImageToDeviceFailed: ${error?.message}")
            }
            override fun onSendImageToDeviceCanceled() {
                Log.d("MainActivity", "onSendImageToDeviceCanceled")
            }
            override fun onSendImageToDeviceProgress(progressPercent: Int) {
                // 画像送信進捗通知　optional
                Log.d("MainActivity", "onSendImageToDeviceProgress: ${progressPercent}")
            }
        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "callSdk") {
                // SDKファクトリーのインスタンスを取得
                val factory = DefaultSDKFactory.instance
                Log.d("MainActivity", "factory: $factory")
                // SDKインスタンスを作成
                sdk = factory.createSDK()
                Log.d("MainActivity", "sdk: $sdk")
                // SDKの初期化
                val res = sdk?.setupSDK(context, delegate)
                Log.d("MainActivity", "setupSDK: $res")
                // デバイス名取得
                deviceName = call.argument<String>("deviceName")
                imageUrl = call.argument<String>("imageUrl")
                // BL接続
                sdk?.connectBleDevice(deviceName!!)

                result.success(output)
            } else {
                result.notImplemented()
            }
        }
    }
}
