import 'package:restart_all_in_one/model/entity/ads_DTO.dart';
import 'package:restart_all_in_one/model/entity/ca_DTO.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/application/autenticazione/service/autonticazione_service_impl.dart';
import '../../../lib/model/dao/autenticazione/autenticazione_DAO.dart';
import '../../../lib/model/entity/utente_DTO.dart';

class MockAutenticazioneDAO extends Mock implements AutenticazioneDAO {}

void main() {
  late MockAutenticazioneDAO dao;
  late AutenticazioneServiceImpl autenticazione;

  setUp(() {
    dao = MockAutenticazioneDAO();
    autenticazione = AutenticazioneServiceImpl();
  });

  group('Login test', () {
    test('Utente non trovato', () async {
      when(dao.findByUsername('testUser')).thenAnswer((_) async => null);

      final result = await autenticazione.login('testUser', '123');

      expect(result, isNull);
    });

    test('Login avvenuto con successo, entrato come: Utente', () async {
      UtenteDTO mockUtente = UtenteDTO(
        username: 'mariorossi',
        password: 'password1',
        nome: '',
        cognome: '',
        cod_fiscale: '',
        data_nascita: DateTime.now(),
        luogo_nascita: '',
        genere: '',
        email: '',
        num_telefono: '',
        immagine: '',
        via: '',
        citta: '',
        provincia: '',
      );
      when(dao.findByUsername(mockUtente.username))
          .thenAnswer((_) async => mockUtente);
      var result =
          await autenticazione.login(mockUtente.username, mockUtente.password);
      expect(result, isNotNull);
      expect(result.token, isNotNull);
    });

    test('Login avvenuto con successo, entrato come: ADS', () async {
      AdsDTO mockAds = AdsDTO(
          id: 4,
          username: 'ads_user1',
          password: 'password1',
          email: '',
          num_telefono: '',
          via: '',
          citta: '',
          provincia: '');
      when(dao.findByUsername(mockAds.username))
          .thenAnswer((_) async => mockAds);
      final result =
          await autenticazione.login(mockAds.username, mockAds.password);
      expect(result, isA<AdsDTO>());
    });

    test('Login avvenuto con successo, entrato come: CA', () async {
      CaDTO mockca = CaDTO(
          nome: 'AziendaX',
          username: 'aziendax',
          password: 'password1',
          email: '',
          num_telefono: '',
          sito_web: '',
          via: '',
          citta: '',
          provincia: '');
      when(dao.findByUsername(mockca.username))
          .thenAnswer((_) async => mockca);
      final result =
          await autenticazione.login(mockca.username, mockca.password);
      expect(result, isA<AdsDTO>());
    });
  });
}
