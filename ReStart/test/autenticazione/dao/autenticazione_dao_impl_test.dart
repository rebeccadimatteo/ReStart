// autenticazione_dao_impl_test.dart
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/model/dao/autenticazione/autenticazione_DAO_impl.dart';
import '../../../lib/model/entity/utente_DTO.dart';

void main() {
  late AutenticazioneDAOImpl dao;

  setUp(() {
    dao = AutenticazioneDAOImpl();
  });

    group('Test AutenticazioneDAOImpl', () {

      test('Trova utente per username', () async {
        String utenteMock = 'mariorossi';
        var result = await dao.findByUsername(utenteMock);
        expect(result, isNotNull);
        expect(result.username, equals(utenteMock));
      });

      test('Utente non trovato', () async {
        var result = await dao.findByUsername('notfound');
        expect(result, isNull);
      });
    });
}
