#import "FlutterLushPlugin.h"
#import <Flutter/Flutter.h>

@implementation FlutterLushPlugin {
    NSString* _token; // 用于存储token
    FlutterMethodChannel* _methodChannel; // Flutter与原生代码通信的渠道
    BOOL _isBluetoothEnabled; // 蓝牙是否启用的标志
    int batteryLevel;//当前设备的电量
    BOOL _isUserInitiatedDisconnect;//是否主动断开
    bool _isConnect;//当前是否链接过设备
    NSMutableArray<CBPeripheral *> *connectedPeripherals;
    bool _isBlueClose;//当前是否链接过设备
    bool _isInit;//是否已经初始化
}


// 注册插件方法
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_lush_plugin" binaryMessenger:[registrar messenger]];
    FlutterLushPlugin* instance = [[FlutterLushPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

// 初始化方法
- (instancetype)initWithChannel:(FlutterMethodChannel*)channel {
    self = [super init];
    if (self) {
        _methodChannel = channel;
        _isBluetoothEnabled = YES;
        _isBlueClose = true;
//        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        [self initNotification];
    }
    return self;
}

// 初始化通知
- (void)initNotification {
    _isUserInitiatedDisconnect = false;
    // 移除当前所有的观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // 添加扫描成功的通知，当玩具扫描成功时触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessCallback:) name:kToyScanSuccessNotification object:nil];

    // 添加连接成功的通知，当玩具成功连接时触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessCallback:) name:kToyConnectSuccessNotification object:nil];

    // 添加连接失败的通知，当玩具连接失败时触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFailCallback:) name:kToyConnectFailNotification object:nil];

    // 添加连接中断的通知，当玩具连接中断时触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakCallback:) name:kToyConnectBreakNotification object:nil];

    // 添加电池更新的通知，当玩具电池状态更新时触发
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCallbackNotificationBattery object:nil];

    // 添加发送命令错误的通知，当向玩具发送命令出错时触发
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToySendCommandErrorNotification object:nil];

    // 添加命令成功的通知，当玩具成功接收并执行命令时触发
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCommandCallbackNotificationAtSuccess object:nil];

    // 添加命令错误的通知，当玩具执行命令出错时触发
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBatteryUpdate:) name:kToyCommandCallbackNotificationAtError object:nil];
    
    
}

- (void)handleSendCommandError:(NSNotification *)notification {
    // 错误处理逻辑
    NSLog(@"Send command error: %@", notification.userInfo);
    [_methodChannel invokeMethod:@"toyMsg" arguments:notification.userInfo];
}

- (void)handleCommandSuccess:(NSNotification *)notification {
    // 成功执行命令的逻辑
    NSLog(@"Command executed successfully");
}

- (void)handleCommandError:(NSNotification *)notification {
    // 命令执行错误的处理逻辑
    NSLog(@"Error executing command: %@", notification.userInfo);
    [_methodChannel invokeMethod:@"toyMsg" arguments:notification.userInfo];
}


// 扫描成功回调
- (void)scanSuccessCallback:(NSNotification*)noti {
    NSDictionary* dict = [noti object];
    NSArray* scanToyArr = [dict objectForKey:@"scanToyArray"];
    self.allToyModelArr = [scanToyArr mutableCopy];
    [[Lovense shared] saveToys:self.allToyModelArr];
    NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:scanToyArr];

    [_methodChannel invokeMethod:@"deviceList" arguments:flutterCompatibleArray];
}

// 蓝牙状态更新回调
- (void)centralManagerDidUpdateState:(CBCentralManager*)central {
    if (central.state == CBManagerStatePoweredOn) {
        if(_isInit){
            if(_isBluetoothEnabled == NO){
                if(_isBlueClose){
                    _isBlueClose = false;
                    [[Lovense shared] searchToys];
                }
            }
        }
        _isBluetoothEnabled = YES;
    } else {
        _isBluetoothEnabled = NO;
    }
}

