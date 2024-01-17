import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Test di sistema', () {
    late driver.FlutterDriver flutterDriver;

    // Ottieni la variabile d'ambiente
    final vmServiceUrl = Platform.environment['http://127.0.0.1:8080'];

    // Controlla se la variabile non è nulla e non è vuota
    if (vmServiceUrl != null && vmServiceUrl.isNotEmpty) {
      print('VM_SERVICE_URL: $vmServiceUrl');
    } else {
      print('VM_SERVICE_URL non impostato.');
    }

    setUpAll(() async {
      // Recupera l'URL del servizio VM dalla variabile di ambiente VM_SERVICE_URL
      final vmServiceUrl = Platform.environment['http://127.0.0.1:8080'];

      flutterDriver = await driver.FlutterDriver.connect(
        dartVmServiceUrl: vmServiceUrl,
      );
    });

    tearDownAll(() async {
      if (flutterDriver != null) {
        await flutterDriver.close();
      }
    });

    test('Verifica dell\'accesso', () async {
      await flutterDriver.tap(driver.find.byValueKey('username_field'));
      await flutterDriver.enterText('username');

      await flutterDriver.tap(driver.find.byValueKey('password_field'));
      await flutterDriver.enterText('passwordSegreta');

      await flutterDriver.tap(driver.find.byValueKey('login_button'));

      expect(await flutterDriver.getText(
          driver.find.byValueKey('welcome_message')), 'Benvenuto!');
    });
  });
}