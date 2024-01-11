import 'dart:math';

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
  late AutenticazioneServiceImpl service;

  setUp(() {
    dao = MockAutenticazioneDAO();
    service = AutenticazioneServiceImpl();
  });

  group('Login test', () {
    test('Utente non trovato', () async {
      when(dao.findByUsername('testUser')).thenAnswer((_) async => null);

      final result = await service.login('testUser', '123');

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
          await service.login(mockUtente.username, mockUtente.password);
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
          await service.login(mockAds.username, mockAds.password);
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
          await service.login(mockca.username, mockca.password);
      expect(result, isA<AdsDTO>());
    });
  });

  group('Test deleteUtente', () {
    test('Rimozione utente ', () async {
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
      when(dao.removeByUsername(mockUtente.username))
          .thenAnswer((_) async => true);
      var result =
          await service.deleteUtente(mockUtente.username);
      expect(result, isNotNull);
      expect(result, true);
    });
  });

  group('Test listaUtenti', () {
    test('Lista utenti', () async{
      Future<List<UtenteDTO>> l1 = service.listaUtenti();
      expect(l1, isNotNull);
      expect(l1, isA<Future<List<UtenteDTO>>>);
    });
  });

  group('Test modifyUtente', () {
    test('Modify utente', () async{
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
      var result = await service.modifyUtente(u);
      expect(result, true);
    });
  });

  group('Test visualizzaUtente', () {
    test('visualizza utente', () {
      String username = 'mariorossi';
      var result = service.visualizzaUtente(username);
      expect(result, isA<Future<UtenteDTO?>>);
    });
  });
}
