#import <Flutter/Flutter.h>
#import <Lovense/Lovense.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FlutterLushPlugin : NSObject<FlutterPlugin,CBCentralManagerDelegate>
@property (nonatomic,strong) CBCentralManager * centralManager;
@property(nonatomic,strong) NSMutableArray<LovenseToy*> * allToyModelArr;
@property(nonatomic,strong)LovenseToy * currentToy;
@end
