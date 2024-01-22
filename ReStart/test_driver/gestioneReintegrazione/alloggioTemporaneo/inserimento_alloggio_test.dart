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

    /// Test per l'inserimento di un alloggio temporaneo.
    ///
    /// Verifica la possibilità di inserire un nuovo alloggio nella piattaforma,
    /// compresa la compilazione di tutti i campi necessari e l'invio del modulo.
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
      await driver.enterText(
          'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.');
      await driver.tap(tipologiaFieldFinder);
      await driver.enterText('Appartamento');
      await driver.tap(cittaFieldFinder);
      await driver.enterText('Milano');
      await driver.scroll(
        scrollable,
        0.0, // Distanza di scroll sull'asse X
        -900.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        const Duration(milliseconds: 900), // Durata dello scroll
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
