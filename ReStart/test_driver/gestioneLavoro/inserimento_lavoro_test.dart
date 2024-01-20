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
      await driver.enterText('azienday');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password2');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.byValueKey('homeCa'));
    });

    //test per l'inserimento dell'annuncio
    test('Inserimento annuncio', () async {
      // Trova e clicca sul pulsante di aggiuingi Annuncio
      await driver.tap(find.byValueKey('addAnnuncioContainer'));
      // Trova i campi di testo e il pulsante
      final scrollable = find.byValueKey('inserisciAnnuncio');
      final nomeAnnuncioFinder = find.byValueKey('nomeAnnuncio');
      final descrizioneFinder = find.byValueKey('descrizione');
      final cittaFinder = find.byValueKey('citta');
      final viaFinder = find.byValueKey('via');
      final provinciaFinder = find.byValueKey('provincia');
      final emailFinder = find.byValueKey('email');
      final numTelefonoFinder = find.byValueKey('numTelefono');
      final buttonFinder = find.byValueKey('inserisciAnnuncioButton');

      // Inserisci l'username e la password
      await driver.tap(nomeAnnuncioFinder);
      await driver.enterText('Software Developer in Tecnologie Avanzate');
      await driver.tap(descrizioneFinder);
      await driver.enterText('Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.');
      await driver.tap(cittaFinder);
      await driver.enterText('Roma');
      await driver.tap(viaFinder);
      await driver.enterText('Via delle Acacie, 56');
      await driver.tap(provinciaFinder);
      await driver.enterText('RM');
      await driver.scroll(
        scrollable,
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(emailFinder);
      await driver.enterText('techforgesolution@gmail.com');
      await driver.tap(numTelefonoFinder);
      await driver.enterText("+393572850945");

      await driver.tap(buttonFinder);
      await driver.waitFor(find.text('Richiesta inviata con successo'));
    });
  });
}

