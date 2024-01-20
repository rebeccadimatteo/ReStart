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
    test('Inserimento alloggio temporaneo', () async {
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Inserisci alloggio temporaneo'));

      final scrollable = find.byValueKey('inserisciAlloggio');
      final nomeFieldFinder = find.byValueKey('nomeAlloggioField');
      final descrizioneFieldFinder = find.byValueKey('descrizioneField');
      final tipologiaFieldFinder = find.byValueKey('tipoField');
      final cittaFieldFinder = find.byValueKey('cittaField');
      final viaFieldFinder = find.byValueKey('viaField');
      final provinciaFieldFinder = find.byValueKey('provinciaField');
      final emailFieldFinder = find.byValueKey('emailField');
      final urlFieldFinder = find.byValueKey('sitoField');
      final inserisciButtonFinder = find.byValueKey('inserisciButton');

      await driver.tap(nomeFieldFinder);
      await driver.enterText('Casa Valeria');
      await driver.tap(descrizioneFieldFinder);
      await driver.enterText('Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.');
      await driver.tap(tipologiaFieldFinder);
      await driver.enterText('Appartamento');
      await driver.tap(cittaFieldFinder);
      await driver.enterText('Milano');
      await driver.scroll(
        scrollable,
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(viaFieldFinder);
      await driver.enterText('Via Dante, 256');
      await driver.tap(provinciaFieldFinder);
      await driver.enterText('MI');
      await driver.tap(emailFieldFinder);
      await driver.enterText('casavaleria@gmail.com');
      await driver.tap(urlFieldFinder);
      await driver.enterText('www.casavaleria.it');

      await driver.tap(inserisciButtonFinder);
      await driver.waitFor(find.text('Alloggio inserito con successo'));
    });
  });
}

