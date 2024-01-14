import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/model/entity/alloggio_temporaneo_DTO.dart';
import '../../../lib/application/gestioneReintegrazione/service/reintegrazione/reintegrazione_service_impl.dart';
import '../../../lib/model/dao/alloggio_temporaneo/alloggio_temporaneo_DAO_impl.dart';



class MockReintegrazioneServiceImpl extends Mock
  implements AlloggioTemporaneoDAOImpl{}

bool validateNome(String nome){
  if(nome.length >= 30 )
    return false;
  else
    return true;
}
bool validateDescrizione(String descirzione){
  if(descirzione.length >= 50 )
    return false;
  else
    return true;
}
bool validateTipo(String tipo){
  if(tipo.length >= 40 )
    return false;
  else
    return true;
}
bool validateCItta(String citta){
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
  return regex.hasMatch(citta);
}
bool validateProvincia(String provincia) {
  RegExp regex = RegExp(r'^[A-Z]{2}');
  if (provincia.length > 2) return false;
  return regex.hasMatch(provincia);
}
bool validateVia(String via) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
  return regex.hasMatch(via);
}
bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return regex.hasMatch(email);
}
bool validateSito(String sito){
  RegExp regex = RegExp(
      r'^(?:(?:https?|ftp):\/\/)?' // Protocollo (opzionale)
      r'(?:www\.)?'                 // Prefisso "www" (opzionale)
      r'([a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+)' // Dominio (obbligatorio)
      r'(?:\/[^\s]*)?$');            // Percorso (opzionale)

  return regex.hasMatch(sito);
}
bool validateImmagine(String immagine) {
  RegExp regex = RegExp(r'^.+\.jpe?g$');
  return regex.hasMatch(immagine);
}

void main(){
  late ReintegrazioneServiceImpl service;
  setUp(() {
    service = ReintegrazioneServiceImpl(); 
  });
  
  group('Test aggiunta alloggio temporaneo', () {
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,lunghezza nome errata', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria, appartamento tranquillo nel centro urbano di Milano con vista panoramica e servizi esclusivi per un soggiorno indimenticabile.',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: '“Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 269',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_1 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO ; TC_6.1_1');
      }
    });

    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,lunghezza descirzione errata', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Esclusivo appartamento situato nel centro urbano di Milano, spazioso e luminoso, offre una suggestiva vista panoramica sulla città. Gli arredi moderni e ambienti accoglienti creano l’atmosfera perfetta per soggiorni memorabili, regalando un’esperienza unica nel cuore pulsante della metropoli.',
        tipo: '“Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 269',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_2  ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_2');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,lunghezza tipo errata', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento, abitazione, casa, dimora, alloggio, condominio, residenza',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 269',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_3 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_3');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato sito errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 269',
        email: 'casavaleria@gmail.com',
        sito: 'wwwcasavaleria',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_4 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_4');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato email errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 269',
        email: 'casavaleria@gmailom',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_5 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_5');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato via errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, \$',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_6 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_6');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato citta errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano&',
        provincia: 'MI',
        via: 'Via Dante, 256',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_7  ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_7');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato provincia errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI,',
        via: 'Via Dante, 256',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO : TC_6.1_8 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO : TC_6.1_8');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato immagina errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 256',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.pdf',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO TC_6.1_9 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO TC_6.1_9');
      }
    });
    test(
        'aggiunta dell alloggio temporaneo non va a buon fine,formato citta errato', () async {
      dynamic result = false;
      AlloggioTemporaneoDTO at = AlloggioTemporaneoDTO(
        nome: 'Casa Valeria',
        descrizione: 'Spazioso appartamento nel centro urbano di Milano con vista panoramica sulla città, arredi moderni e ambienti accoglienti per soggiorni memorabili.',
        tipo: 'Appartamento',
        citta: 'Milano',
        provincia: 'MI',
        via: 'Via Dante, 256',
        email: 'casavaleria@gmail.com',
        sito: 'www.casavaleria.it',
        immagine: 'casavaleria.jpg',


      );
      bool validateN = validateNome(at.nome);
      bool validateDescr = validateDescrizione(at.descrizione);
      bool validateT = validateTipo(at.tipo);
      bool validateC = validateCItta(at.citta);
      bool validateP = validateProvincia(at.provincia);
      bool validateV = validateVia(at.via);
      bool validateE = validateEmail(at.email);
      bool validateS = validateSito(at.sito);
      bool validateI = validateImmagine(at.immagine);
      if (validateN &&
          validateDescr &&
          validateT &&
          validateC &&
          validateP &&
          validateV &&
          validateE &&
          validateS &&
          validateI) {
        result = await service.addAlloggio(at);
        expect(result, true);
        print('Aggiunta alloggio temporaneo Avvenuta: TEST NON SUPERATO TC_6.1_10 ');
      } else {
        expect(result, false);
        print('Aggiunta alloggio temporaneo non avvenuta :TEST SUPERATO TC_6.1_10');
      }
    }
  );
});
}