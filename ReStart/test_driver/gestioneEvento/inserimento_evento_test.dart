import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('App Flutter', () {
    late FlutterDriver driver;

    // Connettiti al driver prima dei test.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

// Chiudi la connessione al driver dopo i test.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
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


      // Inserisci l'username e la password
      await driver.tap(usernameFieldFinder);
      await driver.enterText('aziendax');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.byValueKey('homeCa'));
    });

    //test per l'inserimento dell'evento
    test('Inserimento evento', () async {
      // Trova e clicca sul pulsante di aggiuingi evento
      await driver.tap(find.byValueKey('addEventoContainer'));
      // Trova i campi di testo e il pulsante
      final scrollable = find.byValueKey('inserisciEvento');
      final nomeEventoFinder = find.byValueKey('nomeEvento');
      final descrizioneFinder = find.byValueKey('descrizione');
      final cittaFinder = find.byValueKey('citta');
      final viaFinder = find.byValueKey('via');
      final provinciaFinder = find.byValueKey('provincia');
      final dataFinder = find.byValueKey('data');
      final emailFinder = find.byValueKey('email');
      final buttonFinder = find.byValueKey('inserisciEventoButton');

      // Inserisci l'username e la password
      await driver.tap(nomeEventoFinder);
      await driver.enterText('Esplorazione Artistica e Laboratori Creativi');
      await driver.tap(descrizioneFinder);
      await driver.enterText('Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.');
      await driver.tap(cittaFinder);
      await driver.enterText('Boscotrecase');
      await driver.tap(viaFinder);
      await driver.enterText('Via Balzano, 2');
      await driver.tap(provinciaFinder);
      await driver.enterText('NA');
      await driver.scroll(
        scrollable,
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(dataFinder);
      await driver.tap(find.text('27'));
      await driver.tap(find.text('OK'));
      await driver.tap(find.text('OK'));
      await driver.tap(emailFinder);
      await driver.enterText('eventibosco@gmail.com');

      await driver.tap(buttonFinder);
      await driver.waitFor(find.text('Richiesta inviata con successo'));
    });
  });
}

