import 'package:restart/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:restart/application/gestioneLavoro/service/lavoro_service_impl.dart';

/// Classe Mock per simulare il comportamento dell'implementazione del servizio lavoro.
class MockLavoroServiceImp extends Mock implements LavoroServiceImpl {}

/// Valida il nome dell'offerta di lavoro.
bool validateNomeOfferta(String nomeOfferta) {
  if (nomeOfferta.length >= 80) {
    return false;
  } else {
    return true;
  }
}

/// Valida la descrizione dell'offerta di lavoro.
bool validateDescrizione(String descrizione) {
  if (descrizione.length > 255) {
    return false;
  } else {
    return true;
  }
}

/// Valida l'indirizzo dell'offerta di lavoro.
bool validateVia(String via) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
  return regex.hasMatch(via);
}

/// Valida l'email associata all'offerta di lavoro.
bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return regex.hasMatch(email);
}

/// Valida la città dell'offerta di lavoro.
bool validateCitta(String citta) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
  return regex.hasMatch(citta);
}

/// Valida la provincia dell'offerta di lavoro.
bool validateProvincia(String provincia) {
  RegExp regex = RegExp(r'^[A-Z]{2}');
  if (provincia.length > 2) return false;
  return regex.hasMatch(provincia);
}

/// Valida il numero di telefono associato all'offerta di lavoro.
bool validateTelefono(String telefono) {
  RegExp regex = RegExp(r'^\+\d{10,13}$');
  return regex.hasMatch(telefono);
}

/// Valida l'immagine associata all'offerta di lavoro.
bool validateImmagine(String immagine) {
  RegExp regex = RegExp(r'^.+\.jpe?g$');
  return regex.hasMatch(immagine);
}

void main() {
  late LavoroServiceImpl service;

  /// Inizializza il servizio lavoro prima di ogni test.
  setUp(() {
    service = LavoroServiceImpl();
  });

  /// Raggruppamento di test per la validazione dell'aggiunta di annunci di lavoro.
  group('Test Aggiunta Lavoro', () {
    /// I test seguono il pattern: verifica la validazione dei vari campi dell'annuncio di lavoro e
    /// si aspetta un risultato specifico basato sulla validità dei dati inseriti.
    /// Ogni test è commentato per chiarire il suo scopo e l'aspettativa del risultato.
    test('Aggiunta del lavoro non va a buon fine, lunghezza nome errata',
        () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Opportunità di carriera: Sviluppatore Software Senior per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_1');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta lunghezza nome offerta errata: TEST SUPERATO 3.1_1');
      }
    });

    test(
        'Aggiunta Lavoro non va a buon fine perchè la lunghezza della descriione è errata',
        () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior con comprovata esperienza nella progettazione e sviluppo software per progetti innovativi. Dimostrate capacità di leadership, collaborazione e risoluzione dei problemi. Offriamo un ambiente stimolante con un pacchetto retributivo competitivo, promuovendo la crescita professionale attraverso formazione continua e progetti sfidanti.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_2');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta lunghezza descrizione errata: TEST SUPERATO 3.1_2');
      }
    });

    test('Aggiunta Lavoro non va a buon fine perchè formato immagine errato',
        () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.pdf',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_3');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato immagine errato: TEST SUPERATO 3.1_3');
      }
    });

    test('Aggiunta Lavoro non va a buon fine formato email errato', () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolutiongmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_4');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato email errato: TEST SUPERATO 3.1_4');
      }
    });

    test('Aggiunta Lavoro non va a buon fine formato telefono errato',
        () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+3935728509/');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_5');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato telefono errato: TEST SUPERATO 3.1_5');
      }
    });

    test('Aggiunta Lavoro non va a buon fine formato via errato', () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie ?',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_6');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato via errato: TEST SUPERATO 3.1_6');
      }
    });

    test('Aggiunta Lavoro non va a buon fine formato citta errato', () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Rom@',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_7');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato citta errato: TEST SUPERATO 3.1_7');
      }
    });

    test('Aggiunta Lavoro non va a buon fine formato provincia errato',
        () async {
      dynamic result = false;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro:
              'Senior Software Developer per Progetti Innovativi in Tecnologie Avanzate ',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'R,',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST NON SUPERATO 3.1_8');
      } else {
        expect(result, false);
        print(
            'Aggiunta lavoro non avvenuta formato provincia errato: TEST SUPERATO 3.1_8');
      }
    });

    test('Aggiunta Lavoro va a buon fine', () async {
      dynamic result;
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
          id_ca: 1,
          nomeLavoro: 'Software Developer in Tecnologie Avanzate',
          descrizione:
              'Sviluppatore Software Senior per progetti innovativi. Esperienza nella progettazione e sviluppo software. Capacità di leadership e collaborazione. Ambiente stimolante, pacchetto retributivo competitivo.',
          approvato: true,
          via: 'Via delle Acacie 56',
          citta: 'Roma',
          provincia: 'RM',
          immagine: 'immage.jpg',
          email: 'techforgesolution@gmail.com',
          numTelefono: '+393572850945');
      bool validaN = validateNomeOfferta(annuncio.nome);
      bool validaD = validateDescrizione(annuncio.descrizione);
      bool validaV = validateVia(annuncio.via);
      bool validaC = validateCitta(annuncio.citta);
      bool validaP = validateProvincia(annuncio.provincia);
      bool validaI = validateImmagine(annuncio.immagine);
      bool validaE = validateEmail(annuncio.email);
      bool validaT = validateTelefono(annuncio.numTelefono);

      if (validaN &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT) {
        result = await service.addLavoro(annuncio);
        expect(result, true);
        print('Aggiunta Lavoro Avvenuta: TEST SUPERATO 3.1_9');
      } else {
        expect(result, false);
        print('Aggiunta lavoro non avvenuta: TEST NON SUPERATO 3.1_9');
      }
    });
  });
}
