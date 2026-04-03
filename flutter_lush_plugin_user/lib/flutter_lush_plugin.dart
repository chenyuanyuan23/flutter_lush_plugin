import 'dart:async';

// import 'package:flutter/services.dart';

class FlutterLushPlugin {
  // static const MethodChannel _channel =
  //     const MethodChannel('flutter_lush_plugin');

  // static Future<String> get platformVersion async {
  //   final String version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }

  //初始化接口
  static Future initLush() async {
    // dynamic args;
    // int result = -1;
    // try {
    //   await _channel.invokeMethod('initLush', args);
    // } on PlatformException catch (e) {
    //   print(e);
    // }
    // return result;
  }

  static Future initBluetooth() async {
    // dynamic args;
    // int result = -1;
    // try {
    //   await _channel.invokeMethod('initBluetooth', args);
    // } on PlatformException catch (e) {
    //   print(e);
    // }
    // return result;
  }

  static void initCallBack(
    void Function(dynamic)? callBackDeviceList,
    void Function(dynamic)? callConnectedOk,
    void Function(dynamic)? callConnectedFail,
    void Function(dynamic)? callNotConnected, {
    void Function(dynamic)? batteryUpdate,
  }) {
    // _channel.setMethodCallHandler((MethodCall call) {
    //   switch (call.method) {
    //     case "updateDeviceList":
    //     case "deviceList":
    //       // 当收到设备列表时的处理
    //       print('返回对应的设备列表');
    //       if (callBackDeviceList != null) callBackDeviceList!(call.arguments);
    //       break;
    //     case "connectedOk":
    //       // 当设备连接成功时的处理
    //       if (callConnectedOk != null) callConnectedOk!(call.arguments);
    //       break;
    //     case "connectedFail":
    //       // 当设备连接失败时的处理
    //       if (callConnectedFail != null) callConnectedFail!(call.arguments);
    //       break;
    //     case "notConnected":
    //       // 当设备未连接时的处理
    //       if (callNotConnected != null) callNotConnected!(call.arguments);
    //       break;
    //     case "batteryVal":
    //       // 当收到电池电量更新时的处理
    //       if (batteryUpdate != null) batteryUpdate!(call.arguments);
    //       break;
    //     case "toyMsg":
    //       // 当收到玩具错误消息时的处理
    //       print('toy err========${call.arguments}');
    //       break;
    //     default:
    //       break;
    //   }
    //   throw MissingPluginException(
    //     '${call.method} was invoked but has no handler',
    //   );
    // });
  }

  //震动控制
  static Future vibrate(int intensity) async {
    // try {
    //   await _channel.invokeMethod('vibrate', {"intensity": intensity});
    // } on PlatformException catch (e) {
    //   print(e);
    // }
  }

  static Future searchDevice() async {
    // try {
    //   await _channel.invokeMethod('searchDevice');
    // } on PlatformException catch (e) {
    //   print(e);
    // }
  }

  //模式控制
  static Future preset(int intensity) async {
    // try {
    //   await _channel.invokeMethod('Preset', {"intensity": intensity});
    // } on PlatformException catch (e) {
    //   print(e);
    // }
  }

  //开始连接设备
  static Future connectToy(String info) async {
    // try {
    //   await _channel.invokeMethod('connectToy', {"info": info});
    // } on PlatformException catch (e) {
    //   print(e);
    // }
  }

  static Future disConnectToy(String info) async {
    // try {
    //   await _channel.invokeMethod('disConnectToy', {"info": info});
    // } on PlatformException catch (e) {
    //   print(e);
    // }
  }

  //获取电池状态
  static Future getBattery() async {
    // try {
    //   final int batteryLevel = await _channel.invokeMethod('getBattery');
    //   return batteryLevel;
    // } on PlatformException catch (e) {
    //   print("Error: ${e.message}");
    //   return -1;
    // }
  }

  //获取设备信息
  static Future getDeviceType() async {
    // try {
    //   final String deviceType = await _channel.invokeMethod('getDeviceType');
    //   return deviceType;
    // } on PlatformException catch (e) {
    //   print("Error: ${e.message}");
    //   return 'Unknown';
    // }
  }

  //灯光控制
  static Future setLight(bool isOn) async {
    // try {
    //   await _channel.invokeMethod('setLight', {"isOn": isOn});
    // } on PlatformException catch (e) {
    //   print("Error: ${e.message}");
    // }
  }
}
