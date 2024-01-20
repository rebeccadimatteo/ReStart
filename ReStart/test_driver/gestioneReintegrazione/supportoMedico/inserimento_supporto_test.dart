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
      driver.close();
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
      await driver.enterText('ads_user1');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.byValueKey('homeAds'));

    });

    //inserimento alloggio temporaneo
    test('Inserimento Supporto medico', () async {
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Inserisci supporto medico'));

      // Trova i campi di testo e il pulsante
      final scrollable = find.byValueKey('inserisciSupporto');
      final nomeMedicoFinder = find.byValueKey('nomeMedico');
      final cognomeMedicoFinder = find.byValueKey('cognomeMedico');
      final descrizioneFinder = find.byValueKey('descrizione');
      final tipologiaFinder = find.byValueKey('tipologia');
      final cittaFinder = find.byValueKey('citta');
      final viaFinder = find.byValueKey('via');
      final provinciaFinder = find.byValueKey('provincia');
      final emailFinder = find.byValueKey('email');
      final numTelefonoFinder = find.byValueKey('numTelefono');
      final buttonFinder = find.byValueKey('inserisciSupportoButton');

      // Inserisci l'username e la password
      await driver.tap(nomeMedicoFinder);
      await driver.enterText('Bartolomeo');
      await driver.tap(cognomeMedicoFinder);
      await driver.enterText('Giordano');
      await driver.tap(descrizioneFinder);
      await driver.enterText('Dentista pulito e sicuro');
      await driver.tap(tipologiaFinder);
      await driver.enterText('Odontotecnico');
      await driver.scroll(
        scrollable,
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        const Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(cittaFinder);
      await driver.enterText('Milano');
      await driver.tap(viaFinder);
      await driver.enterText('Via della Moscova, 1');
      await driver.tap(provinciaFinder);
      await driver.enterText('MI');
      await driver.tap(emailFinder);
      await driver.enterText('bgiordano@gmail.com');
      await driver.tap(numTelefonoFinder);
      await driver.enterText("+393495269914");

      await driver.tap(buttonFinder);
      await driver.waitFor(find.text('Richiesta inviata con successo'));

    });
  });
}