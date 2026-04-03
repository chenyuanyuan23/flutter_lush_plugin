package com.example.flutter_lush_plugin;

import static com.lovense.sdklibrary.LovenseToy.COMMAND_GET_BATTERY;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import android.app.Application;
import com.lovense.sdklibrary.Lovense;
import com.lovense.sdklibrary.LovenseToy;
import com.lovense.sdklibrary.callBack.LovenseError;
import com.lovense.sdklibrary.callBack.OnCallBackBatteryListener;
import com.lovense.sdklibrary.callBack.OnCommandErrorListener;
import com.lovense.sdklibrary.callBack.OnCommandSuccessListener;
import com.lovense.sdklibrary.callBack.OnConnectListener;
import com.lovense.sdklibrary.callBack.OnSendCommandErrorListener;
import com.lovense.sdklibrary.callBack.OnSearchToyListener;
import com.lovense.sdklibrary.callBack.OnErrorListener;
import android.content.Context;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

/** FlutterLushPlugin */
public class FlutterLushPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel _channel;
  private Context appContext;
  private Application application;
  private List<LovenseToy> allToyModelArr = new ArrayList<>();
  private OnConnectListener onConnectListener;
  private LovenseToy _curToy;

private Timer timer;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
      _channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_lush_plugin");
    appContext = flutterPluginBinding.getApplicationContext();
    application = (Application) appContext.getApplicationContext();

      _channel.setMethodCallHandler(this);
      String token = "NDI22IkSIp0sf2vBaVN80d6mJEUalgDkzofKEqnZwamGQay6cbO909-UEKGkmkJF"; // Replace with your token
      if (token.isEmpty()) {
          System.out.println("Please input your token!");
      } else {
          Lovense.getInstance(application).setDeveloperToken(token);
      }
  }

    public void start() {
        if (timer != null) {
            timer.cancel();
            timer.purge(); // 清除已取消的任务
        }
        timer = new Timer();
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                if(_curToy != null && Lovense.getInstance(application).isConnected(_curToy.getToyId())){
                    Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_GET_DEVICE_TYPE);
                    Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_GET_BATTERY);
                }
            }
        }, 0, 30000); // 每 30 秒执行一次
    }

    public void stop() {
        if (timer != null) {
            timer.cancel();
        }
    }


