import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../lib/application/autenticazione/service/autonticazione_service_impl.dart';

class MockAutenticazioneServiceImpl extends Mock implements AutenticazioneServiceImpl {}

void main() {
  late AutenticazioneServiceImpl service;

  setUp(() {
    service = AutenticazioneServiceImpl();
  });

  group('Login test', () {
    test('Accesso non andato a buon fine: Username troppo lungo', () async {
      String username = "aldobianchi2002_";
      String password = "Aldo2002@!";
      dynamic result = await service.login(username, password);
      expect(result, null);
      if(result == null) print("Accesso non effettuato, username troppo lungo: TEST ANDATO A BUON FINE");
    });
    test('Accesso non andato a buon fine: Password troppo lunga', () async {
      String username = "aldobianchi";
      String password = "AldoBianchi2002@!";
      dynamic result = await service.login(username, password);
      expect(result, null);
      if(result == null) print("Accesso non effettuato, password troppo lunga: TEST ANDATO A BUON FINE");
    });
    test('Accesso andato a buon fine!', () async {
      String username = 'aldobianchi';
      String password = 'Aldo2002@!';
      dynamic result = await service.login(username, password);
      expect(result.username, username);
      expect(result.password, password);
      if(result.username == username && result.password == password ) print("Accesso effettuato: TEST ANDATO A BUON FINE");
    });
  });
}
