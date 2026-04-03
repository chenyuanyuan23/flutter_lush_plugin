#import "FlutterLushPluginUser.h"
#import <Flutter/Flutter.h>

@implementation FlutterLushPluginUser {
    NSString* _token; // 用于存储token
    // FlutterMethodChannel* _methodChannel; // Flutter与原生代码通信的渠道
    // CBCentralManager* _centralManager; // 中央蓝牙管理器
    // BOOL _isBluetoothEnabled; // 蓝牙是否启用的标志
    // NSMutableArray<LovenseToy*>* _allToyModelArr; // 存储扫描到的玩具数组
    // LovenseToy* currentToy; // 当前操作的玩具
    // int batteryLevel;//当前设备的电量
}

// 注册插件方法
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_lush_plugin" binaryMessenger:[registrar messenger]];
    // FlutterLushPlugin* instance = [[FlutterLushPlugin alloc] initWithChannel:channel];
    // [registrar addMethodCallDelegate:instance channel:channel];
}

// 初始化方法
- (instancetype)initWithChannel:(FlutterMethodChannel*)channel {
    self = [super init];
    // if (self) {
    //     _methodChannel = channel;
    //     _isBluetoothEnabled = NO;
    //     _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    //     [self initNotification];
    // }
    return self;
}

// 初始化通知
- (void)initNotification {
    // [[NSNotificationCenter defaultCenter] removeObserver:self];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessCallback:) name:kToyScanSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessCallback:) name:kToyConnectSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFailCallback:) name:kToyConnectFailNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakCallback:) name:kToyConnectBreakNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCallbackNotificationBattery object:nil];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToySendCommandErrorNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCommandCallbackNotificationAtSuccess object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCommandCallbackNotificationAtError object:nil];
    
    
}

- (void)handleSendCommandError:(NSNotification *)notification {
    // 错误处理逻辑
    // NSLog(@"Send command error: %@", notification.userInfo);
    // [_methodChannel invokeMethod:@"toyMsg" arguments:notification.userInfo];
}

- (void)handleCommandSuccess:(NSNotification *)notification {
    // 成功执行命令的逻辑
    // NSLog(@"Command executed successfully");
}

- (void)handleCommandError:(NSNotification *)notification {
    // 命令执行错误的处理逻辑
    // NSLog(@"Error executing command: %@", notification.userInfo);
    // [_methodChannel invokeMethod:@"toyMsg" arguments:notification.userInfo];
}


// 扫描成功回调
- (void)scanSuccessCallback:(NSNotification*)noti {
    // NSDictionary* dict = [noti object];
    // NSArray* scanToyArr = [dict objectForKey:@"scanToyArray"];
    // _allToyModelArr = [scanToyArr mutableCopy];
    // [[Lovense shared] saveToys:_allToyModelArr];
    // NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:scanToyArr];

    // [_methodChannel invokeMethod:@"deviceList" arguments:flutterCompatibleArray];
}

// 蓝牙状态更新回调
// - (void)centralManagerDidUpdateState:(CBCentralManager*)central {
    // if (central.state == CBManagerStatePoweredOn) {
    //     _isBluetoothEnabled = YES;
    // } else {
    //     _isBluetoothEnabled = NO;
    // }
// }

// 处理Flutter调用的方法
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // if ([@"getPlatformVersion" isEqualToString:call.method]) {
    //     result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    // } else if ([call.method isEqualToString:@"initLush"]) {
    //     [self initEx:call result:result];
    // } else if ([call.method isEqualToString:@"vibrate"]) {
    //     [self handleSetVibrationCall:call result:result];
    // } else if ([call.method isEqualToString:@"Preset"]) {
    //     [self handleSetPresetCall:call result:result];
    // } else if ([call.method isEqualToString:@"connectToy"]) {
    //     [self handleSetConnectToyCall:call result:result];
    // } else if ([call.method isEqualToString:@"disConnectToy"]) {
    //     [self handleSetDisConnectToyCall:call result:result];
    // }
    //  else {
    //     result(FlutterMethodNotImplemented);
    // }
}

// 设置振动的方法
- (void)handleSetVibrationCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSDictionary* args = call.arguments;
    // NSUInteger value = [args[@"intensity"] unsignedIntegerValue];
    // NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    // [paramDict setObject:@(value) forKey:kSendCommandParamKey_VibrateLevel];
    // [[Lovense shared] sendCommandWithToyId:currentToy.identifier andCommandType:COMMAND_VIBRATE andParamDict:paramDict];
}

// 设置预设模式的方法
- (void)handleSetPresetCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSDictionary* args = call.arguments;
    // NSUInteger value = [args[@"intensity"] unsignedIntegerValue];
    // NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    // [paramDict setObject:@(value) forKey:kSendCommandParamKey_PresetLevel];
    // [[Lovense shared] sendCommandWithToyId:currentToy.identifier andCommandType:COMMAND_PRESET andParamDict:paramDict];
}

