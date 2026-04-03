class LovenseToy {
  final int battery;
  final int rssi;
  final bool isFound;
  final String identifier;
  final String toyType;
  final String version;
  final String macAddress;
  final String name;
  final bool isConnected;

  LovenseToy({
    required this.battery,
    required this.rssi,
    required this.isFound,
    required this.identifier,
    required this.toyType,
    required this.version,
    required this.macAddress,
    required this.name,
    required this.isConnected,
  });

  // 工厂构造函数从Map创建一个LovenseToy实例
  factory LovenseToy.fromMap(Map map) {
    return LovenseToy(
      battery: map['battery'] ?? 0, //电池电量
      rssi: map['rssi'] ?? 0, //信号强度
      isFound: map['isFound'] ?? false, //是否可以被发现
      identifier: map['identifier'] ?? '',
      toyType: map['toyType'] ?? '',
      version: map['version']?.toString() ?? '',
      macAddress: map['macAddress'] ?? '',
      name: map['name'] ?? '',
      isConnected: map['isConnected'] ?? false, //是否已经连接
    );
  }
}
