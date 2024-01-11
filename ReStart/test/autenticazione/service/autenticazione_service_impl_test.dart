import 'package:matcher/matcher.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/application/autenticazione/service/autonticazione_service_impl.dart';
import '../../../lib/model/dao/autenticazione/autenticazione_DAO.dart';
import '../../../lib/model/entity/utente_DTO.dart';

class MockAutenticazioneDAO extends Mock implements AutenticazioneDAO {}

void main() {
  late MockAutenticazioneDAO dao;
  late AutenticazioneServiceImpl service;

  setUp(() {
    dao = MockAutenticazioneDAO();
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
      String username = 'mariorossi';
      String password = 'password1';
      dynamic result = await service.login(username, password);
      expect(result.username, username);
      expect(result.password, password);
      if(result.username == username && result.password == password ) print("Accesso effettuato: TEST ANDATO A BUON FINE");
    });
  });
}