// 处理Flutter调用的方法
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([call.method isEqualToString:@"initLush"]) {
        [self initEx:call result:result];
    } else if ([call.method isEqualToString:@"vibrate"]) {
        if(self.allToyModelArr != nil){
            [self handleSetVibrationCall:call result:result];
        }
    } else if ([call.method isEqualToString:@"Preset"]) {
        if(self.allToyModelArr != nil){
            [self handleSetPresetCall:call result:result];
        }
    } else if ([call.method isEqualToString:@"connectToy"]) {
        if(_isBlueClose){
            _isBlueClose = false;
            [[Lovense shared] searchToys];
        }
        [self handleSetConnectToyCall:call result:result];
    } else if ([call.method isEqualToString:@"disConnectToy"]) {
        [self handleSetDisConnectToyCall:call result:result];
    }else if ([call.method isEqualToString:@"searchDevice"]) {
        if(_isBlueClose){
            _isBlueClose = false;
            [[Lovense shared] searchToys];
        }
    }else if ([call.method isEqualToString:@"initBluetooth"]) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    }else if([call.method isEqualToString:@"cleanHandler"]){
        [self cleanHandler];
    }
     else {
        result(FlutterMethodNotImplemented);
    }
}

// 设置振动的方法
- (void)handleSetVibrationCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary* args = call.arguments;
    NSUInteger value = [args[@"intensity"] unsignedIntegerValue];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@(value) forKey:kSendCommandParamKey_VibrateLevel];
    [[Lovense shared] sendCommandWithToyId:self.currentToy.identifier andCommandType:COMMAND_VIBRATE andParamDict:paramDict];
}

// 设置预设模式的方法
- (void)handleSetPresetCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary* args = call.arguments;
    NSUInteger value = [args[@"intensity"] unsignedIntegerValue];
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@(value) forKey:kSendCommandParamKey_PresetLevel];
    [[Lovense shared] sendCommandWithToyId:self.currentToy.identifier andCommandType:COMMAND_PRESET andParamDict:paramDict];
}

// 设置连接设备
- (void)handleSetConnectToyCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary* args = call.arguments;
    NSString* str = args[@"info"];
    if(str != nil && ![str isEqualToString:@""]){
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            // 断开连接的代码
            NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(0) forKey:kSendCommandParamKey_PresetLevel];
            [[Lovense shared] sendCommandWithToyId:str andCommandType:COMMAND_PRESET andParamDict:paramDict];

            NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(0) forKey:kSendCommandParamKey_VibrateLevel];
            [[Lovense shared] sendCommandWithToyId:str andCommandType:COMMAND_VIBRATE andParamDict:paramDict];
            
//            [[Lovense shared] disconnectToy:str];
            
            [[Lovense shared] connectToy:str];
        });

    }
}

// 设置断开连接设备
- (void)handleSetDisConnectToyCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary* args = call.arguments;
    _isUserInitiatedDisconnect = true;
    NSString* str = args[@"info"];
    if(str != nil && ![str isEqualToString:@""]){
        NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
        [paramDict setObject:@(0) forKey:kSendCommandParamKey_PresetLevel];
        [[Lovense shared] sendCommandWithToyId:self.currentToy.identifier andCommandType:COMMAND_PRESET andParamDict:paramDict];

        NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
        [paramDict setObject:@(0) forKey:kSendCommandParamKey_VibrateLevel];
        [[Lovense shared] sendCommandWithToyId:self.currentToy.identifier andCommandType:COMMAND_VIBRATE andParamDict:paramDict];
        // 延迟执行断开连接
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            // 断开连接的代码
            [[Lovense shared] disconnectToy:str];
            if(!_isBlueClose){
                _isBlueClose = true;
//                [[Lovense shared] stopSearching];
            }
        });
    }

}

// 连接成功回调
- (void)connectSuccessCallback:(NSNotification*)noti {
    NSDictionary* dict = [noti object];
    LovenseToy* connectedToy = [dict objectForKey:@"toy"];
//    if(self.currentToy.identifier != connectedToy.identifier){
        self.currentToy = connectedToy;
//        batteryLevel = connectedToy.battery;
//        for (LovenseToy* toy in self.allToyModelArr) {
//            if ([toy.identifier isEqualToString:connectedToy.identifier]) {
//                [self.allToyModelArr removeObject:toy];
//                [self.allToyModelArr addObject:connectedToy];
//                break;
//            }
//        }
        NSLog(@"%@", connectedToy);
        NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:self.allToyModelArr];
        [_methodChannel invokeMethod:@"connectedOk" arguments:flutterCompatibleArray];