//  public static void registerWith(Registrar registrar) {
//    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_lush_plugin");
//    channel.setMethodCallHandler(new FlutterLushPlugin());
//  }



  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      Log.e("call.method", call.method);
    switch (call.method) {
        case "initLush":
            initLush(call, result);
            break;
        case "connectToy":
            connectToy(call,result);
            break;
        case "vibrate":
            vibrate(call,result);
            break;
        case "Preset":
            preset(call,result);
            break;
        case "disConnectToy":
            disConnectToy(call,result);
            break;
        case "searchDevice":
            searchDevice();
            break;

    }
  }


    private void connectToy(MethodCall call, MethodChannel.Result result) {
        HashMap<String, Object> args = (HashMap<String, Object>) call.arguments;
        String str = (String) args.get("info");
        if(str != null && !str.isEmpty()){
            Lovense.getInstance(application).connectToy(str,onConnectListener);



            // 延时执行断开连接
            new Handler(Looper.getMainLooper()).postDelayed(() -> {
                Lovense.getInstance(application).sendCommand(str, LovenseToy.COMMAND_VIBRATE, 0);
                Lovense.getInstance(application).sendCommand(str, LovenseToy.COMMAND_PRESET, 0);
            }, 1000); // 延时1秒，您可以根据需要调整这个值
        }
        if(_curToy == null && !allToyModelArr.isEmpty()){
            _curToy = allToyModelArr.get(0);
        }
    }

    private void vibrate(MethodCall call, MethodChannel.Result result) {
        HashMap<String, Object> args = (HashMap<String, Object>) call.arguments;
        int value = (Integer) args.get("intensity");
        if(_curToy != null){
            Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_VIBRATE, value);
        }
    }

    private void preset(MethodCall call, MethodChannel.Result result) {
        HashMap<String, Object> args = (HashMap<String, Object>) call.arguments;
        int value = (Integer) args.get("intensity");
        if(_curToy != null){
            Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_PRESET, value);
        }
    }



    private void disConnectToy(MethodCall call, MethodChannel.Result result) {
        HashMap<String, Object> args = (HashMap<String, Object>) call.arguments;
        String str = (String) args.get("info");
        if(str != null && !str.isEmpty()){
            stop();
            Lovense.getInstance(application).sendCommand(str, LovenseToy.COMMAND_VIBRATE, 0);
            Lovense.getInstance(application).sendCommand(str, LovenseToy.COMMAND_PRESET, 0);

            // 延时执行断开连接
            new Handler(Looper.getMainLooper()).postDelayed(() -> {
                Lovense.getInstance(application).disconnect(str);
            }, 1000); // 延时1秒，您可以根据需要调整这个值
        }
    }

    public Map<String, Object> dictionaryFromLovenseToy(LovenseToy toy) {
        Map<String, Object> toyMap = new HashMap<>();
        toyMap.put("name", toy.getDeviceName() != null ? toy.getDeviceName() : "");
        toyMap.put("identifier", toy.getToyId() != null ? toy.getToyId() : "");
        toyMap.put("toyType", toy.getType() != null ? toy.getType() : "");
        toyMap.put("version", toy.getVersion() != null ? toy.getVersion() : "");
        toyMap.put("macAddress", toy.getMacAddress() != null ? toy.getMacAddress() : "");
        toyMap.put("rssi", toy.getRssi());
        toyMap.put("battery", toy.getBattery());
        toyMap.put("isConnected", Lovense.getInstance(application).isConnected(toy.getToyId()));
        return toyMap;
    }

    public List<Map<String, Object>> convertLovenseToysToDictionaries(List<LovenseToy> toys) {
        List<Map<String, Object>> toysArray = new ArrayList<>();
        for (LovenseToy toy : toys) {
            if(toy != null){
                Map<String, Object> toyDict = dictionaryFromLovenseToy(toy);
                toysArray.add(toyDict);
            }
        }
        return toysArray;
    }

    private void initLush(MethodCall call, MethodChannel.Result result) {
      if(allToyModelArr.isEmpty()){
          allToyModelArr = Lovense.getInstance(application).listToys(new OnErrorListener() {
              @Override
              public void onError(LovenseError error) {

              }
          });
          new Handler(Looper.getMainLooper()).post(() -> {
              // 示例方法调用，根据你的需求进行调整
              _channel.invokeMethod("updateDeviceList", convertLovenseToysToDictionaries(allToyModelArr));
          });
      }

        searchDevice();


        onConnectListener = new OnConnectListener() {

            @Override
            public void onConnect(String toyId, String status) {
                switch (status) {
                    case LovenseToy.STATE_CONNECTING:
                        // 玩具正在连接，此处可添加相关处理逻辑
                        break;

                    case LovenseToy.STATE_CONNECTED:
                        // 玩具已连接
                        start(); // 开始定时任务
                        // 在主线程中调用 Flutter 方法传递连接成功的信息
                        new Handler(Looper.getMainLooper()).post(() -> {
                            _channel.invokeMethod("connectedOk", convertLovenseToysToDictionaries(allToyModelArr));
                        });
                        // 发送获取设备类型和电池状态的命令
                        Lovense.getInstance(application).sendCommand(toyId, LovenseToy.COMMAND_GET_DEVICE_TYPE);
                        Lovense.getInstance(application).sendCommand(toyId, COMMAND_GET_BATTERY);
                        // 添加电池状态更新的监听器
                        // Lovense.getInstance(application).addListener(toyId, (OnCallBackBatteryListener) (toyId1, battery) -> {
                        //     if(_curToy != null){
                        //         _curToy.setBattery(battery);
                        //     }
                        //     // 在主线程中调用 Flutter 方法传递电池状态信息
                        //     new Handler(Looper.getMainLooper()).post(() -> {
                        //         _channel.invokeMethod("batteryVal", convertLovenseToysToDictionaries(Arrays.asList(_curToy)));
                        //     });
                        // });
                        // 添加命令错误监听器
                        Lovense.getInstance(application).addListener(toyId, new OnCommandErrorListener() {
                            @Override
                            public void commandError(String msg) {
                                
                                new Handler(Looper.getMainLooper()).post(() -> {
                                    _channel.invokeMethod("toyMsg", msg);
                                });
                            }
                        });
                        // 添加发送命令错误监听器
                        Lovense.getInstance(application).addListener(toyId, new OnSendCommandErrorListener() {
                            @Override
                            public void sendCommandError(String toyId, LovenseError error) {
                                
                                new Handler(Looper.getMainLooper()).post(() -> {
                                    _channel.invokeMethod("toyMsg", error.getMessage() + toyId);
                                });
                            }
                        });
                        // 添加命令成功监听器
                        Lovense.getInstance(application).addListener(toyId, new OnCommandSuccessListener() {
                            @Override
                            public void commandSuccess(String msg) {
                                Log.e("test", "commandSuccess: " + msg);
                            }
                        });
                        break;

                    case LovenseToy.STATE_FAILED:
                        stop(); // 停止定时任务
                        // 玩具连接失败，此处可添加相关处理逻辑
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                _channel.invokeMethod("notConnected", convertLovenseToysToDictionaries(allToyModelArr));
                            }
                        });
                        break;

                    case LovenseToy.SERVICE_DISCOVERED:
                        // 服务被发现（通常意味着连接中断），停止定时器并更新 Flutter 端
                        // 发送获取设备类型和电池状态的命令
                        if(_curToy != null){
                            Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_GET_DEVICE_TYPE);
                            Lovense.getInstance(application).sendCommand(_curToy.getToyId(), LovenseToy.COMMAND_GET_BATTERY);
                        }
                        // 在主线程中调用 Flutter 方法传递未连接的信息
                        break;
                }
            }


            @Override
            public void onError(LovenseError error) {
                stop();
                try {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            // 调用Flutter方法并传递网络质量信息
                            _channel.invokeMethod("connectedFail", error.getMessage());
                        }
                    });

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        };



    result.success(0);
}

    private void searchDevice(){
        Lovense.getInstance(application).searchToys(new OnSearchToyListener() {
            @Override
            public void onSearchToy(LovenseToy lovenseToy) {
                try {
                    if(!isAdded(lovenseToy)) {
                        allToyModelArr.clear();
                        addUniqueToy(allToyModelArr, lovenseToy);
                        // 在主线程上调用 Flutter 方法更新设备列表
                        new Handler(Looper.getMainLooper()).post(() -> {
                            // 示例方法调用，根据你的需求进行调整
                            _channel.invokeMethod("updateDeviceList", convertLovenseToysToDictionaries(allToyModelArr));
                        });
                    }
                } catch (Exception e) {
                    Log.e("Error", "Exception occurred in onSearchToy: " + e.getMessage());
                }
            }

            @Override
            public void finishSearch() {
                try {
                    Lovense.getInstance(application).saveToys(allToyModelArr, new OnErrorListener() {
                        @Override
                        public void onError(LovenseError error) {
                            Log.e("LovenseError", "Error in saveToys: " + error.toString());
                        }
                    });
                    // 在主线程上调用 Flutter 方法更新设备列表
                    new Handler(Looper.getMainLooper()).post(() -> {
                        // 示例方法调用，根据你的需求进行调整
                        _channel.invokeMethod("updateDeviceList", convertLovenseToysToDictionaries(allToyModelArr));
                    });
                } catch (Exception e) {
                    Log.e("Error", "Exception occurred in finishSearch: " + e.getMessage());
                }
            }

            @Override
            public void onError(LovenseError msg) {
                Log.e("LovenseError", "Error in search: " + msg.toString());
            }
        });
    }

    protected boolean isAdded(LovenseToy lovenseToy) {
        for (LovenseToy t: allToyModelArr) {
            String  id = t.getToyId();
            String toyId = lovenseToy.getToyId();
            if (!TextUtils.isEmpty(id) && id.equals(toyId)) {
                return true;
            }
        }
        return false;
    }

    public void addUniqueToy(List<LovenseToy> allToyModelArr, LovenseToy lovenseToy) {
        boolean exists = false;
        for (LovenseToy toy : allToyModelArr) {
            if (toy.getToyId().equals(lovenseToy.getToyId())) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            allToyModelArr.add(lovenseToy);
            _curToy = lovenseToy;
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // 调用Flutter方法并传递网络质量信息
                    _channel.invokeMethod("deviceList", convertLovenseToysToDictionaries(allToyModelArr));
                }
            });
        }

    }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
      _channel.setMethodCallHandler(null);
  }
}
