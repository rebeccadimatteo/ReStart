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

    test('Verifica delll registrazione', () async {
      await flutterDriver.tap(driver.find.byValueKey('username_field'));
      await flutterDriver.enterText('nomeUtente');

      await flutterDriver.tap(driver.find.byValueKey('cod_fiscale'));
      await flutterDriver.enterText('cod_fiscale');

      await flutterDriver.tap(driver.find.byValueKey('data_nascita'));
      await flutterDriver.enterText('data');

      await flutterDriver.tap(driver.find.byValueKey('luogo_nascita'));
      await flutterDriver.enterText('luogo_nascita');

      await flutterDriver.tap(driver.find.byValueKey('genere'));
      await flutterDriver.enterText('genere');

      await flutterDriver.tap(driver.find.byValueKey('username'));
      await flutterDriver.enterText('username');

      await flutterDriver.tap(driver.find.byValueKey('password'));
      await flutterDriver.enterText('password');

      await flutterDriver.tap(driver.find.byValueKey('lavoro_adatto'));
      await flutterDriver.enterText('lavoro_adatto');

      await flutterDriver.tap(driver.find.byValueKey('email'));
      await flutterDriver.enterText('email');

      await flutterDriver.tap(driver.find.byValueKey('num_telefono'));
      await flutterDriver.enterText('num_telefono');

      await flutterDriver.tap(driver.find.byValueKey('immagine'));
      await flutterDriver.enterText('immagine');

      await flutterDriver.tap(driver.find.byValueKey('via'));
      await flutterDriver.enterText('via');

      await flutterDriver.tap(driver.find.byValueKey('citta'));
      await flutterDriver.enterText('citta');

      await flutterDriver.tap(driver.find.byValueKey('provincia'));
      await flutterDriver.enterText('provincia');

    await flutterDriver.tap(driver.find.byValueKey('register_button'));

      expect(await flutterDriver.getText(driver.find.byValueKey('welcome_message')), 'Benvenuto!');
    });
  });
}