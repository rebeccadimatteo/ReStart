import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/model/entity/evento_DTO.dart';
import 'package:test/test.dart';
import '../../../lib/application/gestioneEvento/service/evento_service_impl.dart';
import '../../../lib/model/dao/evento/evento_DAO_impl.dart';

class MockitoEventoImp extends Mock implements EventoServiceImpl {}

class MockitoEvento extends Mock implements EventoDAOImpl {}

bool validateNomeEvento(String nome) {
  if (nome.length >= 50)
    return false;
  else
    return true;
}

bool validateData(DateTime data) {
  String dataString = DateFormat('yyyy-MM-dd HH:mm:ss').format(data);
  RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$');
  if(data.isBefore(DateTime.now())){
    return false;
  } else {
    return regex.hasMatch(dataString);
  }
}

// bool validateData(DateTime data) {
//   String dataString = DateFormat('yyyy-MM-dd').format(data);
//   RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
//   return regex.hasMatch(dataString);
// }

bool validateDescrizione(String descrizione) {
  if (descrizione.length >= 200)
    return false;
  else
    return true;
}

bool validateVia(String via) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
  return regex.hasMatch(via);
}

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return regex.hasMatch(email);
}

bool validateCitta(String citta) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
  return regex.hasMatch(citta);
}

bool validateProvincia(String provincia) {
  RegExp regex = RegExp(r'^[A-Z]{2}');
  if (provincia.length > 2) return false;
  return regex.hasMatch(provincia);
}

bool validateImmagine(String immagine) {
  RegExp regex = RegExp(r'^.+\.jpe?g$');
  return regex.hasMatch(immagine);
}

void main() {
  late EventoServiceImpl service;

  setUp(() {
    service = EventoServiceImpl();
  });

  group('Aggiunta Evento', () {
    test('Aggiunta evento non va a buon fine, lunghezza nome errata', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento:
              'Esplorazione Artistica e Laboratori Creativi: Un Giorno di Scoperta Culturale.',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_1');
      } else {
        expect(result, null);
        print('Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_1');
      }
    });
    test('Aggiunta evento non va a buon fine, lunghezza descrizione errata',
        () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente e unico che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance emozionanti. Un\'esperienza culturale senza precedenti che promuove la creatività, l\'apprendimento e la connessione. Un giorno di scoperta culturale ricco di ispirazione e divertimento, progettato per lasciare un\'impronta duratura nella mente e nel cuore di chi partecipa. Sperimenta l\'arte in modi innovativi, interagisci con artisti locali e internazionali e lasciati trasportare in un viaggio unico nel mondo della creatività. Un\'opportunità imperdibile di esplorare il potere dell\'espressione artistica e coltivare la tua passione per le arti in un ambiente accogliente e stimolante. Unisciti a noi e fai parte di questo straordinario viaggio attraverso la bellezza e l\'ispirazione dell\'Esplorazione Artistica e Laboratori Creativi.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_2');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_2');
      }
    });
    test('Aggiunta evento non va a buon fine, formato immagine errata', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.docx',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_3');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_3');
      }
    });
    test('Aggiunta evento non va a buon fine, formato data errata', () async{
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2023 - 12 - 22 - 10 - 30 - 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_4');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_4');
      }
    });
    test('Aggiunta evento non va a buon fine, formato email errata', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventiboscogmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_5');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_5');
      }
    });
    test('Aggiunta evento non va a buon fine, formato via errata', () async{
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: '2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_6');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_6');
      }
    });
    test('Aggiunta evento non va a buon fine, formato citta errata', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Bosco3case',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_7');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_7');
      }
    });
    test('Aggiunta evento non va a buon fine, formato provincia errata', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA22');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST NON SUPERATO 7.1_9');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST SUPERATO 7.1_9');
      }
    });
    test('Aggiunta evento va a buon fine', () async {
      dynamic result;
      EventoDTO e = EventoDTO(
          id_ca: 1,
          immagine: 'EventoBosco.jpg',
          nomeEvento: 'Esplorazione Artistica e Laboratori Creativi',
          descrizione:
              'Un evento coinvolgente che offre a persone di tutte le età l\'opportunità di immergersi nelle arti attraverso una varietà di laboratori interattivi, esposizioni artistiche e performance dal vivo.',
          date: DateTime(2024, 12, 22, 10, 30, 0),
          approvato: true,
          email: 'eventibosco@gmail.com',
          sito: 'www.eventobosco.biz',
          via: 'Via Balzano 2',
          citta: 'Boscotrecase',
          provincia: 'NA');

      bool validaN = validateNomeEvento(e.nomeEvento);
      bool validaD = validateDescrizione(e.descrizione);
      bool validaI = validateImmagine(e.immagine);
      bool validaData = validateData(e.date);
      bool validaE = validateEmail(e.email);
      bool validaV = validateVia(e.via);
      bool validaC = validateCitta(e.citta);
      bool validaP = validateProvincia(e.provincia);

      if (validaN &&
          validaD &&
          validaI &&
          validaData &&
          validaE &&
          validaV &&
          validaC &&
          validaP) {
        result = await service.addEvento(e);
        expect(result, true);
        print('Aggiunta evento andata a buon fine: TEST SUPERATO 7.1_10');
      } else {
        expect(result, null);
        print(
            'Aggiunta evento non andata a buon fine: TEST NON SUPERATO 7.1_10');
      }
    });
  });
}
