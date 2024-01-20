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
      await driver.enterText('Corso completo di Python orientato allo sviluppo di modelli di IA');
      await driver.scroll(
        scrollable,
        0.0,      // Distanza di scroll sull'asse X
        -400.0,   // Distanza di scroll sull'asse Y (negativo per scroll verso il basso)
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

