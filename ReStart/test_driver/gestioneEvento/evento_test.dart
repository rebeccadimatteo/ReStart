import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('App Flutter', () {
    late FlutterDriver driver;

    // Connettiti al driver prima dei test.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });


    test('navigazione alla pagina di login', () async {
      // Trova e clicca sul pulsante di login
      final loginButtonFinder = find.byValueKey('loginButton');
      await driver.tap(loginButtonFinder);

      // Cerca il campo email nella pagina di login
      final emailFieldFinder = find.byValueKey('usernameField');
      final passwordFieldFinder = find.byValueKey('passwordField');

      // Verifica che il campo email e password esistano
      await driver.waitFor(emailFieldFinder);
      await driver.waitFor(passwordFieldFinder);

      // Aggiungi qui altre verifiche se necessario
    });

    test('Inserimento e test di login', () async {
      // Trova i campi di testo e il pulsante
      final usernameFieldFinder = find.byValueKey('usernameField');
      final passwordFieldFinder = find.byValueKey('passwordField');
      final loginButtonFinder = find.byValueKey('loginButton');
      final endDrawer = find.byType('endDrawer');
      final drawer = find.byValueKey('drawer');

      // Inserisci l'username e la password
      await driver.tap(usernameFieldFinder);
      await driver.enterText('mariorossi');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);

      await driver.tap(endDrawer);
      // Verifica la navigazione o la presenza di messaggi di errore
      await driver.waitFor(drawer);
    });

    test('Reindirizzamento Sezione CommunityEvents', () async {

      final eventoFinder = find.byValueKey('eventoItem');
      final drawer = find.byValueKey('drawer');
      final endDrawer = find.byType('endDrawer');
      final sezioneEvento = find.text('Community Events');
      final dettaglioEventoFinder = find.byValueKey('dettaglioEvento');
      final listaEventiFinder = find.byValueKey('listaEventi');

      await driver.tap(drawer);
      await driver.waitFor(endDrawer);

      await driver.tap(sezioneEvento);
      await driver.waitFor(sezioneEvento);

      await driver.tap(listaEventiFinder);
      await driver.waitFor(dettaglioEventoFinder);

    });


    // Chiudi la connessione al driver dopo i test.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
  });
}

