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

    /// Test per verificare la navigazione alla pagina di registrazione.
    ///
    /// Verifica che il pulsante di registrazione sia presente e cliccabile,
    /// e che il campo nome sia visibile dopo il clic.
    test('navigazione alla pagina di signup', () async {
      final signUpButtonFinder = find.byValueKey('signUpButton');
      await driver.tap(signUpButtonFinder);

      final nomeFieldFinder = find.byValueKey('nomeField');

      await driver.waitFor(nomeFieldFinder);
    });

    /// Test per inserimento e verifica del processo di registrazione.
    ///
    /// Verifica che l'inserimento dei dati per la registrazione funzioni correttamente.
    test('Inserimento e test di registrazione', () async {
      // Trova i campi di testo e il pulsante
      final scrollable = find.byValueKey('signUpPage');
      final nomeFieldFinder = find.byValueKey('nomeField');
      final cognomeFieldFinder = find.byValueKey('cognomeField');
      final dataNascitaFieldFinder = find.byValueKey('dataNascitaField');
      final luogoNascitaFieldFinder = find.byValueKey('luogoNascitaField');
      final cfFieldFinder = find.byValueKey('cfField');
      final genereFieldFinder = find.byValueKey('genereField');
      final cittaFieldFinder = find.byValueKey('cittaField');
      final provinciaFieldFinder = find.byValueKey('provinciaField');
      final viaFieldFinder = find.byValueKey('viaField');
      final telefonoFieldFinder = find.byValueKey('telefonoField');
      final emailFieldFinder = find.byValueKey('emailField');
      final passwordFieldFinder = find.byValueKey('passwordField');
      final usernameFieldFinder = find.byValueKey('usernameField');

      final signUpButtonFinder = find.byValueKey('signUpButton');

      //inserimento dati
      await driver.tap(nomeFieldFinder);
      await driver.enterText('Mario');
      await driver.tap(cognomeFieldFinder);
      await driver.enterText('Rossi');
      await driver.tap(dataNascitaFieldFinder);
      await driver.tap(find.text('OK'));
      await driver.tap(luogoNascitaFieldFinder);
      await driver.enterText('Roma');
      await driver.scroll(
        scrollable,
        0.0, // Distanza di scroll sull'asse X
        -900.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        const Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(cfFieldFinder);
      await driver.enterText('RSSMRA90A01H501A');
      await driver.tap(genereFieldFinder);
      await driver.tap(find.text('Maschio'));
      await driver.tap(cittaFieldFinder);
      await driver.enterText('Roma');
      await driver.tap(provinciaFieldFinder);
      await driver.enterText('RM');
      await driver.tap(viaFieldFinder);
      await driver.enterText('Via Roma ,1');
      await driver.tap(telefonoFieldFinder);
      await driver.enterText('+393333333333');
      await driver.scroll(
        scrollable,
        0.0, // Distanza di scroll sull'asse X
        -900.0,
        // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        const Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(emailFieldFinder);
      await driver.enterText('mariorossi@gmail.com');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');
      await driver.tap(usernameFieldFinder);
      await driver.enterText('mariorossi1');

      await driver.tap(signUpButtonFinder);

      await driver.waitFor(usernameFieldFinder);
    });

    test('Inserimento e test di login', () async {
      // Trova i campi di testo e il pulsante
      final usernameFieldFinder = find.byValueKey('usernameField');
      final passwordFieldFinder = find.byValueKey('passwordField');
      final loginButtonFinder = find.byValueKey('loginButton');
      final eventoFinder = find.byValueKey('eventoItem');

      // Inserisci l'username e la password
      await driver.tap(usernameFieldFinder);
      await driver.enterText('mariorossi');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('password1');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);

      await driver.waitFor(eventoFinder);
    });
  });
}
