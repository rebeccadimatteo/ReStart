import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restart/model/dao/evento/evento_DAO_impl.dart';
import 'package:restart/presentation/screens/eventi/eventi.dart';
import 'package:restart/presentation/screens/home/home_utente.dart';
import 'package:restart/presentation/screens/login_signup/login.dart';
import 'package:restart/presentation/screens/login_signup/start.dart' as app;

void main() {
  // Attiva la modalità test DAO
  EventoDAOImpl.isTestMode = true;

  // Widget test per CommunityEvents
  testWidgets('CommunityEvents Screen Test', (WidgetTester tester) async {
    // Carica l'app
    app.main();
    await tester.pumpAndSettle();
    final loginButtonFinder = find.text('ACCEDI');
    expect(loginButtonFinder, findsOneWidget);
    await tester.tap(loginButtonFinder);

    // Attendi la fine della navigazione
    await tester.pumpAndSettle();

    // Verifica che la pagina di login sia stata caricata
    expect(find.byType(LoginPage), findsOneWidget); // Sostituisci con il tipo effettivo della schermata di login

    // Inserisci username e password
    await tester.enterText(find.byKey(Key('usernameField')), 'mariorossi');
    await tester.enterText(find.byKey(Key('passwordField')), 'password1');
    await tester.pumpAndSettle();
// Trova e simula il tap sul bottone "ACCEDI"
    final loginButtonFinder1 = find.text('ACCEDI');
    await tester.tap(loginButtonFinder1);
    await tester.pumpAndSettle();

    // Verifica la navigazione alla pagina successiva
    // Assicurati di sostituire 'NextPage' con il tipo effettivo della tua prossima pagina
    expect(find.byType(HomeUtente), findsOneWidget);

    await tester.tap(find.byKey(Key('bottone_tendina')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Community Events'));
    await tester.pumpAndSettle();

    // Verifica che lo screen CommunityEvents venga visualizzato
    expect(find.byType(CommunityEvents), findsOneWidget);

    // Aggiungi qui ulteriori test, ad esempio:
    // Verifica la presenza di un evento specifico
    expect(find.text('Evento Mock 1'), findsOneWidget);

    // Testa l'interazione con un elemento della lista
    await tester.tap(find.text('Evento Mock 1'));
    await tester.pumpAndSettle();

    // Verifica che lo screen dei dettagli venga caricato
    expect(find.byType(DetailsEvento), findsOneWidget);
  });

  // Disattiva la modalità test DAO
  EventoDAOImpl.isTestMode = false;
}