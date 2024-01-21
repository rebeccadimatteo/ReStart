import 'package:intl/intl.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:restart/application/gestioneRegistrazione/service/registrazione_service_impl.dart';
import 'package:restart/model/dao/autenticazione/utente/utente_DAO.dart';
import 'package:restart/model/entity/utente_DTO.dart';

class MockRegistrazioneServiceImpl extends Mock
    implements RegistrazioneServiceImpl {}

class MockUtenteDAO extends Mock implements UtenteDAO {}

bool validateCodiceFiscale(String codiceFiscale) {
  RegExp regex = RegExp(r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');
  return regex.hasMatch(codiceFiscale);
}

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return regex.hasMatch(email);
}

bool validateUsername(String username) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9_.@]{3,15}$');
  return regex.hasMatch(username);
}

bool validateVia(String via) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
  return regex.hasMatch(via);
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

bool validateNome(String nome) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
  return regex.hasMatch(nome);
}

bool validateCognome(String cognome) {
  RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
  return regex.hasMatch(cognome);
}

bool validatePassword(String password) {
  return password.length <= 15 && password.length >= 3;
}

bool validateLuogoNascita(String luogo_nascita) {
  RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{3,20}$');
  return regex.hasMatch(luogo_nascita);
}

bool validateData(DateTime data) {
  String dataString = DateFormat('yyyy-MM-dd').format(data);
  RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  return regex.hasMatch(dataString);
}

void main() {
  late RegistrazioneServiceImpl service;

  setUp(() {
    service = RegistrazioneServiceImpl();
  });

  group('Test Registrazione', () {
    test(
        'La Registrazione non va a buon fine perchè il formato del nome è errato',
        () async {
      bool result = true;
      UtenteDTO ug = UtenteDTO(
          nome: 'Ald0',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_1');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione nome completata e formato non corretto: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè il formato del cognome è errato',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi.',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_2');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione cognome completata e formato non corretto: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè la lunghezza del luogo di nascita è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Distretto Di Santo Antonio Descoberto',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_3');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione luogo di nascita completata e lunghezza errata: TEST SUPERATO');
      }
    });
    test('La Registrazione non va a buon fine perchè formato email è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchigmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta con successo: TEST NON SUPERATO 1.1_4');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione email completata e formato errato: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè lunghezza password è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'AldoBianchi2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta con successo: TEST NON SUPERATO 1.1_5');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione password completata e lunghezza errata: TEST SUPERATO');
      }
    });
    test('La Registrazione non va a buon fine perchè formato data è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(15 - 02 - 2002),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'AldoBianchi2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta con successo: TEST NON SUPERATO 1.1_6');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione data di nascita completata e formato errato: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè la lunghezza della via è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Distretto Di Santo Antonio Descoberto',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_7');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione via completata e lunghezza errata: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè il formato della citta è errata',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'N4poli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_8');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione citta completata e formato errato: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè il formato della provincia è errato',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'Napoli');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_9');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione provincia completata e formato errato: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè la lunghezza dello username è errato',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi2002_',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_10');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione username completata e lunghezza errata: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè il formato dell immagine è errato',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026255',
          immagine: 'immage.gif',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_11');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione immagine completata e formato errato: TEST SUPERATO');
      }
    });
    test(
        'La Registrazione non va a buon fine perchè la lunghezza del numero del telefono è errato',
        () async {
      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD85M01H501A',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '3290026255',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');

      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        bool result = await service.signUp(ug);
        expect(result, false);
        if (result) {
          print('Registrazione avvenuta: TEST NON SUPERATO 1.1_12');
        }
      } else {
        print(
            'Registrazione non avvenuta, validazione numero di telefono completata e lunghezza errata: TEST SUPERATO');
      }
    });
    test('La Registrazione va a buon fine', () async {
      dynamic result;

      UtenteDTO ug = UtenteDTO(
          nome: 'Aldo',
          cognome: 'Bianchi',
          cod_fiscale: 'BNCALD02R23H703F',
          data_nascita: DateTime(2002, 02, 15),
          luogo_nascita: 'Napoli',
          genere: 'M',
          username: 'aldobianchi',
          password: 'Aldo2002@!',
          email: 'aldobianchi@gmail.com',
          num_telefono: '+393290026254',
          immagine: 'immage.jpg',
          via: 'Via Fratelli Napoli 1',
          citta: 'Napoli',
          provincia: 'NA');
      bool validaN = validateNome(ug.nome);
      bool validaC = validateCognome(ug.cognome);
      bool validaData = validateData(ug.data_nascita);
      bool validaLuogo = validateLuogoNascita(ug.luogo_nascita);
      bool validaV = validateVia(ug.via);
      bool validaCitta = validateCitta(ug.citta);
      bool validaPr = validateProvincia(ug.provincia);
      bool validaEmail = validateEmail(ug.email);
      bool validaPsw = validatePassword(ug.password);
      bool validaUsr = validateUsername(ug.username);
      bool validaImg = validateImmagine(ug.immagine);
      bool validaTel = validateTelefono(ug.num_telefono);
      bool validaCF = validateCodiceFiscale(ug.cod_fiscale);

      if (validaN &&
          validaC &&
          validaData &&
          validaLuogo &&
          validaV &&
          validaCitta &&
          validaPr &&
          validaEmail &&
          validaPsw &&
          validaUsr &&
          validaImg &&
          validaTel &&
          validaCF) {
        result = await service.signUp(ug);
        expect(result, true);
        if (result) {
          print('Registrazione avvenuta: TEST SUPERATO 1.1_13');
        } else {
          print('Registrazione non avvenuta: TEST NON SUPERATO');
        }
      }
    });
  });
}
