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

    test('navigazione alla pagina di signup', () async {
      // Trova e clicca sul pulsante di login
      final signUpButtonFinder = find.byValueKey('signUpButton');
      await driver.tap(signUpButtonFinder);

      // Cerca il campo email nella pagina di login
      final nomeFieldFinder = find.byValueKey('nomeField');

      // Verifica che il campo email e password esistano
      await driver.waitFor(nomeFieldFinder);
    });

    //aggiungere test per la registrazione
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
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        Duration(milliseconds: 900), // Durata dello scroll
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
        0.0,      // Distanza di scroll sull'asse X
        -900.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
        Duration(milliseconds: 900), // Durata dello scroll
      );
      await driver.tap(emailFieldFinder);
      await driver.enterText('mariorossi@gmail.com');
      await driver.tap(passwordFieldFinder);
      await driver.enterText('prova');
      await driver.tap(usernameFieldFinder);
      await driver.enterText('mariorossi');

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
      await driver.enterText('prova');

      // Esegui il tap sul pulsante di accesso
      await driver.tap(loginButtonFinder);

      await driver.waitFor(eventoFinder);
    });
  });
}