//        [[Lovense shared] stopSearching];
        _isConnect = true;
//    }
    // 在这里可以通知Flutter视图进行更新
}

// 电量更新回调
- (void)handleBatteryUpdate:(NSNotification *)notification {
    // NSDictionary* userInfo = notification.userInfo;
    // LovenseToy* connectedToy = userInfo[@"receiveToy"];
    // NSString *val = userInfo[@"battery"];
    // batteryLevel = [val intValue];
    
    // for (LovenseToy* toy in self.allToyModelArr) {
    //     if ([toy.identifier isEqualToString:connectedToy.identifier]) {
    //         [self.allToyModelArr removeObject:toy];
    //         [self.allToyModelArr addObject:connectedToy];
    //         break;
    //     }
    // }
    // NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:self.allToyModelArr];
    // [_methodChannel invokeMethod:@"batteryVal" arguments:flutterCompatibleArray];

}


- (NSDictionary *)dictionaryFromLovenseToy:(LovenseToy *)toy {
    return @{
        @"name": toy.name ?: @"",
        @"identifier": toy.identifier ?: @"",
        @"toyType": toy.toyType ?: @"",
        @"version": toy.version ?: @"",
        @"macAddress": toy.macAddress ?: @"",
        @"isFound": @(toy.isFound),
        @"isConnected": @(toy.isConnected),
        @"rssi": @(toy.rssi),
        @"battery": @(toy.battery)
    };
}

- (NSArray *)convertLovenseToysToDictionaries:(NSArray<LovenseToy *> *)toys {
    NSMutableArray *toysArray = [NSMutableArray array];
    for (LovenseToy *toy in toys) {
        NSDictionary *toyDict = [self dictionaryFromLovenseToy:toy];
        [toysArray addObject:toyDict];
    }
    return toysArray;
}

// 连接失败回调
- (void)connectFailCallback:(NSNotification*)noti {
    NSDictionary* resonDict = [noti object];
    NSLog(@"%@", resonDict);
    [_methodChannel invokeMethod:@"connectedFail" arguments:resonDict.description];
    // 在这里可以通知Flutter视图显示错误信息
}

double delayInSeconds = 0.1; // 100毫秒
// 玩具断开连接回调
- (void)connectBreakCallback:(NSNotification*)noti {
    if(_isUserInitiatedDisconnect){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            self->_isUserInitiatedDisconnect = NO;
            // 在这里添加任何你需要在状态改变后执行的代码
        });
        return;
    }
    NSDictionary* resonDict = [noti object];
    NSLog(@"%@", resonDict);
    LovenseToy* breakToy = [resonDict objectForKey:@"toy"];
    if(_isConnect){
        NSArray *flutterCompatibleArray = [self convertLovenseToysToDictionaries:@[breakToy]];
        [_methodChannel invokeMethod:@"notConnected" arguments:flutterCompatibleArray];
        _isConnect = false;
    }
    // 通知Flutter视图进行更新
}

// 初始化方法
- (void)initEx:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* token = @"NDI22IkSIp0sf2vBaVN80d6mJEUalgDkzofKEqnZwamGQay6cbO909-UEKGkmkJF";
    if (token.length == 0) {
        NSLog(@"%s [Line %d] please input your token!", __PRETTY_FUNCTION__, __LINE__);
    } else {
        [[Lovense shared] setDeveloperToken:token];
//        if(_isBlueClose){
//            _isBlueClose = false;
            [[Lovense shared] searchToys];
//        }
        _isInit = true;
//        self.allToyModelArr = [[[Lovense shared] listToys] mutableCopy];
    }
//    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
//    connectedPeripherals = [[NSMutableArray alloc] init];
    result(0);
    
}




- (void)cleanHandler {
    
}

@end
