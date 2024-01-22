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

    /// Test per l'inserimento di un corso di formazione.
    ///
    /// Verifica la possibilità di inserire un nuovo corso di formazione nella piattaforma,
    /// compresa la compilazione di tutti i campi necessari e l'invio del modulo.
    test('Inserimento corso di formazione', () async {
      await driver.tap(find.byTooltip('Open navigation menu'));
      await driver.tap(find.text('Inserisci corso di formazione'));
      final scrollable = find.byValueKey('inserisciCorso');
      final nomeFinder = find.byValueKey('nome');
      final nomeResponsabileFinder = find.byValueKey('nomeResponsabile');
      final cognomeResponsabileFinder = find.byValueKey('cognomeResponsabile');
      final descrizioneFinder = find.byValueKey('descrizione');
      final emailFinder = find.byValueKey('email');
      final numeroFinder = find.byValueKey('numero');
      final urlFinder = find.byValueKey('url');
      final buttonFinder = find.byValueKey('inserisciButton');

      await driver.tap(nomeFinder);
      await driver.enterText('Python per IA:Sviluppo modelli avanzati');
      await driver.tap(nomeResponsabileFinder);
      await driver.enterText('Giovanni');
      await driver.tap(cognomeResponsabileFinder);
      await driver.enterText('Rossi');
      await driver.tap(descrizioneFinder);
      await driver.enterText(
          'Corso completo di Python orientato allo sviluppo di modelli di IA');
      await driver.scroll(
        scrollable,
        0.0, // Distanza di scroll sull'asse X
        -400.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        const Duration(milliseconds: 400), // Durata dello scroll
      );
      await driver.tap(emailFinder);
      await driver.enterText('python@gmail.com');
      await driver.tap(numeroFinder);
      await driver.enterText('+393331234567');
      await driver.tap(urlFinder);
      await driver.enterText('https://www.example.com/corso-python-avanzato');
      await driver.tap(buttonFinder);

      await driver.waitFor(find.text('Corso inserito con successo'));
    });
  });
}
