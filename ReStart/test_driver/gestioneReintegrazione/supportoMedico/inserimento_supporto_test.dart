import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Funzione principale per eseguire i test dell'app Flutter.
void main() {
  group('App Flutter', () {
    late FlutterDriver driver;

    /// Imposta il driver Flutter prima dell'esecuzione dei test.
    ///
    /// Questa funzione viene eseguita una volta all'inizio dell'esecuzione del gruppo di test.
    setUpAll(() async {
      // Stabilisce una connessione con il driver Flutter.
      driver = await FlutterDriver.connect();
    });

    /// Chiude la connessione con il driver Flutter dopo i test.
    ///
    /// Questa funzione viene eseguita una volta alla fine dell'esecuzione del gruppo di test.
    tearDownAll(() async {
      // Chiude la connessione se esiste.
      driver.close();
    });

    /// Test per verificare la navigazione alla pagina di login.
    ///
    /// Verifica che il pulsante di login sia presente e cliccabile,
    /// e che i campi email e password siano visibili dopo il clic.
    test('navigazione alla pagina di login', () async {
      final loginButtonFinder = find.byValueKey('loginButton');
      await driver.tap(loginButtonFinder);

      final emailFieldFinder = find.byValueKey('usernameField');
      final passwordFieldFinder = find.byValueKey('passwordField');

      await driver.waitFor(emailFieldFinder);
      await driver.waitFor(passwordFieldFinder);
    });

    /// Test per inserimento e verifica del processo di login.
    ///
    /// Verifica che l'inserimento di username e password funzioni correttamente
    /// e che l'accesso porti alla visualizzazione di un elemento specifico post-login.
    test('Inserimento e test di login', () async {
      final usernameFieldFinder = find.byValueKey('usernameField');
      final passwordFieldFinder = find.byValueKey('passwordField');
      final loginButtonFinder = find.byValueKey('loginButton');

      await driver.tap(usernameFieldFinder);
      await driver.enterText('ads_user1');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.byValueKey('homeAds'));
    });

    /// Test per l'inserimento di un supporto medico.
    ///
    /// Verifica la possibilità di inserire un nuovo supporto medico nella piattaforma,
    /// compresa la compilazione di tutti i campi necessari e l'invio del modulo.
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
        0.0, // Distanza di scroll sull'asse X
        -900.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
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
      await driver.waitFor(find.text('Supporto medico inserito con successo'));
    });
  });
}
