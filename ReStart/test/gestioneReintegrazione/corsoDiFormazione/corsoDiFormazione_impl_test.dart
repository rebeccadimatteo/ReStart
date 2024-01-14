import '../../../lib/model/dao/corso_di_formazione/corso_di_formazione_DAO_impl.dart';
import '../../../lib/model/entity/corso_di_formazione_DTO.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/application/gestioneReintegrazione/service/reintegrazione/reintegrazione_service_impl.dart';

class MockReintegrazioneServiceImp extends Mock
    implements ReintegrazioneServiceImpl {}

class MockCorsoDiFormazione extends Mock implements CorsoDiFormazioneDAOImpl {}

bool validateNomeCorso(String nome) {
  if (nome.length >= 50)
    return false;
  else
    return true;
}

bool validateNome(String nome) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
  return regex.hasMatch(nome);
}

bool validateCognome(String cognome) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
  return regex.hasMatch(cognome);
}

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

bool validateTelefono(String telefono) {
  RegExp regex = RegExp(r'^\+\d{10,13}$');
  return regex.hasMatch(telefono);
}

bool validateImmagine(String immagine) {
  RegExp regex = RegExp(r'^.+\.jpe?g$');
  return regex.hasMatch(immagine);
}

void main() {
  late ReintegrazioneServiceImpl service;

  setUp(() {
    service = ReintegrazioneServiceImpl();
  });

  group('Test Aggiunta Corso di formazione', () {
    test(
        'Aggiunta del corso di formazione non va a buon fine, lunghezza nome corso errata',
        () async {
      dynamic result;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso:
              'Masterclass Python per IA: Sviluppo Avanzato di Modelli Intelligenti',
          nomeResponsabile: 'Giovanni',
          cognomeResponsabile: 'Rossi',
          descrizione:
              'Corso completo di Python orientato allo sviluppo di modelli di IA',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.jpg');

      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_1');
      } else {
        expect(result, null);
        print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_1');
      }
    });
    test(
        'Aggiunta del corso di formazione non va a buon fine, lunghezza descrizione errata',
        () async {
      dynamic result;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
          nomeResponsabile: 'Giovanni',
          cognomeResponsabile: 'Rossi',
          descrizione:
              'Esplora le straordinarie potenzialità dell’Intelligenza Artificiale partecipando alla nostra entusiasmante Masterclass Python. Questo corso offre un\'opportunità unica di approfondire le tue competenze nello sviluppo di modelli avanzati, consentendoti di immergerti nel mondo affascinante della programmazione e dell\'apprendimento automatico. Conduciamo una formazione completa e approfondita, fornendo conoscenze fondamentali e pratiche su temi quali reti neurali, algoritmi di apprendimento automatico e analisi dei dati.)',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.jpg');

      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_2');
      } else {
        expect(result, null);
        print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_2');
      }
    });
    test(
        'Aggiunta del corso di formazione non va a buon fine, formato immagine errata',
        () async {
      dynamic result = false;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
          nomeResponsabile: 'Giovanni',
          cognomeResponsabile: 'Rossi',
          descrizione:
              'Corso completo di Python orientato allo sviluppo di modelli di IA',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.pdf');
      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_3');
      } else {
        expect(result, false);
        print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_3');
      }
    });
    test(
        'Aggiunta corso di formazione non va a buon fine, formato nome responsabile errata',
        () async {
      dynamic result = false;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
          nomeResponsabile: 'Giovann1',
          cognomeResponsabile: 'Rossi',
          descrizione:
              'Corso completo di Python orientato allo sviluppo di modelli di IA',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.jpg');
      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_4');
      } else {
        expect(result, false);
        print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_4');
      }
    });
    test(
        'Aggiunta corso di formazione non va a buon fine, formato cognome responsabile errato',
        () async {
      dynamic result = false;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
          nomeResponsabile: 'Giovanni',
          cognomeResponsabile: 'Rossi.',
          descrizione:
              'Corso completo di Python orientato allo sviluppo di modelli di IA',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.jpg');
      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_5');
      } else {
        expect(result, false);
        print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_5');
      }
    });
    // test(
    //     'Aggiunta corso di formazione non va a buon fine, formato email errato',
    //     () async {
    //   dynamic result = false;
    //   CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
    //       nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
    //       nomeResponsabile: 'Giovanni',
    //       cognomeResponsabile: 'Rossi',
    //       descrizione:
    //           'Corso completo di Python orientato allo sviluppo di modelli di IA',
    //       urlCorso: 'https://www.example.com/corso-python-avanzato',
    //       immagine: 'PythonCourse.jpg');
    //   bool validaNC = validateNomeCorso(c.nomeCorso);
    //   bool validaN = validateNome(c.nomeResponsabile);
    //   bool validaCog = validateCognome(c.cognomeResponsabile);
    //   bool validaD = validateDescrizione(c.descrizione);
    //   bool validaI = validateImmagine(c.immagine);
    //
    //   if (validaNC && validaN && validaCog && validaD && validaI) {
    //     result = await service.addCorso(c);
    //     expect(result, true);
    //     print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_6');
    //   } else {
    //     expect(result, false);
    //     print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_6');
    //   }
    // });
    // test('Aggiunta corso di formazione non va a buon fine, formato via errato',
    //     () async {
    //   dynamic result = false;
    //   CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
    //       nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
    //       nomeResponsabile: 'Giovanni',
    //       cognomeResponsabile: 'Rossi',
    //       descrizione:
    //           'Corso completo di Python orientato allo sviluppo di modelli di IA',
    //       urlCorso: 'https://www.example.com/corso-python-avanzato',
    //       immagine: 'PythonCourse.jpg');
    //   bool validaNC = validateNomeCorso(c.nomeCorso);
    //   bool validaN = validateNome(c.nomeResponsabile);
    //   bool validaCog = validateCognome(c.cognomeResponsabile);
    //   bool validaD = validateDescrizione(c.descrizione);
    //   bool validaI = validateImmagine(c.immagine);
    //
    //   if (validaNC && validaN && validaCog && validaD && validaI) {
    //     result = await service.addCorso(c);
    //     expect(result, true);
    //     print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_7');
    //   } else {
    //     expect(result, false);
    //     print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_7');
    //   }
    // });
    // test(
    //     'Aggiunta corso di formazione non va a buon fine, formato citta errato',
    //     () async {
    //   dynamic result = false;
    //   CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
    //       nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
    //       nomeResponsabile: 'Giovanni',
    //       cognomeResponsabile: 'Rossi',
    //       descrizione:
    //           'Corso completo di Python orientato allo sviluppo di modelli di IA',
    //       urlCorso: 'https://www.example.com/corso-python-avanzato',
    //       immagine: 'PythonCourse.jpg');
    //   bool validaNC = validateNomeCorso(c.nomeCorso);
    //   bool validaN = validateNome(c.nomeResponsabile);
    //   bool validaCog = validateCognome(c.cognomeResponsabile);
    //   bool validaD = validateDescrizione(c.descrizione);
    //   bool validaI = validateImmagine(c.immagine);
    //
    //   if (validaNC && validaN && validaCog && validaD && validaI) {
    //     result = await service.addCorso(c);
    //     expect(result, true);
    //     print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_8');
    //   } else {
    //     expect(result, false);
    //     print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_8');
    //   }
    // });
    // test(
    //     'Aggiunta corso di formazione non va a buon fine, formato provincia errato',
    //     () async {
    //   dynamic result = false;
    //   CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
    //       nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
    //       nomeResponsabile: 'Giovanni',
    //       cognomeResponsabile: 'Rossi',
    //       descrizione:
    //           'Corso completo di Python orientato allo sviluppo di modelli di IA',
    //       urlCorso: 'https://www.example.com/corso-python-avanzato',
    //       immagine: 'PythonCourse.jpg');
    //   bool validaNC = validateNomeCorso(c.nomeCorso);
    //   bool validaN = validateNome(c.nomeResponsabile);
    //   bool validaCog = validateCognome(c.cognomeResponsabile);
    //   bool validaD = validateDescrizione(c.descrizione);
    //   bool validaI = validateImmagine(c.immagine);
    //
    //   if (validaNC && validaN && validaCog && validaD && validaI) {
    //     result = await service.addCorso(c);
    //     expect(result, true);
    //     print('Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_9');
    //   } else {
    //     expect(result, false);
    //     print('Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_9');
    //   }
    // });
    // test(
    //     'Aggiunta corso di formazione non va a buon fine, formato telefono errato',
    //     () async {
    //   dynamic result = false;
    //   CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
    //       nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
    //       nomeResponsabile: 'Giovanni',
    //       cognomeResponsabile: 'Rossi',
    //       descrizione:
    //           'Corso completo di Python orientato allo sviluppo di modelli di IA',
    //       urlCorso: 'https://www.example.com/corso-python-avanzato',
    //       immagine: 'PythonCourse.jpg');
    //   bool validaNC = validateNomeCorso(c.nomeCorso);
    //   bool validaN = validateNome(c.nomeResponsabile);
    //   bool validaCog = validateCognome(c.cognomeResponsabile);
    //   bool validaD = validateDescrizione(c.descrizione);
    //   bool validaI = validateImmagine(c.immagine);
    //
    //   if (validaNC && validaN && validaCog && validaD && validaI) {
    //     result = await service.addCorso(c);
    //     expect(result, true);
    //     print(
    //         'Aggiunta corso di formazione Avvenuta: TEST NON SUPERATO 5.1_10');
    //   } else {
    //     expect(result, false);
    //     print(
    //         'Aggiunta corso di formazione non avvenuta: TEST SUPERATO 5.1_10');
    //   }
    // });
    test('Aggiunta corso di formazione va a buon fine', () async {
      dynamic result;
      CorsoDiFormazioneDTO c = CorsoDiFormazioneDTO(
          nomeCorso: 'Python per IA:Sviluppo modelli avanzati',
          nomeResponsabile: 'Giovanni',
          cognomeResponsabile: 'Rossi',
          descrizione:
              'Corso completo di Python orientato allo sviluppo di modelli di IA',
          urlCorso: 'https://www.example.com/corso-python-avanzato',
          immagine: 'PythonCourse.jpg');

      bool validaNC = validateNomeCorso(c.nomeCorso);
      bool validaN = validateNome(c.nomeResponsabile);
      bool validaCog = validateCognome(c.cognomeResponsabile);
      bool validaD = validateDescrizione(c.descrizione);
      bool validaI = validateImmagine(c.immagine);

      if (validaNC && validaN && validaCog && validaD && validaI) {
        result = await service.addCorso(c);
        expect(result, true);
        print('Aggiunta corso di formazione Avvenuta: TEST SUPERATO 5.1_6');
      } else {
        expect(result, false);
        print(
            'Aggiunta corso di formazione non avvenuta: TEST NON SUPERATO 5.1_6');
      }
    });
  });
}