// 设置连接设备
- (void)handleSetConnectToyCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSDictionary* args = call.arguments;
    // NSString* str = args[@"info"];
    // if(str != nil && ![str isEqualToString:@""]){
    //     [[Lovense shared] connectToy:str];
    // }
}

// 设置断开连接设备
- (void)handleSetDisConnectToyCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSDictionary* args = call.arguments;
    // NSString* str = args[@"info"];
    // if(str != nil && ![str isEqualToString:@""]){
    //     [[Lovense shared] disconnectToy:str];
    // }
}

// 连接成功回调
- (void)connectSuccessCallback:(NSNotification*)noti {
    // NSDictionary* dict = [noti object];
    // LovenseToy* connectedToy = [dict objectForKey:@"toy"];
    // currentToy = connectedToy;
    // batteryLevel = connectedToy.battery;
    // for (LovenseToy* toy in _allToyModelArr) {
    //     if ([toy.identifier isEqualToString:connectedToy.identifier]) {
    //         [_allToyModelArr removeObject:toy];
    //         [_allToyModelArr addObject:connectedToy];
    //         break;
    //     }
    // }
    // NSLog(@"%@", connectedToy);
    // NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:_allToyModelArr];
    // [_methodChannel invokeMethod:@"connectedOk" arguments:flutterCompatibleArray];
    // [[Lovense shared] stopSearching];
    // // 在这里可以通知Flutter视图进行更新
}

// 电量更新回调
- (void)handleBatteryUpdate:(NSNotification *)notification {
    // NSDictionary* userInfo = notification.userInfo;
    // LovenseToy* connectedToy = userInfo[@"receiveToy"];
    // NSString *val = userInfo[@"battery"];
    // batteryLevel = [val intValue];
    
    // for (LovenseToy* toy in _allToyModelArr) {
    //     if ([toy.identifier isEqualToString:connectedToy.identifier]) {
    //         [_allToyModelArr removeObject:toy];
    //         [_allToyModelArr addObject:connectedToy];
    //         break;
    //     }
    // }
    // NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:_allToyModelArr];
    // [_methodChannel invokeMethod:@"batteryVal" arguments:flutterCompatibleArray];

}


// - (NSDictionary *)dictionaryFromLovenseToy:(LovenseToy *)toy {
//     return @{
        // @"name": toy.name ?: @"",
        // @"identifier": toy.identifier ?: @"",
        // @"toyType": toy.toyType ?: @"",
        // @"version": toy.version ?: @"",
        // @"macAddress": toy.macAddress ?: @"",
        // @"isFound": @(toy.isFound),
        // @"isConnected": @(toy.isConnected),
        // @"rssi": @(toy.rssi),
        // @"battery": @(toy.battery)
//     };
// }

// - (NSArray *)convertLovenseToysToDictionaries:(NSArray<LovenseToy *> *)toys {
    // NSMutableArray *toysArray = [NSMutableArray array];
    // for (LovenseToy *toy in toys) {
    //     NSDictionary *toyDict = [self dictionaryFromLovenseToy:toy];
    //     [toysArray addObject:toyDict];
    // }
    // return toysArray;
// }

// 连接失败回调
- (void)connectFailCallback:(NSNotification*)noti {
    // NSDictionary* resonDict = [noti object];
    // NSLog(@"%@", resonDict);
    // [_methodChannel invokeMethod:@"connectedFail" arguments:resonDict.description];
    // // 在这里可以通知Flutter视图显示错误信息
}

// 玩具断开连接回调
- (void)connectBreakCallback:(NSNotification*)noti {
    // NSDictionary* resonDict = [noti object];
    // NSLog(@"%@", resonDict);
    // LovenseToy* breakToy = [resonDict objectForKey:@"toy"];
    // NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:@[breakToy]];
    // [_methodChannel invokeMethod:@"notConnected" arguments:flutterCompatibleArray];
    // // 通知Flutter视图进行更新
}

// 初始化方法
- (void)initEx:(FlutterMethodCall*)call result:(FlutterResult)result {
    // NSString* token = @"NDI22IkSIp0sf2vBaVN80d6mJEUalgDkzofKEqnZwamGQay6cbO909-UEKGkmkJF";
    // if (token.length == 0) {
    //     NSLog(@"%s [Line %d] please input your token!", __PRETTY_FUNCTION__, __LINE__);
    // } else {
    //     [[Lovense shared] setDeveloperToken:token];
    //     [[Lovense shared] searchToys];
    // }
    // _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    // result(0);
    
}

@end
