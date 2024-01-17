import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_driver/flutter_driver.dart' as driver;


void main() {
  group('Test di sistema', () {
    late driver.FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await driver.FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (flutterDriver != null) {
        await flutterDriver.close();
      }
    });

    test('Aggiunta di un evento alla sezione', () async {
      // Trova e tocca il pulsante di aggiunta
      await flutterDriver.tap(driver.find.byValueKey('add_event_button'));

      // Attendi un breve momento per permettere all'animazione di completarsi
      await flutterDriver.waitFor(Duration(seconds: 1) as driver.SerializableFinder);

      // Verifica che il nuovo evento sia stato aggiunto alla lista
      expect(await flutterDriver.getText(driver.find.byValueKey('widjet-key')), isNotNull);
    });
  });
}


