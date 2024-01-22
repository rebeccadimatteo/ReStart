import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:restart/application/autenticazione/service/autonticazione_service_impl.dart';

/// Classe Mock per simulare il comportamento di [AutenticazioneServiceImpl].
class MockAutenticazioneServiceImpl extends Mock
    implements AutenticazioneServiceImpl {}

void main() {
  late AutenticazioneServiceImpl service;

  /// Inizializza il servizio di autenticazione prima di ogni test.
  setUp(() {
    service = AutenticazioneServiceImpl();
  });

  /// Raggruppamento di test riguardanti il processo di login.
  group('Login test', () {
    /// Testa il caso di fallimento dell'accesso con username troppo lungo.
    ///
    /// Verifica che il risultato sia `null` in caso di username troppo lungo.
    test('Accesso non andato a buon fine: Username troppo lungo', () async {
      String username = "aldobianchi2002_";
      String password = "Aldo2002@!";
      dynamic result = await service.login(username, password);
      expect(result, null);
      if (result == null) {
        print(
            "Accesso non effettuato, username troppo lungo: TEST ANDATO A BUON FINE");
      }
    });

    /// Testa il caso di fallimento dell'accesso con password troppo lunga.
    ///
    /// Verifica che il risultato sia `null` in caso di password troppo lunga.
    test('Accesso non andato a buon fine: Password troppo lunga', () async {
      String username = "aldobianchi";
      String password = "AldoBianchi2002@!";
      dynamic result = await service.login(username, password);
      expect(result, null);
      if (result == null) {
        print(
            "Accesso non effettuato, password troppo lunga: TEST ANDATO A BUON FINE");
      }
    });

    /// Testa il caso di successo dell'accesso.
    ///
    /// Verifica che il risultato corrisponda all'username e alla password forniti.
    test('Accesso andato a buon fine!', () async {
      String username = 'lucabianchi';
      String password = 'password2';
      dynamic result = await service.login(username, password);
      expect(result.username, username);
      expect(result.password, password);
      if (result.username == username && result.password == password) {
        print("Accesso effettuato: TEST ANDATO A BUON FINE");
      }
    });
  });
}
