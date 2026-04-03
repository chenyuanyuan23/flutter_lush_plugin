import 'package:flutter_lush_plugin/lovenst_toy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LovenseToy', () {
    test('fromMap', () {
      final t = LovenseToy.fromMap({
        'battery': 80,
        'rssi': -50,
        'isFound': true,
        'identifier': 'id1',
        'toyType': 'max',
        'version': '1.0',
        'macAddress': 'AA:BB:CC',
        'name': 'toy1',
        'isConnected': true,
      });
      expect(t.battery, 80);
      expect(t.rssi, -50);
      expect(t.isFound, true);
      expect(t.identifier, 'id1');
      expect(t.toyType, 'max');
      expect(t.version, '1.0');
      expect(t.name, 'toy1');
      expect(t.isConnected, true);
    });

    test('fromMap 默认值', () {
      final t = LovenseToy.fromMap({});
      expect(t.battery, 0);
      expect(t.rssi, 0);
      expect(t.isFound, false);
      expect(t.identifier, '');
      expect(t.isConnected, false);
    });

    test('version toString', () {
      final t = LovenseToy.fromMap({'version': 123});
      expect(t.version, '123');
    });
  });
}
