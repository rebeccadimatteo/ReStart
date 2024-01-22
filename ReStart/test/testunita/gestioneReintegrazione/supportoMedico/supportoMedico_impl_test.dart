import 'package:restart/model/dao/supporto_medico/supporto_medico_DAO_impl.dart';
import 'package:restart/model/entity/supporto_medico_DTO.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:restart/application/gestioneReintegrazione/service/reintegrazione/reintegrazione_service_impl.dart';

/// Classe Mock per simulare l'implementazione del servizio di reintegrazione.
class MockReintegrazioneServiceImp extends Mock
    implements ReintegrazioneServiceImpl {}

/// Classe Mock per simulare l'implementazione del DAO di supporto medico.
class MockSupportoMedicoImpl extends Mock implements SupportoMedicoDAOImpl {}

/// Valida il nome del medico.
bool validateNome(String nome) {
  if (nome.length >= 30)
    return false;
  else
    return true;
}

/// Valida il cognome del medico.
bool validateCognome(String cognome) {
  if (cognome.length >= 30)
    return false;
  else
    return true;
}

/// Valida il tipo di supporto medico.
bool validateTipo(String tipo) {
  if (tipo.length >= 40)
    return false;
  else
    return true;
}

/// Valida la descrizione del supporto medico.
bool validateDescrizione(String descrizione) {
  if (descrizione.length >= 200)
    return false;
  else
    return true;
}

/// Valida la via del supporto medico.
bool validateVia(String via) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
  return regex.hasMatch(via);
}

/// Valida l'email del supporto medico.
bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return regex.hasMatch(email);
}

/// Valida la città del supporto medico.
bool validateCitta(String citta) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
  return regex.hasMatch(citta);
}

/// Valida la provincia del supporto medico.
bool validateProvincia(String provincia) {
  RegExp regex = RegExp(r'^[A-Z]{2}');
  if (provincia.length > 2) return false;
  return regex.hasMatch(provincia);
}

/// Valida il numero di telefono del supporto medico.
bool validateTelefono(String telefono) {
  RegExp regex = RegExp(r'^\+\d{10,13}$');
  return regex.hasMatch(telefono);
}

/// Valida l'immagine del supporto medico.
bool validateImmagine(String immagine) {
  RegExp regex = RegExp(r'^.+\.jpe?g$');
  return regex.hasMatch(immagine);
}

void main() {
  late ReintegrazioneServiceImpl service;

  /// Inizializzazione del servizio di reintegrazione prima di ogni test.
  setUp(() {
    service = ReintegrazioneServiceImpl();
  });

  /// Gruppo di test per la verifica dell'aggiunta di un supporto medico.
  group('Test Aggiunta Supporto medico', () {
    /// Ogni test verifica la conformità di un campo specifico (nome, cognome, tipo, ecc.)
    /// e si aspetta un risultato specifico basato sulla validità dei dati inseriti.
    /// Ogni test è commentato per chiarire il suo scopo e l'aspettativa del risultato.
    /// I test sono stati suddivisi in 2 gruppi: test superati e test non superati.
    test(
        'Aggiunta del supporto medico non va a buon fine, lunghezza nome errata',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico:
              'Bartholomew Alexander MacAllister III Esquire de Montague III',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_1');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_1');
      }
    });

    test(
        'Aggiunta Supporto medico non va a buon fine, lunghezza cognome errata',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico:
              'Giordano Olimpio Sesto Chillemi De Vito Salvo Guarnaccia Turre',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_2');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_2');
      }
    });

    test(
        'Aggiunta Supporto medico non va a buon fine, lunghezza descrizione errata',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione:
              'Dentista pulito e sicuro con ottime capacità e dispositivi all’avanguardia. Il suo risulta essere uno fra i più puliti e moderni di Milano. Il dentista ha ottime capacità chirurgiche, ti accoglierà con gioia e socialità nel suo studio.',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_3');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_3');
      }
    });

    test('Aggiunta Supporto medico non va a buon fine, lunghezza tipo errata',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Esperto odontotecnico crea protesi dentali con precisione',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_4');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_4');
      }
    });

    test('Aggiunta Supporto medico non va a buon fine, formato email errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordanogmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_5');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_5');
      }
    });
    test('Aggiunta Supporto medico non va a buon fine, formato telefono errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_6');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_6');
      }
    });

    test('Aggiunta Supporto medico non va a buon fine, formato via errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '3495269914',
          via: 'Via della Moscova365',
          citta: 'Milano3',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_7');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_7');
      }
    });

    test('Aggiunta Supporto medico non va a buon fine, formato citta errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '+393495269914',
          via: 'Via della Moscova',
          citta: 'Milano3',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_8');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_8');
      }
    });

    test(
        'Aggiunta Supporto medico non va a buon fine, formato provincia errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '+393495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI3');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_9');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_9');
      }
    });

    test('Aggiunta Supporto medico non va a buon fine, formato immagine errato',
        () async {
      dynamic result = false;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.pdf',
          email: 'bgiordano@gmail.com',
          numTelefono: '+393495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST NON SUPERATO 4.1_10');
      } else {
        expect(result, false);
        print('Aggiunta supporto medico non avvenuta: TEST SUPERATO 4.1_10');
      }
    });

    test('Aggiunta Supporto medico va a buon fine', () async {
      dynamic result;
      SupportoMedicoDTO su = SupportoMedicoDTO(
          nomeMedico: 'Bartolomeo',
          cognomeMedico: 'Giordano',
          descrizione: 'Dentista pulito e sicuro',
          tipo: 'Odontotecnico',
          immagine: 'Bartolomeo.jpg',
          email: 'bgiordano@gmail.com',
          numTelefono: '+393495269914',
          via: 'Via della Moscova',
          citta: 'Milano',
          provincia: 'MI');
      bool validaN = validateNome(su.nomeMedico);
      bool validaCog = validateCognome(su.cognomeMedico);
      bool validaD = validateDescrizione(su.descrizione);
      bool validaV = validateVia(su.via);
      bool validaC = validateCitta(su.citta);
      bool validaP = validateProvincia(su.provincia);
      bool validaI = validateImmagine(su.immagine);
      bool validaE = validateEmail(su.email);
      bool validaT = validateTelefono(su.numTelefono);
      bool validaTipo = validateTipo(su.tipo);

      if (validaN &&
          validaCog &&
          validaD &&
          validaV &&
          validaC &&
          validaP &&
          validaI &&
          validaE &&
          validaT &&
          validaTipo) {
        result = await service.addSupportoMedico(su);
        expect(result, true);
        print('Aggiunta supporto medico Avvenuta: TEST SUPERATO 4.1_11');
      } else {
        expect(result, false);
        print(
            'Aggiunta supporto medico non avvenuta: TEST NON SUPERATO 4.1_11');
      }
    });
  });
}
