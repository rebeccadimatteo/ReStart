import 'package:restart_all_in_one/model/entity/ads_DTO.dart';
import 'package:restart_all_in_one/model/entity/ca_DTO.dart';
import 'package:restart_all_in_one/model/entity/utente_DTO.dart';
import 'package:test/test.dart';
import '../../../lib/model/dao/autenticazione/autenticazione_DAO_impl.dart';

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
      expect(result, equals(utenteMock));
    });

    test('Trova ca per username', () async {
      String caMock = 'aziendax';
      var result = await dao.findByUsername(caMock);
      expect(result, isNotNull);
      expect(result, equals(caMock));
    });

    test('Trova ads per username', () async {
      String adsMock = 'ads_user1';
      var result = await dao.findByUsername(adsMock);
      expect(result, isNotNull);
      expect(result, equals(adsMock));
    });

    test('Utente non trovato', () async {
      var result = await dao.findByUsername('notfound');
      expect(result, isNull);
    });
  });

  group('Test removeByUsername', () {
    test('Eliminazione utente da parte dell ads', () async {
      String username = 'mariorossi';
      var result = await dao.removeByUsername(username);
      expect(result, true);
    });

    test('Utente non trovato', () async {
      var result = await dao.removeByUsername('notfound');
      expect(result, false);
    });
  });

  group('Test add', () {

    test('Utente non riconosciuto', () async {
      var result = await dao.getTipoByUsername('username');
      expect(result, false);
    });

    test('Test per utente', () async {
      UtenteDTO u = UtenteDTO(
          nome: 'matteo',
          cognome: 'sileo',
          cod_fiscale: 'SLEMTT02R23H703F',
          data_nascita: DateTime(2002, 10, 23),
          luogo_nascita: 'Salerno',
          genere: 'M',
          username: 'PoH',
          password: 'Pass3',
          email: 'sileo@gmail.com',
          num_telefono: '3581798610',
          immagine: '',
          via: 'corso garibaldi 53',
          citta: 'Baronissi',
          provincia: 'SA');
      var ug = await dao.getTipoByUsername(u.username);
      var result = await dao.add(ug);
      expect(result, true);
    });

    test('Test per ads', () async {
      AdsDTO ads = AdsDTO(
          id: 10,
          username: 'ads_matteo',
          password: 'ads_password',
          email: 'lol@gmail.com',
          num_telefono: '3264879512',
          via: 'via lisca 5',
          citta: 'Baronissi',
          provincia: 'SA');
      var ug = await dao.getTipoByUsername(ads.username);
      var result = await dao.add(ug);
      expect(result, true);
    });

    test('Test per ca', () async {
      CaDTO ca = CaDTO(
          nome: 'matteo',
          username: 'ca_matteo',
          password: 'ca_password',
          email: 'ca@gmail.com',
          num_telefono: '3584216970',
          sito_web: 'www.matteo.com',
          via: 'gran bosco 23',
          citta: 'palermo',
          provincia: 'PA');
      var ug = await dao.getTipoByUsername(ca.username);
      var result = await dao.add(ug);
      expect(result, true);
    });
  });

  group('Test update', () {
    test('Update per utente', () async {
      UtenteDTO u = UtenteDTO(
          nome: 'matteo',
          cognome: 'panza',
          cod_fiscale: 'PNZMTT02R23H703F',
          data_nascita: DateTime(2002, 10, 23),
          luogo_nascita: 'Salerno',
          genere: 'M',
          username: 'PoH',
          password: 'Pass3',
          email: 'panza@gmail.com',
          num_telefono: '3581798610',
          immagine: '',
          via: 'corso garibaldi 53',
          citta: 'Baronissi',
          provincia: 'SA');
      var ug = await dao.getTipoByUsername(u.username);
      var result = await dao.update(ug);
    });

    test('update per ads', () async {
      AdsDTO ads = AdsDTO(
          id: 10,
          username: 'ads_matteo',
          password: 'ads_password',
          email: 'panza2@gmail.com',
          num_telefono: '3264879512',
          via: 'via lisca 5',
          citta: 'Baronissi',
          provincia: 'SA');
      var ug = await dao.getTipoByUsername(ads.username);
      var result = await dao.update(ug);
      expect(result, true);
    });

    test('update per ca', () async {
      CaDTO ca = CaDTO(
          nome: 'matteo',
          username: 'ca_matteo',
          password: 'ca_password',
          email: 'panza3@gmail.com',
          num_telefono: '3584216970',
          sito_web: 'www.matteo.com',
          via: 'gran bosco 23',
          citta: 'palermo',
          provincia: 'PA');
      var ug = await dao.getTipoByUsername(ca.username);
      var result = await dao.update(ug);
      expect(result, true);
    });
  });
}
