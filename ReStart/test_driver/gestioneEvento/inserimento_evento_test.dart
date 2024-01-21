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
      await driver.enterText('aziendax');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.byValueKey('homeCa'));
    });

    /// Test per l'inserimento di un evento.
    ///
    /// Verifica la possibilità di inserire un nuovo evento nella piattaforma,
    /// compresa la compilazione di tutti i campi necessari e l'invio del modulo.
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
      await driver.enterText(
          'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.');
      await driver.tap(cittaFinder);
      await driver.enterText('Boscotrecase');
      await driver.tap(viaFinder);
      await driver.enterText('Via Balzano, 2');
      await driver.tap(provinciaFinder);
      await driver.enterText('NA');
      await driver.scroll(
        scrollable,
        0.0, // Distanza di scroll sull'asse X
        -900.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
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
